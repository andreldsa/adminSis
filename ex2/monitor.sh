#!/bin/bash


num_observacoes=$1
intervalo=$2
usuario=$3

# Verifica se as duas entradas são iguais,
# se sim o programa termina com sucesso.
function verificaIgualdadeTermina {
        if [ $1 -eq $2 ]; then
                exit 0;
        fi
}

maiorCpu=0;
menorCpu=999999;

maiorMem=0;
menorMem=999999;

for var in $(seq 1 $num_observacoes); do
	echo "[Observação $var]"
	ps -e -o pid,uname,pcpu,pmem,comm | grep $usuario
	cpuTotal=$(ps -e -o pcpu,uname | grep $usuario |  awk '{ sum += $1 }; END { print sum }')
	memTotal=$(ps -e -o pmem,uname | grep $usuario |  awk '{ sum += $1 }; END { print sum }')

	if [ $(echo "$cpuTotal > $maiorCpu" | bc) -eq 1 ]; then
		$maiorCpu=$cpuTotal
	fi

	echo "CPU: %$cpuTotal | Memória: $memTotal"

	verificaIgualdadeTermina $var $num_observacoes

	echo "... Aguardando nova observação em $intervalo segundos"
	sleep $intervalo
done
