#!/bin/bash
# by André L. Abrantes - Agosto de 2016.

SITE=$1
OUT='/tmp/headerTime.out'

if [ $# -lt 1 ]; then
	echo "Uso: ./time.sh www.site.com"
	exit 1;
fi

curl -s -w 'RTT: %{time_total}' -I $SITE > $OUT

RTT=$(cat $OUT | grep RTT | cut -d' ' -f2)
SERVER_TIME=$(cat $OUT | grep Date | cut -d' ' -f6)
NOW=$(date +"%H:%M:%S")

echo -e "RTT: $(($RTT * 1)) ms"
echo -e "Servidor: $SERVER_TIME"
echo -e "Local: $NOW"

DIFF=$(( $(date +%s -d $NOW) - $(date +%s -d $SERVER_TIME) ))

echo -e "Diferença: $DIFF ms"
