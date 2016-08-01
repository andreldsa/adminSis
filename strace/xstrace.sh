#!/bin/bash
# by André L. Abrantes - Agosto de 2016

COMANDO=$@ # Todos os parâmetros de entrada
OUT="/tmp/xstrace.out" # Arquivo temporário com a saída do strace

# Executa o strace no comando passado como parâmetro e joga no arquivo
# temporário sem mostrar na saída padrão
echo $(strace -q -o $OUT -T $COMANDO) > /dev/null

# Apaga a ultima linha que marca o término (limpando os dados)
sed -i "/+++ exited with/d" $OUT

# Mostra as syscalls com os 3 maiores tempos de execução
echo -e "Chamadas:\n"

for tempo in $(cat $OUT | grep '<[0-9.]*>' | cut -d'<' -f2 | sort -n | tail -n 3); do
	cat $OUT | grep "<$tempo"
done

# Mostra a syscall mais chamada

MAIOR_CHAMADA=""
COUNT=0

for chamada in $(cat $OUT | cut -d'(' -f1 | sort | uniq); do
	NUM_CHAMADAS=$(cat $OUT | grep -c $chamada)
	if [ $NUM_CHAMADAS -gt $COUNT ]; then
		MAIOR_CHAMADA=$chamada
		COUNT=$NUM_CHAMADAS
	fi
done

echo -e "\nSyscall: $MAIOR_CHAMADA com $COUNT chamadas"

