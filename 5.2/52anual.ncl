;-------------------------------------------------------
; Mapa Mesorregioes de SP - INMET
;-------------------------------------------------------
load "/mnt/c/users/arthur/documents/ic/4.5/text.ncl"

begin

;-------------------------------------------------------
; User specifications
;-------------------------------------------------------
palT1  = "GMT_drywet"  ; paleta de cores
   
dir = "/mnt/c/users/arthur/documents/ic/5.2/" ; Mudar 

;-------------------------------------------------------

wks_type = "png"
wks_type@wkWidth  = 5500  ; usado para figura em alta
wks_type@wkHeight = 5500  ; resolucao
wksName = "Media Anual TSM"

;-----------------------------------------------------
; Read in netCDF files
;-----------------------------------------------------
fc = addfile(dir+"tsm.nc","r")
prec = short2flt(fc->sst)
printVarSummary(prec)

vm = dim_avg_n_Wrap(prec,0)

wks = gsn_open_wks(wks_type,wksName) 

res = True
res@gsnDraw = False
res@gsnFrame = False
res@gsnAddCyclic = True
res@gsnRightString = ""
res@gsnLeftString = ""
res@cnLineLabelsOn = False
res@cnFillOn = True         
res@cnLinesOn = False
res@cnFillPalette = palT1
 res@mpMinLatF = -60  ; Zoom in on SP
 res@mpMaxLatF = 60
 res@mpMinLonF    = 0.      
 res@mpMaxLonF    = 360.    
 res@mpCenterLonF = 180.
; res@mpMinLonF = -54
; res@mpMaxLonF = -43
res@cnFillMode = "RasterFill"
res@cnFillDrawOrder = "Predraw"
res@cnSpanFillPalette = True
;res@cnLevelSelectionMode = "ManualLevels"
; res@cnMaxLevelValF = 10     ; mudar valores maximos
; res@cnMinLevelValF = 0      ; e intervalo
;res@cnLevelSpacingF = 0.5
res@tmYROn = False
res@tmXTOn = False
res@tmXTOn      = False
res@tmYROn      = False
res@tmXBOn      = True
res@tmYLOn      = True
res@tmBorderLineColor = 0


res@mpDataSetName = "Earth..4"
res@mpDataBaseVersion = "MediumRes"
; res@mpFillBoundarySets = "NoBoundaries"
; res@mpFillAreaSpecifiers = (/"Land","brazil","Water"/)
; res@mpSpecifiedFillColors = (/"white","transparent","white"/)
; res@mpOutlineOn = False

plot = gsn_csm_contour_map(wks,vm,res)

draw(plot)
frame(wks)
end





