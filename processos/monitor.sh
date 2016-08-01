#!/bin/bash
# by André L. Abrantes - July 2016

num_observacoes=$1
intervalo=$2
usuario=$3

if [ $# -lt 3 ]; then
	echo "Número de Observações?"
	read num_observacoes
	echo "Intervalo entre as Observações (segundos)?"
	read intervalo
	echo "Usuário a ser observado?"
	read usuario
fi

if [ $num_observacoes -le 0 ] || [ $intervalo -le 0 ]; then
	exit 1;
fi

CPU_FILE="/tmp/cpu_$usuario"
TOTAL_MEM_FILE="/tmp/mem_$usuario"
export PROC_FILE="/tmp/proc_$usuario"

#-------------------------------------------------------------------
# Limpa os arquivos temporários se existirem

if [ -e $CPU_FILE ]; then
	rm $CPU_FILE
fi

if [ -e $MEM_FILE ]; then
	rm $MEM_FILE
fi

if [ -e $PROC_FILE ]; then
	rm $PROC_FILE
fi

#-------------------------------------------------------------------

function mostraDados {
	echo -e "\n============| Dados Finais |===================="
	echo -e "\n------- CPU -------"
	echo "Maior: %$(cat $CPU_FILE | sort -n -r | head -n 1)"
	echo "Menor: %$(cat $CPU_FILE | sort -n -r | tail -n 1)"
	echo "Processo com maior consumo de CPU: $(cat $PROC_FILE | sort -n -r | head -n 1 | cut -d' ' -f2)"
	echo -e "\n------- Memória -------"
	echo "Maior: $(cat $TOTAL_MEM_FILE | sort -n -r | head -n 1)"
	echo "Menor: $(cat $TOTAL_MEM_FILE | sort -n -r | tail -n 1)"
	echo "================================================="
}

# Verifica se as duas entradas são iguais,
# se sim o programa termina com sucesso.
function verificaSaida {
        if [ $1 -eq $2 ]; then
                if [ $(cat $PROC_FILE | wc -l) -le 1 ]; then 
                        # Nenhum processo foi encontrado
                        echo -e "\n=========================================="
                        echo -e "\nNenhum processo foi encontrado :/ \n"
                        exit 2
                fi
		# Saída com sucesso
		mostraDados
                exit 0
        fi
}

for var in $(seq 1 $num_observacoes); do
	echo -e "\n[Observação $var]"
	ps -e -o pid,uname,pcpu,pmem,comm | grep $usuario
	cpuTotal=$(ps -e -o pcpu,uname | grep $usuario |  awk '{ sum += $1 }; END { print sum }')
	echo $cpuTotal >> $CPU_FILE
	memTotal=$(ps -e -o pmem,uname | grep $usuario |  awk '{ sum += $1 }; END { print sum }')
	echo $memTotal >> $TOTAL_MEM_FILE
	maiorProc=$(ps -e -o pcpu,cmd,uname | grep $usuario | sort -r -n | head -n 1)
	echo $maiorProc >> $PROC_FILE
	cpuProc=$(ps -e -o pcpu,cmd,uname | grep $usuario | sort -r -n | head -n 1 | cut -d' ' -f3)

	echo -e "\n--------- Dados da Observação --------------"
	echo -e "\nTotal CPU: %$cpuTotal | Total Memória: $memTotal"
	echo -e "Processo com maior CPU: $cpuProc"

	verificaSaida $var $num_observacoes

	echo -e "\n... Aguardando nova observação em $intervalo segundos"
	sleep $intervalo
done
