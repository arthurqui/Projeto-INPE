;------------------------------
; NCL tutorial
; seasonal mean + panel plots
;------------------------------

begin

;--- open NC file
f = addfile("/mnt/c/Users/Arthur/Documents/IC/3.5/gpcp_1979-2019.nc","r")  ; "r" = read

;-- read variable
var = f->precip(24:383,:,:)  ; precip[time,lat,lon] select Jan1981 to Dec2010

;-----------------------anotação--------------------------------

; T para meses: Jan = 240 ... 241 242 243 244 245 246 247 248 249 250 ... dec= 251

;-------------------------------------------------------

;----Anomalia mensal

clm = clmMonTLL (var(:,:,:)) ; 

;---Compute the anomalies from the climatology just computed
anom = calcMonAnomTLL (var,clm)





;---- Plots
wks = gsn_open_wks("png","tutorial5-ncl") ;figure name

res = True      ; configuration for plots 

res@gsnDraw = False      ; dont draw plots yet
res@gsnFrame = False     ; dont create figures yet

res@lbLabelBarOn = False ; dont draw individual label bars

res@cnFillOn = True        ; shaded plot
res@cnLinesOn = False      ; no lines
res@cnLineLabelsOn = False ; no label on lines
res@cnFillPalette = "precip4_diff_19lev"
res@cnLevelSelectionMode = "ManualLevels"  ; sel. levels
res@cnMinLevelValF = -6      ; min value
res@cnMaxLevelValF = 6    ; max value
res@cnLevelSpacingF = 1

res@tmXTOn = False ; remove top tickmarks
res@tmYROn = False ; remove right tickmarks

res@mpMinLatF = -60          ; for South
res@mpMaxLatF = 15           ; America
res@mpMinLonF = -90
res@mpMaxLonF = -30

;create the plots
plot = new(12,graphic)    ; create a 12D array

res@gsnCenterString = "Anomalia Jan"; center title
res@gsnLeftString = ""  ; left title
res@gsnRightString = "" ; right title

plot(0)= gsn_csm_contour_map(wks,anom(240,:,:),res) ; plot 1 Jan

res@gsnCenterString = "Anomalia Feb"
plot(1) = gsn_csm_contour_map(wks,anom(241,:,:),res) ;plot 2 Feb

res@gsnCenterString = "Anomalia Mar"
plot(2) = gsn_csm_contour_map(wks,anom(242,:,:),res) ;plot 3 Mar

res@gsnCenterString = "Anomalia Apr"
plot(3) = gsn_csm_contour_map(wks,anom(243,:,:),res) ;plot 4 Apr

res@gsnCenterString = "Anomalia May"
plot(4) = gsn_csm_contour_map(wks,anom(244,:,:),res) ;plot 5 Apr

res@gsnCenterString = "Anomalia Jun"
plot(5) = gsn_csm_contour_map(wks,anom(245,:,:),res) ;plot 6 Jun

res@gsnCenterString = "Anomalia Jul"
plot(6) = gsn_csm_contour_map(wks,anom(246,:,:),res) ;plot 7 Jul

res@gsnCenterString = "Anomalia Ago"
plot(7) = gsn_csm_contour_map(wks,anom(247,:,:),res) ;plot 8 Ago

res@gsnCenterString = "Anomalia Sep"
plot(8)= gsn_csm_contour_map(wks,anom(248,:,:),res) ; plot 9 Sep

res@gsnCenterString = "Anomalia Oct"
plot(9) = gsn_csm_contour_map(wks,anom(249,:,:),res) ;plot 10 Oct

res@gsnCenterString = "Anomalia Nov"
plot(10) = gsn_csm_contour_map(wks,anom(250,:,:),res) ;plot 11 Nov

res@gsnCenterString = "Anomalia Dec"
plot(11) = gsn_csm_contour_map(wks,anom(251,:,:),res) ;plot 12 Dec

;--- Panel plots
panelres =  True          ; Panel resources
panelres@gsnFrame = False
panelres@gsnPanelLabelBar = True ; add a common label bar

panelres@gsnPanelTop =  0.95

;-- create the panel
gsn_panel(wks,plot,(/4,4/),panelres)  ; now draw plots

frame(wks)

end








