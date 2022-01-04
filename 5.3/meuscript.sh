#!/bin/bash
#Este é meu script
ls
echo "Digite o ano inicial e o final no intervalo de 1981 a 2020 , sendo que o final tem que ser maior que o inicial"
echo "Digite o ano inicial:"
read ano_inicial;
echo "Digite o ano final:"
read ano_final;

while [ $ano_inicial -gt $ano_final ];
 do
  echo "Ano inicial não pode ser maior que o ano final!"
  echo "Digite o ano inicial:"
  read ano_inicial;
  echo "Digite o ano final:"
  read ano_final;
done

echo "CDO ira gerar um arquivo .NC para o intervalo entre $ano_inicial e $ano_final"
cdo -selyear,$ano_inicial/$ano_final /mnt/c/users/arthur/documents/IC3/chirps.nc novochirps2.nc