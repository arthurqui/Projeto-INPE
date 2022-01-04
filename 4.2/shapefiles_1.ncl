;*************************************************
;  Read and Plot shapefiles
;*************************************************
load "/mnt/c/users/arthur/documents/ic/4.2/shapefile_utils.ncl" ; script usado para shapefiles

begin

dir = "/mnt/c/users/arthur/documents/ic/4.2/"
; esse arquivo contem os contornos dos estados
f = addfile(dir + "35ME2500G.shp", "r") 
sname = dir+"35ME2500G.shp"
print_shapefile_info(sname)  ; imprime informacoes da mascara

; antes de usar os comandos abaixo que estão comentados, verifique a lista de variaveis que aparecerá na tela. O intuito é descobrir o codigo para cada estado.

var = f->codigo(:)     ; seleciona a variavel SIGLA_UF do arquivo sname, a variavel pode mudar de acordo com o arquivo
print(var)            ; lista todos os atributos (estados) da mascara com o respectivo codigo do estado
   
;*************************************************   
; Plotar a mascara
;*************************************************   
wks = gsn_open_wks("png","shapefiles")
res = True
res@gsnDraw = False
res@gsnFrame = False
res@gsnMaximize = True
res@mpMinLatF = -26  ; Zoom in on Brazil
res@mpMaxLatF = -19
res@mpMinLonF = -54
res@mpMaxLonF = -43
res@mpOutlineOn = True 
res@mpLandFillColor = "white"

plres = True           ; resource list for polylines
plres@gsLineColor = "blue" ; cor da linha

plot = gsn_csm_map(wks,res)
id = gsn_add_shapefile_polylines(wks,plot,sname,plres) ; adiciona as linhas do shapefile ao mapa
draw(plot)
frame(wks)







end
