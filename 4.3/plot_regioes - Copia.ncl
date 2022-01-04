;-------------------------------------------------------
; Plot NE e N basins 
; and annual precipitation
;-------------------------------------------------------
begin

;-------------------------------------------------------
; User specifications
;-------------------------------------------------------
palT1  = "GMT_drywet"  ; paleta de cores
   
dirc = "/mnt/c/users/arthur/documents/ic/4.3/" ; Mudar 
;dir  = "/mnt/c/users/arthur/documents/ic/4.3/"; diretorios
sname = dirc+"SP_Mesorregioes_2019.shp"        ; e nome do shapefile  
f = addfile(sname,"r")

wks_type = "png"
wks_type@wkWidth  = 5500  ; usado para figura em alta
wks_type@wkHeight = 5500  ; resolucao
wksName = "fig-regioes"

;-----------------------------------------------------
; Read in netCDF files
;-----------------------------------------------------
fc = addfile(dirc+"novochirps2.nc","r")
vp = fc->precip(:,:,:)

;-- annual mean
vm = dim_avg_n_Wrap(vp,0)

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
res@mpMinLatF = -26  ; Zoom in on Brazil
res@mpMaxLatF = -19
res@mpMinLonF = -54
res@mpMaxLonF = -43
res@cnFillMode = "RasterFill"
res@cnFillDrawOrder = "Predraw"
res@cnSpanFillPalette = True
;res@cnLevelSelectionMode = "ManualLevels"
res@cnMaxLevelValF = 10     ; mudar valores maximos
res@cnMinLevelValF = 0      ; e intervalo
;res@cnLevelSpacingF = 0.5
res@tmYROn = False
res@tmXTOn = False

; Zoom in SP
res@mpDataSetName = "Earth..4"
res@mpDataBaseVersion = "MediumRes"
res@mpFillBoundarySets = "NoBoundaries"
res@mpFillAreaSpecifiers = (/"Land","brazil","Water"/)
res@mpSpecifiedFillColors = (/"white","transparent",       "white"/)
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
txres@txFontColor = "white"  ; muda a cor da fonte
txres@txFont = 22
txres@txFontHeightF = 0.02  ; muda o tamanho da fonte 
;--- Identificar cada regiao com um numero
;-- mudar os valores x e y para ficar dentro
;--- de cada regiao 
;--- gsn_text_ndc(wks,text,x,y,res)
gsn_text_ndc(wks,"5",  0.52, 0.54, txres);Ararar!
gsn_text_ndc(wks,"2",  0.56, 0.605, txres);Rib P!
gsn_text_ndc(wks,"3",  0.36,  0.61, txres);Araça !
gsn_text_ndc(wks,"4",  0.465,  0.48, txres);Bauru!
gsn_text_ndc(wks,"1",  0.43,  0.62, txres);SJRP!
gsn_text_ndc(wks,"6",  0.53, 0.50, txres);Pirac!
gsn_text_ndc(wks,"7",  0.60,  0.50, txres);Camp!
gsn_text_ndc(wks,"8",  0.33,  0.54, txres);Prudente!
gsn_text_ndc(wks,"9",  0.37,  0.54, txres);Marilia!
gsn_text_ndc(wks,"10", 0.42,  0.48, txres);Assis   
gsn_text_ndc(wks,"11", 0.465,  0.40, txres);Itapet!
gsn_text_ndc(wks,"12", 0.555,  0.44, txres);Macro Metropolitana
gsn_text_ndc(wks,"13", 0.70,  0.46, txres);Vale do para!
gsn_text_ndc(wks,"14", 0.58,  0.38, txres);Litoral sul 
gsn_text_ndc(wks,"15", 0.62,  0.42, txres);Metropolitana   
txres@txFontHeightF = 0.012

frame(wks)

end




