#!/bin/bash
# by André L. Abrantes - Agosto de 2016

OUT_56="/tmp/xping56.out"
OUT_64="/tmp/xping64.out"

DOMINIO="google.com"

# Executa um ping em um domínio com determinado tamanho de pacote
#
# @param $1 Arquivo tmp de saída
# @param $2 Domínio
# @param $3 Tamanho do pacote
#
function pingDominio {
	OUT=$1
	DOMINIO=$2
	TAMANHO=$3

	echo -e "\nPingando $DOMINIO com 10 pacotes de $TAMANHO bytes\n"
	ping $DOMINIO -c 10 -s $TAMANHO > $OUT

	NUM_PACOTES=$(cat $OUT | grep time= | wc -l)
	MEDIANA=$(($NUM_PACOTES/2))

	# Obtém a mediana do tempo de envio
	echo Mediana: $(cat $OUT | grep time= | cut -d'=' -f4 | sort -n | sed -n "$MEDIANA"p)

	# Obtém a média dos 3 maiores tempos de envio
	echo Média: $(cat $OUT | grep time= | cut -d'=' -f4 | sort -n | tail -n 3 |  awk '{total+=$1; count++} END {print total/count}') ms

	# Mostra o número de pacotes que se perderam
	PACOTES_ENVIADOS=$(cat $OUT | grep time= | wc -l)

	echo -e "\n$((10 - $PACOTES_ENVIADOS)) pacotes foram perdidos"
}

# Imprime na saída padrão um countdown de 10 segundos para a próxima requisição
function aguarda10segundos {
	echo -e '\n'
	seq 9 -1 0 | while read i; do echo -en "\rAguardando próxima requisição... $i"; sleep 1; done
	echo -e '\n'
}

pingDominio $OUT_56 $DOMINIO 56

aguarda10segundos

pingDominio $OUT_64 $DOMINIO 64

# Respostas do questionário
# 1 - O que representa X, Y, Z na linha abaixo:
# 	PING X (Y) Z(W) bytes of data.
#	X = Domínio desejado, Y = IP do domínio, Z = Tamanho do Pacote
# 2 - O que representa A, B, C na linha abaixo:
# 	A bytes from B (C): icmp_seq=D ttl=E time=F ms
#	A = Tamanho do pacote + 8 bytes do cabeçalho do ICMP 
#	B = DNS da máquina destino
#	C = IP da máquina destino
# 3 - (Bônus) Por que, para X sendo google.com, X e B são diferentes?
#	Isso ocorre devido ao google usar clusterização permitindo que várias
#	máquinas respondam ao mesmo domínio, dessa forma o google consegue
#	balancear a carga dos servidores. O nome/domínio que aparece em B
#	é o cluster designado ao meu acesso quando tento chegar em google.com.
