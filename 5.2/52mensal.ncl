;-------------------------------------------------------
; Mapa Mesorregioes de SP - INMET
;-------------------------------------------------------
load "/mnt/c/users/arthur/documents/ic/4.5/text.ncl"

begin
labmes = (/"Jan","Fev","Mar","Abr","Mai","Jun","Jul","Ago","Set","Out","Nov","Dez"/)


;-------------------------------------------------------
; User specifications
;-------------------------------------------------------
palT1  = "cmocean_balance"  ; paleta de cores
   
dir = "/mnt/c/users/arthur/documents/ic/5.2/" ; Mudar 
;mes = ispan(23772,23783,1) ;meses 1982 arquivo menor
mes = ispan(1,12,1)

;-------------------------------------------------------

wks_type = "png"
wks_type@wkWidth  = 5500  ; usado para figura em alta
wks_type@wkHeight = 5500  ; resolucao
wksName = "Media Mensal TSM"

;-----------------------------------------------------
; Read in netCDF files
;-----------------------------------------------------
fc = addfile(dir+"tsm.nc","r")
fm = addfile(dir+"mltm.nc","r")

media = short2flt(fm->sst)
printVarSummary(media)
tsm = short2flt(fc->sst)
printVarSummary(tsm(1:12,:,:))

anom = calcMonAnomTLL (tsm(1:12,:,:),media)

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
res@lbLabelBarOn = False
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
res@cnLevelSelectionMode = "ManualLevels"
 res@cnMaxLevelValF = 4     ; mudar valores maximos
 res@cnMinLevelValF = -4      ; e intervalo
res@cnLevelSpacingF = 0.5
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

;create the plots
plot = new(12,graphic)    ; create a 12D array

do j=0,11
res@gsnCenterString = "Anomalia " +labmes(j); center title
plot(j)= gsn_csm_contour_map(wks,anom(j,:,:),res) ; plot 1 Jan
end do

;--- Panel plots
panelres =  True          ; Panel resources
panelres@gsnFrame = False
panelres@gsnPanelLabelBar = True ; add a common label bar

panelres@gsnPanelTop =  0.95

;-- create the panel
gsn_panel(wks,plot,(/6,2/),panelres)  ; now draw plots

frame(wks)
end




