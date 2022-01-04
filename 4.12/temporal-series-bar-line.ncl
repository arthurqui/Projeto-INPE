;-------------------------------------------------------
;-- Plotar serie temporal de precipitacao
;-- valor mensal (barras), climatologia (linhas)
;-------------------------------------------------------
begin

;-------------------------------------------------
; User specifications
;-------------------------------------------------
lata = -40  ; define lat-lon
latb = 5   ; para calculo
lona = 290    ; das medias
lonb = 320  ; espaciais

anoi = 1982
anof = 1984
ti = (anoi - 1979)*12         ; Jan anoi
tf = ((anof - 1979)*12) + 11  ; Dec anof
nt = ((anof - anoi) + 1) * 12 ; numero de tempos
nyears = (anof - anoi) + 1    ; numero de anos

wksName = "temporal-series-bar-line" ; nome da figura
wks_type          = "png"
wks_type@wkWidth  = 2500  ; para figura com
wks_type@wkHeight = 2500  ; maior qualidade
dirm = "/mnt/c/data/reanalysis/prec/mon/" ; diretorio

;----------------------------------------------
; Media espacial
;----------------------------------------------

;--- Ler arquivo e variavel
fm = addfile(dirm+"gpcp_1979-2019.nc","r")
vm = fm->precip

;--- Media climatologica 1981-2010
clim = clmMonTLL(vm(24:383,:,:))

;--- media espacial
media = wgt_areaave(vm(:,{lata:latb},{lona:lonb}),1.0,1.0,1)
media_clim = wgt_areaave(clim(:,{lata:latb},{lona:lonb}),1.0,1.0,1)

;----------------------------------------------
; Selecionar intervalo de anos
;----------------------------------------------

;-- replicar climatologia
clim2 = new((/nt/),float)
clim2!0 = "time"

k = 0
do i=0,nyears-1
  j = 0
  do j=0,11
     clim2(k) = media_clim(j)
     k = k +1
  end do
end do

;-- selecionar intervalo entre anoi e anof
media2 = media(ti:tf)

;-----------------------------------------
; Time dimension
; cria uma matriz para o tempo (ano e mes)
;------------------------------------------

;--- valor de tempo para grafico
time = ispan(1,nt,1)
time@long_name = "Time"

;--- matriz para rotulo dos anos
ltime = new((/nyears+1/),float)
ltime!0 = "time"

do i=0,nyears
  ltime(i) = anoi + i
end do

;--- matriz para posicao dos rotulos
xval = new((/nyears+1/),float)
xval!0 = "time"
do i=0,nyears
  xval(i) = (i*12) + 1
end do

;-------------------------------------------------
; Plot
;--------------------------------------------------
wks = gsn_open_wks(wks_type,wksName)
labels  =  (/" Climatologia"/)       ;-- line labels
colors  =  (/"red"/)                 ;-- line colors
  
;-- set resources
res =  True
res@gsnDraw  =  False
res@gsnFrame =  False
res@gsnXYBarChart =  True
res@gsnXYBarChartColors   = "darkseagreen"
res@tmXTOn = False ; sem eixos superior
res@tmYROn = False ; e direito
res@trYMinF = 0              ;-- y-axis min value
res@trYMaxF = 10             ;-- y-axis max value
res@xyXStyle  = "Time"
res@tmXBMode = "Explicit"
res@tmXBValues = xval
res@tmXBLabels = ltime   
   
;-- bar chart plot
bars = gsn_csm_xy(wks, time, media2, res)

;-- line plot resources
delete([/res@gsnXYBarChart,res@gsnXYBarChartColors/])
resa =  res             ;-- line plot resources
resa@xyLineColors =  colors          ;-- set line colors
resa@xyMarkLineModes = "Lines"          ;-- line modus
resa@xyDashPatterns =  (/0/)
resa@xyLineThicknesses =  (/6.0/)

;-- line plot
lines = gsn_csm_xy(wks, time, clim2, resa)

;-- overlay line plot on bar chart plot
overlay(bars,lines)

;-- create a legend
nitems  =  2 ;-- bars and two lines with labels
labels  :=  (/" Media mensal"," Climatologia"/);-- line labels
colors  :=  (/"darkseagreen","red"/)       ;-- line colors
pattern :=  (/0,  0/)                     ;-- line pattern
size    :=  (/8.0,4.0/)                   ;-- line thickness
   
lgres                    =  True
lgres@lgLineColors       =  colors
lgres@lgMonoLineThickness =  False
lgres@lgLineThicknesses  =  size
lgres@lgDashIndexes      =  pattern
lgres@lgItemType         = "Lines" 
lgres@lgLabelFontHeightF =  0.10
lgres@vpWidthF           =  0.15
lgres@vpHeightF          =  0.08
lgres@lgPerimOn          =  False

lbid = gsn_create_legend(wks,nitems,labels,lgres) ;-- create legend

amres                     =  True
amres@amParallelPosF      =  0.38
amres@amOrthogonalPosF    =  0.68
annoid1 = gsn_add_annotation(bars,lbid,amres)     ;-- add legend to plot

;-- draw the plot
draw(bars)
frame(wks)
   
end