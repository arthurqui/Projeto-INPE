;********************************************************
;  Usar shapefiles para plotar dados em apenas um estado
;********************************************************
load "/mnt/c/users/arthur/documents/ic/4.2/shapefile_utils.ncl" ; script usado para shapefiles

begin

;abrindo o arquivo shapefile e verificando o codigo do estado
dir = "/mnt/c/users/arthur/documents/ic/4.2/"
f = addfile(dir + "SP_Mesorregioes_2019.shp", "r") 
sname = dir+"SP_Mesorregioes_2019.shp"
print_shapefile_info(sname)
var = f->CD_MESO(:)
print(var)

; abrindo arquivo de precipitação
dirp = "/mnt/c/users/arthur/documents/ic/4.2/"
g = addfile(dirp+"novochirps2.nc","r")
precip = g->precip

;---Comandos para salvar apenas os dados sobre o estado, funciona para apenas um tempo
dims = dimsizes(precip) 
opt             = True
opt@return_mask = True
opt@debug       = True
opt@shape_var   = "CD_MESO"  ; variavel do shapefile
opt@shape_names = (/"3513"/)     ; codigo do estado
prec_mask       = shapefile_mask_data(precip(0,:,:),sname,opt)
copy_VarMeta(precip(0,:,:),prec_mask)
   
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
res@mpMinLatF = -26  ; Zoom in on SP
res@mpMaxLatF = -19
res@mpMinLonF = -54
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
