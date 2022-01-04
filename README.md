# Sistema de tratamento e análise de grandes volumes de dados através de técnicas de data science
Todos os scripts, gráficos e relatórios de todas as atividades que foram feitas no projeto

 - O git não permite push de arquivos grandes então todos os arquivos grandes estarão upados na pasta IC2 que pode ser baixada no seguinte link: https://drive.google.com/drive/folders/10akAeX1SNfEP9a5MpL9ygh2nL_L1VBkl?usp=sharing
 
 - Para que o script funcione,baixe todas as pastas do repositório e coloque-as dentro de uma pasta chamada "IC", depois disso baixe a pasta do link acima e coloque ambas as pastas "IC" e "IC2" no mesmo diretório e nos endereços que lerem os arquivos em questão com extensão .nc substitua "IC" por "IC2"
 
 Por exemplo: 
 
Original: 

dirp = "/mnt/c/users/arthur/documents/ic/4.1/"

g = addfile(dirp+"chirps.nc","r")

precip = g->precip

Modificado para funcionar:

dirp = "/mnt/c/users/arthur/documents/ic2/4.1/"

g = addfile(dirp+"chirps.nc","r")

precip = g->precip

 - Download da fonte de dados CHIRPS original (6gb), utilizado nos scripts que tem como objetivo gerar fontes de dados menores e mais especificas usando o CDO: https://drive.google.com/drive/folders/17MFWNRJuSO770fz0j1lbSawBwqDVGDEj?usp=sharing
