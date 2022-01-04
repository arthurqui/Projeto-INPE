;********************************************************
;  Usar shapefiles para plotar dados em apenas um estado
;********************************************************
load "/mnt/c/Analises/scripts/shapefiles/shapefile_utils.ncl" ; script usado para shapefiles

begin

;abrindo o arquivo shapefile e verificando o codigo do estado
dir = "/mnt/c/data/shapefiles/mesoregioes/"
f = addfile(dir + "35ME2500G.shp", "r") 
sname = dir+"35ME2500G.shp"
print_shapefile_info(sname)
var = f->codigo(:)
print(var)

; abrindo arquivo de precipitação
dirp = "/mnt/c/data/reanalysis/inmet/"
g = addfile(dirp+"Normais_INMET_1981_2010_prec.nc","r")
prec = g->prec
printVarSummary(prec)

;---Comandos para salvar apenas os dados sobre o estado, funciona para apenas um tempo
dims = dimsizes(prec) 
opt             = True
opt@return_mask = True
opt@debug       = True
opt@shape_var   = "codigo"  ; variavel do shapefile
opt@shape_names = (/"3508"/)     ; codigo do estado
prec_mask       = shapefile_mask_data(prec(0,:,:),sname,opt)
copy_VarMeta(prec(0,:,:),prec_mask)
   
;Para aplicar o shapefile em todos os tempos, deve-se usar os comandos:
; m3 := conform_dims(dimsizes(prec),prec_mask,(/1,2/))  ; 3Dmask
; n1 := mask(prec,m3,1) 
   
;*************************************************   
; Plotar o grafico
;*************************************************   
wks = gsn_open_wks("png","shapefiles2")
res = True
res@gsnDraw = False
res@gsnFrame = False
res@gsnAddCyclic = False
res@gsnMaximize = True
res@cnFillPalette = "precip_11lev"
res@mpMinLatF = -34  ; Zoom in on Brazil
res@mpMaxLatF = -20
res@mpMinLonF = -55
res@mpMaxLonF = -43
res@mpOutlineOn = True 
res@mpLandFillColor = "white"
res@mpDataSetName         = "Earth..4"
res@mpDataBaseVersion     = "MediumRes"
res@mpOutlineBoundarySets = "National"
res@mpOutlineSpecifiers   = (/"Brazil:states"/)
res@cnFillOn = True         
res@cnLinesOn = False

plot = gsn_csm_contour_map(wks,prec_mask,res)

draw(plot)
frame(wks)







end
