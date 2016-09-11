# !/bin/bash
# by Andre L. Abrantes - Setembro de 2016

ARQUIVOS=$1

# Compara dois checksum's passados como parâmetros
# @arg $1 
#	Checksum a ser comparado
# @arg $2
#	Outro checksum a ser comparado
# @arg $3
#	Nome do arquivo
function comparaCheckSum() {
	if [ "$1" != "$2" ]; then
		echo "ERROR $3"
	else
		echo "OK $3"
	fi
}

# Executa o checksum para um arquivo passado como parametro
#
# @arg $1 
#       Checksum original de entrada
# @arg $2
#       Algoritmo a ser calculado o checksum
# @arg $3
#       Nome do arquivo
function checkSum() {
	SUM=$1
	ALGORITMO=$2
	ARQUIVO=$3

	if [ -e $ARQUIVO ]; then
		case $ALGORITMO in
			MD5)
				out=$(md5sum $ARQUIVO | cut -d' ' -f1)
				comparaCheckSum $out $SUM $ARQUIVO
				;;
			SHA1)
				out=$(sha1sum $ARQUIVO | cut -d' ' -f1)
                                comparaCheckSum $out $SUM $ARQUIVO
				;;
			CRC)
				out=$(cksum $ARQUIVO | cut -d' ' -f1)
                                comparaCheckSum $out $SUM $ARQUIVO
				;;
		esac
	else
		echo "NOT_FOUND $ARQUIVO"
	fi
}

if [ -f $ARQUIVOS ]; then
	# Executa o checksum para n arquivos em um arquivo de entrada
	while read arquivo; do
		checkSum $arquivo
	done < $ARQUIVOS
else
	# Caso o argumento seja um diretório calcula o md5 de cada arquivo do
	# diretório.
	for arquivo in $(ls $ARQUIVOS); do
	if [ -f $ARQUIVOS$arquivo ]; then
		echo "MD5: {$(md5sum $ARQUIVOS$arquivo | cut -d' ' -f1)} $arquivo"
	fi
	done
fi

exit 1
