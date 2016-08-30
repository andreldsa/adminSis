#!/bin/bash
# by André L. Abrantes - Agosto de 2016

# Faz a checagem de cada domínio do arquivo de entrada
# @param $1 path do arquivo
function executaArquivo {
	for dominio in $(cat $1); do
		executaDominio $dominio
	done
}

# Faz a checagem de um único domínio recebido como parâmetro
# @param $1 domínio a ser checado
function executaDominio {
	SAIDA="/tmp/dominioCheck.out"
	dataInicial=$(date +%s.%3N) # Captura início da requisição
	getent hosts $1 > $SAIDA # Faz a requisição ao domínio
	RESULTADO=$? # Atribui saida da requisição
	dataFinal=$(date +%s.%3N) # Captura final da requisição
	TEMPO=$(echo "scale=3;$dataFinal - $dataInicial" | bc) # Calcula tempo da requisição
	if [ $RESULTADO -eq 0 ]; then # Se o domínio é válido
		NUM_IPS=$(cat $SAIDA | wc -l) # Conta número de IP's
		MOBILE=""
		getent hosts "m.$1" > $SAIDA # Verifica subdomínio mobile
		if [ $? -eq 0 ]; then
			MOBILE="MOBILE"
		fi
		echo "$1 $NUM_IPS $MOBILE || Tempo da Requisição: $TEMPO segundos"
	else # Caso o domínio seja inválido
		echo "$1 ERRO || Tempo da Requisição: $TEMPO segundos"
	fi
}

if [ $# -gt 0 ]; then
	if [ "$1" == "-f" ]; then
		# Executa o fluxo de entrada com -f
		executaArquivo $2
	else
		# Executa o fluxo com domínio como parâmetro
		executaDominio $1
	fi
fi
