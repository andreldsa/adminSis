#!/bin/bash

NOME=$1_$2
SAIDA_TEMPORARIA="/tmp/EXERCICIO_$NOME.out"

if [ -e $SAIDA_TEMPORARIA ]; then
	rm $SAIDA_TEMPORARIA
fi

bash EXERCICIO_$NOME.sh < EXERCICIO_$1.in > /tmp/EXERCICIO_$NOME.out

if [ $(diff /tmp/EXERCICIO_$NOME.out EXERCICIO_$1.out | wc -l) -gt 0 ]; then 
	echo -e "\n=========== Diff do exercício $1 do aluno: $2 =============="
	diff /tmp/EXERCICIO_$NOME.out EXERCICIO_$1.out
else
	echo -e "\n>>>> Exercício $1 do aluno $2 está correto."
fi
