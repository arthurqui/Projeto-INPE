
begin

;Endereço arquivo.nc
f = addfile("/mnt/c/Users/Arthur/Documents/IC/3.6/gpcp_1979-2019.nc","r")  ; "r" = read

;Leitura de variavel

var = f->precip(24:383,:,:)  ; precip[time,lat,lon] para Jan1981 a Dec2010
var2 = f->precip(372:491,:,:)

;1 - climatologia mensal
clm = clmMonTLL (var(:,:,:)) ; climatologia mensal


;2 - climatologia sasonal DJF

yclim = month_to_season(var2,"DJF") ; clim 2010 a 2019
climdjf = month_to_season(clm,"DJF") ; clim DJF
printVarSummary(climdjf)


porcent0 = yclim(0,:,:) * 100 / climdjf(0,:,:)
porcent1 = yclim(1,:,:) * 100 / climdjf(0,:,:)
porcent2 = yclim(2,:,:) * 100 / climdjf(0,:,:)
porcent3 = yclim(3,:,:) * 100 / climdjf(0,:,:)
porcent4 = yclim(4,:,:) * 100 / climdjf(0,:,:)
porcent5 = yclim(5,:,:) * 100 / climdjf(0,:,:)
porcent6 = yclim(6,:,:) * 100 / climdjf(0,:,:)
porcent7 = yclim(7,:,:) * 100 / climdjf(0,:,:)
porcent8 = yclim(8,:,:) * 100 / climdjf(0,:,:)
porcent9 = yclim(9,:,:) * 100 / climdjf(0,:,:)

copy_VarCoords(climdjf(0,:,:),porcent0)
copy_VarCoords(climdjf(0,:,:),porcent1)
copy_VarCoords(climdjf(0,:,:),porcent2)
copy_VarCoords(climdjf(0,:,:),porcent3)
copy_VarCoords(climdjf(0,:,:),porcent4)
copy_VarCoords(climdjf(0,:,:),porcent5)
copy_VarCoords(climdjf(0,:,:),porcent6)
copy_VarCoords(climdjf(0,:,:),porcent7)
copy_VarCoords(climdjf(0,:,:),porcent8)
copy_VarCoords(climdjf(0,:,:),porcent9)


; T para 2010: 373
; T para 2019: 492
printVarSummary(yclim)


zclim = dim_avg_n_Wrap(yclim,0)


; -- Plot da parte 2
wks = gsn_open_wks("png","Parte2") ;figure name

res = True      ; configuration for plots 

res@gsnDraw = False      ; dont draw plots yet
res@gsnFrame = False     ; dont create figures yet
res@lbLabelBarOn = False ; dont draw individual label bars

res@cnFillOn = True        ; shaded plot
res@cnLinesOn = False      ; no lines
res@cnLineLabelsOn = False ; no label on lines
res@cnFillPalette = "precip_11lev"
res@cnLevelSelectionMode = "ManualLevels"  ; sel. levels
res@cnMinLevelValF = 6      ; min value
res@cnMaxLevelValF = 8     ; max value
res@cnLevelSpacingF = 0.3

res@tmXTOn = False ; remove top tickmarks
res@tmYROn = False ; remove right tickmarks

;ZOOM SOBRE SP

res@mpMinLatF = -26          ; for South
res@mpMaxLatF = -19           ; America
res@mpMinLonF = -54
res@mpMaxLonF = -43
res@mpDataSetName = "Earth..4"
res@mpDataBaseVersion = "MediumRes"
res@mpOutlineBoundarySets = "National"
res@mpOutlineSpecifiers = (/"Brazil:states"/)



;create the plots
res@gsnCenterString = "DJF precipitation (1981-2010)"; center title
res@gsnLeftString = ""  ; left title
res@gsnRightString = "" ; right title
plot = gsn_csm_contour_map(wks,zclim,res) 


;plot(0)= 

;--- Panel plots
;panelres =  True          ; Panel resources
;panelres@gsnFrame = False
;panelres@gsnPanelLabelBar = True ; add a common label bar
;panelres@gsnPanelTop =  0.95

;-- create the panel
;gsn_panel(wks,plot,(/1,1/),panelres)  ; now draw plots

draw(wks)
frame(wks)

;plot parte 4
wks2 = gsn_open_wks("png","Parte4") ;figure name
res@cnMinLevelValF = 0      ; min value
res@cnMaxLevelValF = 200     ; max value
res@cnLevelSpacingF = 20

plot2 = new(10,graphic)    ; create a 10D array

res@gsnCenterString = ""; center title
res@gsnLeftString = ""  ; left title
res@gsnRightString = "" ; right title


plot2(0)= gsn_csm_contour_map(wks2,porcent0,res) ; plot 1
plot2(1)= gsn_csm_contour_map(wks2,porcent1,res) ; plot 1
plot2(2)= gsn_csm_contour_map(wks2,porcent2,res) ; plot 1
plot2(3)= gsn_csm_contour_map(wks2,porcent3,res) ; plot 1
plot2(4)= gsn_csm_contour_map(wks2,porcent4,res) ; plot 1
plot2(5)= gsn_csm_contour_map(wks2,porcent5,res) ; plot 1
plot2(6)= gsn_csm_contour_map(wks2,porcent6,res) ; plot 1
plot2(7)= gsn_csm_contour_map(wks2,porcent7,res) ; plot 1
plot2(8)= gsn_csm_contour_map(wks2,porcent8,res) ; plot 1
plot2(9)= gsn_csm_contour_map(wks2,porcent9,res) ; plot 1



;--- Panel plots
panelres =  True          ; Panel resources
panelres@gsnFrame = False
panelres@gsnPanelLabelBar = True ; add a common label bar
panelres@gsnPanelFigureStrings = (/"2010", "2011","2012","2013","2014", "2015","2016","2017","2018","2019"/)
panelres@gsnPanelFigureStringsFontHeightF = 0.007
panelres@txString = "% DJF (2010-2019)"
panelres@gsnPanelTop =  0.95

;-- create the panel
gsn_panel(wks2,plot2,(/3,4/),panelres)  ; now draw plots

frame(wks2)


end








