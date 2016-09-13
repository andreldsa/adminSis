#!/bin/bash
# by André L. Abrantes - Setembro de 2016

export URI=$1

# Baixa um único arquivo em uma URI específica
function downloadArquivo() {
	FILE=$1
	wget $URI"/"$FILE 2> /dev/null
}

# Baixa um diretório recursivamente
function downloadDiretorio() {
	DIRETORIO=$1
	wget -r -nH $URI"/"$DIRETORIO
}

# Varre os arquivos de uma página
for arquivo in $(curl $URI 2> /dev/null | grep href | cut -d"\"" -f2); do
	echo $arquivo
	if [[ $arquivo == *"/"* ]]; then
		downloadDiretorio $arquivo $URI"/"$arquivo
	else 
		downloadArquivo $arquivo $URI
	fi
done