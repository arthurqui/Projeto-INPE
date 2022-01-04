;-------------------------------------------------------
; Mapa Mesorregioes de SP - INMET
;-------------------------------------------------------
load "/mnt/c/users/arthur/documents/ic/4.5/shapefile_utils.ncl" ; script usado para shapefiles
load "/mnt/c/users/arthur/documents/ic/4.5/text.ncl"

begin

;-------------------------------------------------------
; User specifications
;-------------------------------------------------------
palT1  = "GMT_drywet"  ; paleta de cores
   
dir = "/mnt/c/users/arthur/documents/ic/4.5/" ; Mudar 
sname = dir+"SP_Mesorregioes_2019.shp"        ; e nome do shapefile  
f = addfile(sname,"r")
print_shapefile_info(sname);printar informações sobre o shapefile

;-------------------------------------------------------

wks_type = "png"
wks_type@wkWidth  = 5500  ; usado para figura em alta
wks_type@wkHeight = 5500  ; resolucao
wksName = "fig-regioes inmet"

;-----------------------------------------------------
; Read in netCDF files
;-----------------------------------------------------
fc = addfile(dir+"Normais_INMET_1981_2010_prec.nc","r")
prec = fc->prec
printVarSummary(prec)


;---Comandos para salvar apenas os dados sobre o estado
dims = dimsizes(prec) 
opt             = True
opt@return_mask = True
opt@debug       = True
opt@shape_var   = "SIGLA_UF"  ; variavel do shapefile
opt@shape_names = (/"SP"/)     ; codigo do estado
prec_mask       = shapefile_mask_data(prec(0,:,:),sname,opt)
copy_VarMeta(prec(0,:,:),prec_mask)
m3 = conform_dims(dimsizes(prec),prec_mask,(/1,2/))  ; 3Dmask
n1 = mask(prec,m3,1)

;----------------Mudar rotulo da variável----
n1!0 = "time"
n1!1 = "lat"
n1!2 = "lon"
n1&lat = prec&lat
n1&lon = prec&lon
;---------------------------------------------
;printVarSummary(n1) ; printar variável

;-- annual mean
vm = dim_avg_n_Wrap(n1,0)
printVarSummary(vm)
printVarSummary(n1)
;-------------------------------------------------------
; create plots
;-------------------------------------------------------
wks = gsn_open_wks(wks_type,wksName) 
setvalues NhlGetWorkspaceObjectId() ; usado para chirps
   "wsMaximumSize" : 800000000
end setvalues

res = True
res@gsnDraw = False
res@gsnFrame = False
res@gsnAddCyclic = False
res@gsnRightString = ""
res@gsnLeftString = ""
res@cnLineLabelsOn = False
res@cnFillOn = True         
res@cnLinesOn = False
res@cnFillPalette = palT1
res@mpMinLatF = -26  ; Zoom in on SP
res@mpMaxLatF = -19
res@mpMinLonF = -54
res@mpMaxLonF = -43
;res@cnFillMode = "RasterFill"
res@cnFillDrawOrder = "Predraw"
res@cnSpanFillPalette = True
;res@cnLevelSelectionMode = "ManualLevels"
res@cnMaxLevelValF = 10     ; mudar valores maximos
res@cnMinLevelValF = 0      ; e intervalo
;res@cnLevelSpacingF = 0.5
res@tmYROn = False
res@tmXTOn = False
res@tmXTOn      = False
res@tmYROn      = False
res@tmXBOn      = False
res@tmYLOn      = False
res@tmBorderLineColor = 0

; Zoom in SP
res@mpDataSetName = "Earth..4"
res@mpDataBaseVersion = "MediumRes"
res@mpFillBoundarySets = "NoBoundaries"
res@mpFillAreaSpecifiers = (/"Land","brazil","Water"/)
res@mpSpecifiedFillColors = (/"white","transparent","white"/)
res@mpOutlineOn = False

plot = gsn_csm_contour_map(wks,vm,res)

;---Section to add polylines to map.
pres = True                  ; desenha os contornos
pres@gsLineColor = "black"
pres@gsLineThicknessF = 6.0
poly = gsn_add_shapefile_polylines(wks,plot,sname,pres)


draw(plot)

;------------------ Plot Area names
txres = True
txres@txFontColor = "black"  ; muda a cor da fonte
txres@txFont = 22
txres@txFontHeightF = 0.02  ; muda o tamanho da fonte 

;--- Identificar cada regiao com um numero
;-- mudar os valores x e y para ficar dentro
;--- de cada regiao 
;--- gsn_text_ndc(wks,text,x,y,res)
gsn_text_ndc(wks,"5",  0.52, 0.54, txres);Ararar!!
gsn_text_ndc(wks,"2",  0.54, 0.605, txres);Rib P!!
gsn_text_ndc(wks,"3",  0.36,  0.59, txres);Araça !!
gsn_text_ndc(wks,"4",  0.475,  0.50, txres);Bauru!!
gsn_text_ndc(wks,"1",  0.43,  0.62, txres);SJRP!!
gsn_text_ndc(wks,"6",  0.55, 0.50, txres);Pirac!!
gsn_text_ndc(wks,"7",  0.60,  0.49, txres);Camp!!
gsn_text_ndc(wks,"8",  0.31,  0.54, txres);Prudente!!
gsn_text_ndc(wks,"9",  0.405,  0.52, txres);Marilia!!
gsn_text_ndc(wks,"10", 0.423,  0.476, txres);Assis   
gsn_text_ndc(wks,"11", 0.49,  0.41, txres);Itapet!!
gsn_text_ndc(wks,"12", 0.565,  0.43, txres);Macro Metropolitana!!
gsn_text_ndc(wks,"13", 0.70,  0.46, txres);Vale do para!!
gsn_text_ndc(wks,"14", 0.54,  0.37, txres);Litoral sul 
gsn_text_ndc(wks,"15", 0.63,  0.43, txres);Metropolitana!! 
txres@txFontHeightF = 0.009
gsn_text_ndc(wks,"1: S"+atilde+"o Jos"+eacute+" do Rio Preto",  0.30, 0.45, txres)
gsn_text_ndc(wks,"2: Ribeir"+atilde+"o Preto",  0.30, 0.435, txres)
gsn_text_ndc(wks,"3: Ara"+cedil+"atuba",  0.30, 0.42, txres)
gsn_text_ndc(wks,"4: Bauru",  0.30, 0.405, txres)
gsn_text_ndc(wks,"5: Araraquara",  0.30, 0.39, txres)
gsn_text_ndc(wks,"6: Piracicaba",  0.30, 0.375, txres)
gsn_text_ndc(wks,"7: Campinas",  0.30, 0.36, txres)
gsn_text_ndc(wks,"8: Presidente Prudente",  0.30, 0.345, txres)
gsn_text_ndc(wks,"9: Mar"+iacute+"lia",  0.30, 0.33, txres)
gsn_text_ndc(wks,"10: Assis",  0.30, 0.315, txres)
gsn_text_ndc(wks,"11: Itapetininga",  0.30, 0.30, txres)
gsn_text_ndc(wks,"12: Macro Metropolitana Paulista",  0.30, 0.285, txres)
gsn_text_ndc(wks,"13: Vale do Para"+iacute+"ba",  0.30, 0.27, txres)
gsn_text_ndc(wks,"14: Litoral Sul",  0.30, 0.255, txres)
gsn_text_ndc(wks,"15: Metropolitana de SP",  0.30, 0.24, txres)

;diminuir a letra: txres@txFontHeightF = 0.007
frame(wks)

end




