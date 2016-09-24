#!/bin/bash
# by André L. Abrantes - Setembro de 2016

# Realiza backup em um arquivo .tar.gz
function backupCompactado() {
	ARQUIVO=$(echo $1 | rev | cut -d'/' -f1 | rev) # Pega o nome o arquivo
	DESTINO=$2"$ARQUIVO".tar.gz
	if [ -e $DESTINO ]; then # Se o arquivo já existe no diretório destino
		echo Erro: Arquivo existente $DESTINO
		exit 1
	else 
		tar czf $DESTINO $1 2> /dev/null
		echo Criando backup de $1 em $2"$ARQUIVO".tar.gz
	fi
}

# Realiza backup com nome do arquivo incremental caso já exista
function backupNormal() {
	ARQUIVO=$(echo $1 | rev | cut -d'/' -f1 | rev) # Pega o nome o arquivo
	DESTINO=$2"$ARQUIVO"
	if [ -e $DESTINO ]; then # Se o arquivo já existe no diretório destino
		ULTIMO_INDICE=$(ls $2 | grep $ARQUIVO'.' | sort -V -r | head -n 1 | rev | cut -d'.' -f1 | rev)
		PROXIMO_INDICE=$(($ULTIMO_INDICE + 1))
		cp -r $1 $DESTINO'.'$PROXIMO_INDICE
		echo Criando backup de $1 em $2"$ARQUIVO.$PROXIMO_INDICE"
	else
		cp -r $1 $DESTINO 
		echo Criando backup de $1 em $DESTINO
	fi
}

function checaDiretorios() {
	if [ -e $1 ]; then
		if [ -e $2 ]; then
			return 0
		else
			echo "Diretório $2 não existe"
			return 1
		fi
	else
		echo "Diretório $1 não existe"
		return 1
	fi
}

function printRelatorio() {
	echo -e "Relatório do arquivo: \n $1 \nno diretório de backup: \n $2"
	ARQUIVO=$(echo $1 | rev | cut -d'/' -f1 | rev) # Pega o nome o 
	echo -e "\nTamanho | Arquivo"
	echo -e "\n$(ls -s $2 | sed -e '1d' | sort -V -r | grep $ARQUIVO'.'[0-9])"
}

function printHelp() {
	echo "Uso: ./backup.sh [ -r | -z ] <arquivo_origem> <arquivo_destino>"
	echo -e "\nParâmetros\n"
	echo "    -r                     Mostrar relatório na pasta destino do arquivo origem"
	echo "    -z                     Realizar backup em arquivo compactado tar.gz"
}

if [ $# -eq 3 ]; then 
	case $1 in
		-z)
			backupCompactado $2 $3
		;;
		-r)
			printRelatorio $2 $3
		;;
		*)
			printHelp
		;;
	esac
elif [ $# -eq 2 ]; then
	IF=$(checaDiretorios $1 $2)
	if [ "$IF" == "" ]; then 
		backupNormal $1 $2
	else
		echo "Erro: $IF"
	fi
else
	printHelp
fi