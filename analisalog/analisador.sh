#!/bin/bash
# Script by André L. Abrantes
# Julho de 2016

case "$1" in
	-h | --help )
		echo "Uso:"
		echo "./analisador <-h|--help> # Irá analisar o access_log"
		echo "./analisador <nome_arquivo> <-get|-post|string_a_ser_filtrado> # Irá analisar o arquivo passado como parâmetro"
		exit 0;
		;;
esac

ARQUIVO='access_log'

# Caso o primeiro argumento de entrada exista
# usa-o como arquivo a ser analisado.
if [ $1 ]; then
	echo "Usando arquivo $1"
	ARQUIVO=$1
fi

# Conta as linhas válidas do arquivo a ser analisado
NUM_LINHAS_VALIDAS=$(awk -F: '/[local|remote] - - /' $ARQUIVO | wc -l)

# Caso o arquivo não possua linhas válidas
# o script se encerra e apresenta mensagem de erro.
if [ $NUM_LINHAS_VALIDAS -eq 0 ]; then
	echo 'Arquivo de log com formato inválido.'
	exit 1
fi

echo 'Requisições Locais:'
# Filtra as linhas com tag local e encadeia com 
# o comando de Word Count para contar as linhas
awk -F: '/[local] - - /' $ARQUIVO | wc -l

echo 'Requisições Remotas:'
# Filtra as linhas com tag remote e encadeia com 
# o comando de Word Count para contar as linhas
awk -F: '/[remote] - - /' $ARQUIVO | wc -l

echo 'Média de horas das requisições Locais:'
# Filtra as linhas com tag local e encadeia com 
# o comando cut para separar a linha usando 
# o ':' como delimitador, em seguida faz o count 
# e imprime a média das horas.
awk -F: '/[local] - - /' $ARQUIVO | cut -d':' -f2 | awk '{ total += $1; count++ } END { print total/count }'

echo 'Média de horas das requisições Remotas:'
# Filtra as linhas com tag remote e encadeia com 
# o comando cut para separar a linha usando 
# o ':' como delimitador, em seguida faz o count 
# e imprime a média das horas.
awk -F: '/[remote] - - /' $ARQUIVO | cut -d':' -f2 | awk '{ total += $1; count++ } END { print total/count }'

if [ $# -gt 1 ]; then
	case "$2" in
		-get ) 
			echo 'Número de requisições GET:'
			awk -F: '/[local|remote] - - /' $ARQUIVO | awk -F: '/GET/' $ARQUIVO | wc -l
			;;
		-post )
			echo 'Número de requisições POST:'
			awk -F: '/[local|remote] - - /' $ARQUIVO | awk -F: '/POST/' $ARQUIVO | wc -l
			;;
		* ) 
			echo "Número de requisições com $2:"
			awk -F: '/[local|remote] - - /' $ARQUIVO | awk -F: "/$2/" $ARQUIVO | wc -l
			;;
	esac
fi

exit 0