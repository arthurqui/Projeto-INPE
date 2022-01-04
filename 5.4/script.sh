#!/bin/bash
echo "Digite o nome do plot (wks name): "
read wks;
echo "Qual o ano inicial? "

read inicial;

echo "Qual o ano final? "

# read final;

while read final;
do
   if [ "$final" -lt "$inicial" ];
   then
    echo "Ano final nao pode ser menor do que ano inicial"
	echo "Digite o ano final: "
	else
	echo "Intervalo: $inicial - $final"
	export wks
	export inicial
	export final
	ncl temporal-series-bar-line.ncl
	exit 0
	  
	fi
done

# rodar dos2unix script.sh para evitar os errors ./r