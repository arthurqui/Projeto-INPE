#!/bin/bash
echo "Digite o nome do plot (wks name): "
read wks;
echo "Qual o ano inicial? "
read inicial;
​echo "Qual o ano final? "
​while read final;
do
   if [ "$final" -lt "$inicial" ];
   then
      echo "O ano final precisa ser maior que o ano inicial"
	  echo "Digite o ano final: "
    else
	  echo "Periodo do plot: $inicial - $final" 
	  exit 0
	fi
done
export wks
export inicial
export final
ncl temporal-series-bar-line.ncl
