;------------------------------
; NCL tutorial
; seasonal mean + panel plots
;------------------------------

begin

;--- open NC file
f = addfile("/mnt/c/Users/Arthur/Documents/IC/3.4/gpcp_1979-2019.nc","r")  ; "r" = read

;-- read variable
var = f->precip(24:383,:,:)  ; precip[time,lat,lon] select Jan1981 to Dec2010

;--- Seasonal mean
sclim1 = month_to_season(var,"DJF") ; mean for DJF, creates one value per year
printVarSummary(sclim1)
sclim2 = month_to_season(var,"MAM") ; mean for MAM
sclim3 = month_to_season(var,"JJA") ; mean for JJA
sclim4 = month_to_season(var,"SON") ; mean for SON

;--- Seasonal climatology
yclim1 = dim_avg_n_Wrap(sclim1,0) ; evaluate time mean (dimension 0)
yclim2 = dim_avg_n_Wrap(sclim2,0)
yclim3 = dim_avg_n_Wrap(sclim3,0)
yclim4 = dim_avg_n_Wrap(sclim4,0)

;--- an alternative is to concatenate these two commands: yclim5 = dim_avg_n_Wrap(month_to_season(var,"DJF"),0)

;---- Plots
wks = gsn_open_wks("png","tutorial5-ncl") ;figure name

res = True      ; configuration for plots 

res@gsnDraw = False      ; dont draw plots yet
res@gsnFrame = False     ; dont create figures yet

res@lbLabelBarOn = False ; dont draw individual label bars

res@cnFillOn = True        ; shaded plot
res@cnLinesOn = False      ; no lines
res@cnLineLabelsOn = False ; no label on lines
res@cnFillPalette = "precip_11lev"
res@cnLevelSelectionMode = "ManualLevels"  ; sel. levels
res@cnMinLevelValF = 0      ; min value
res@cnMaxLevelValF = 12     ; max value
res@cnLevelSpacingF = 1

res@tmXTOn = False ; remove top tickmarks
res@tmYROn = False ; remove right tickmarks

res@mpMinLatF = -60          ; for South
res@mpMaxLatF = 15           ; America
res@mpMinLonF = -90
res@mpMaxLonF = -30

;create the plots
plot = new(4,graphic)    ; create a 4D array

res@gsnCenterString = "DJF precipitation (1981-2010)"; center title
res@gsnLeftString = ""  ; left title
res@gsnRightString = "" ; right title

plot(0)= gsn_csm_contour_map(wks,yclim1,res) ; plot 1

res@gsnCenterString = "MAM precipitation (1981-2010)"
plot(1) = gsn_csm_contour_map(wks,yclim2,res) ;plot 2

res@gsnCenterString = "JJA precipitation (1981-2010)"
plot(2) = gsn_csm_contour_map(wks,yclim3,res) ;plot 3

res@gsnCenterString = "SON precipitation (1981-2010)"
plot(3) = gsn_csm_contour_map(wks,yclim4,res) ;plot 4

;--- Panel plots
panelres =  True          ; Panel resources
panelres@gsnFrame = False
panelres@gsnPanelLabelBar = True ; add a common label bar

panelres@gsnPanelTop =  0.95

;-- create the panel
gsn_panel(wks,plot,(/2,2/),panelres)  ; now draw plots

frame(wks)

end




