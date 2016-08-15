#!/bin/bash
# by André L. Abrantes - Agosto de 2016

# Varre a lista de sites passados como parâmetro em um arquivo
for site in $(cat $1); do 
	codigo=$(curl -I $site 2> /dev/null | head -n 1 | cut -d' ' -f2)
	contains=1
	if [ $2 ]; then # Se existe um segundo parâmetro
		temp="/tmp/siteCheck.out"
		curl $site 2> /dev/null > $temp # Armazena o GET request do site
		for palavra in $(cat $2); do # Varre as palavras passadas como parâmetro em um arquivo
			num=$(cat $temp | grep -c -i $palavra) # Faz um grep -c pela palavra buscada
			contains=$(($contains*$num)) # Em caso de 0 palavras encontradas zera o contains
		done
	fi
	if [ $contains -gt 0 ]; then # Se todas as palavras foram encontradas no arquivo
		echo "$site $codigo OK!" # Imprime OK!
	else
		echo -e "$site $codigo" # Imprime default
	fi
done

