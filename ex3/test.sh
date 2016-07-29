#!/bin/bash
# by André L. Abrantes - Julho de 2016

# Função para executar o teste de um exercício.
#
# @param $1 Exercício a ser testado
# @param $2 Nome do aluno
# @param $3 Número do teste de entrada/saída
#
function testaExercicioAluno {
	EXERC=$1
	NOME=$2
	TESTE=$3
	SAIDA_TEMPORARIA="/tmp/EXERCICIO_$EXERC_$TESTE_$NOME.out"

	if [ -e $SAIDA_TEMPORARIA ]; then
		rm $SAIDA_TEMPORARIA
	fi

	bash EXERCICIO_$EXERC"_"$NOME.sh < EXERCICIO_$EXERC"_"$TESTE.in > /tmp/EXERCICIO_$EXERC"_"$TESTE"_"$NOME.out

	echo -e "\nEXERCICIO $EXERC $NOME:"

	echo "-SAIDA PARA ENTRADA $TESTE:"
	bash EXERCICIO_$EXERC"_"$NOME.sh < EXERCICIO_$EXERC"_"$TESTE.in

	echo -e "\n-DIFERENÇA PARA A SAÍDA $TESTE ESPERADA:"
	diff /tmp/EXERCICIO_$EXERC"_"$TESTE"_"$NOME.out EXERCICIO_$EXERC"_"$TESTE.out

	if [ $(diff /tmp/EXERCICIO_$EXERC"_"$TESTE"_"$NOME.out EXERCICIO_$EXERC"_"$TESTE.out | wc -l) -gt 0 ]; then
		return 1 # Saída errada
	else
		return 0 # Saída correta
	fi
}

# Função para executar um único exercício de 1 ou mais Alunos para n entradas de teste.
#
# @param $1 Número do exercício
# @param $2 Nome do Aluno [opcional]
#
function testaExercicios {
	if [ $2 ]; then
		NOMES_ALUNOS=$2
	else
		NOMES_ALUNOS=$(ls . | grep "EXERCICIO_$1[0-9A-Z_]*.sh" | cut -d'_' -f3- | cut -d'.' -f1)
	fi

	TESTES_ENTRADA=$(ls . | grep "EXERCICIO_$1[0-9_]*.in" | wc -l)

	for nome in $NOMES_ALUNOS; do
		for teste in $(seq 1 $TESTES_ENTRADA); do
			testaExercicioAluno $1 $nome $teste
		done
	done
}

if [ $1 ]; then
	EXERCICIOS=$1
else
	EXERCICIOS=$(ls . | grep "EXERCICIO_[0-9A-Z_]*.sh" | cut -d'_' -f2 | uniq)
fi

for exercicio in $EXERCICIOS; do
	echo -e "\n================ Correção Exercício $exercicio =================="
	testaExercicios $exercicio $2
done
