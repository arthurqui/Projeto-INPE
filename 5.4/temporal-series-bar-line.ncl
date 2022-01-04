load "/mnt/c/users/arthur/documents/ic/4.5/text.ncl"
begin

;-------------------------------------------------
; User specifications
;-------------------------------------------------
; lata = -40  ; define lat-lon
; latb = 5   ; para calculo
; lona = 290    ; das medias
; lonb = 320  ; espaciais
reg = (/"S"+atilde+"o Jos"+eacute+" do Rio Preto","Ribeir"+atilde+"o Preto","Ara"+cedil+"atuba","Bauru","Araraquara","Piracicaba","Campinas","Presidente Prudente","Mar"+iacute+"lia","Assis","Itapetininga","Macro Metropolitana Paulista","Vale do Para"+iacute+"ba","Litoral Sul","Metropolitana de SP"/)


; anoi = 2018 ;para o painel colocar de 2018 a 2020
; anof = 2020

anoi = toint(getenv("inicial"))
anof = toint(getenv("final"))

; reg = 0
ti = (anoi - 1981)*12         ; Jan anoi (colocar ano inicial do arquivo no lugar do 1979)
tf = ((anof - 1981)*12) + 11  ; Dec anof
nt = ((anof - anoi) + 1) * 12 ; numero de tempos
nyears = (anof - anoi) + 1    ; numero de anos

 ; wksName = "temporal-series-bar-line2" ; nome da figura
wksName = getenv("wks")
wks_type          = "png"
wks_type@wkWidth  = 2500  ; para figura com
wks_type@wkHeight = 2500  ; maior qualidade
dirm = "/mnt/c/users/arthur/documents/ic/5.4/" ; diretorio C:\Users\Arthur\Documents\IC\5.4

;----------------------------------------------
; Media espacial
;----------------------------------------------

;--- Ler arquivo e variavel

fc = addfile(dirm+"prec-clim.nc","r")
vc = fc->pr ;climatologia
print(vc)

fm = addfile(dirm+"prec-mensal.nc","r")
vm = fm->pr ;media

;----------------------------------------------
; Selecionar intervalo de anos
;----------------------------------------------

;-- replicar climatologia
clim2 = new((/15,nt/),float)
clim2!0 = "time"

k = 0
do i=0,nyears-1
  j = 0
  do j=0,11
     clim2(:,k) = vc(:,j)
     k = k +1
  end do
end do

;-- selecionar intervalo entre anoi e anof
media2 = vm(:,ti:tf)

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
plot = new(15,graphic)  ;plot do painel
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
;res@trYMaxF = 20             ;-- y-axis max value
res@xyXStyle  = "Time"
res@tmXBMode = "Explicit"
res@tmXBValues = xval
res@tmXBLabels = ltime   
resa = True
resa@gsnDraw  =  False
resa@gsnFrame =  False
resa@tmYROn = False ; e direito
resa@trYMinF = 0              ;-- y-axis min value
;res@trYMaxF = 20             ;-- y-axis max value
resa@xyXStyle  = "Time"
resa@tmXBMode = "Explicit"
resa@tmXBValues = xval
resa@tmXBLabels = ltime  
resa@xyLineColors =  colors          ;-- set line colors
resa@xyMarkLineModes = "Lines"          ;-- line modus
resa@xyDashPatterns =  (/0/)
resa@xyLineThicknesses =  (/6.0/)

;-- bar chart plot
do i=0,14
res@tiMainString  = reg(i) 
bars = gsn_csm_xy(wks, time, media2(i,:), res)

;-- line plot resources
; delete([/res@gsnXYBarChart,res@gsnXYBarChartColors/])
            ;-- line plot resources


;-- line plot
lines = gsn_csm_xy(wks, time, clim2(i,:), resa)
;-- overlay line plot on bar chart plot
overlay(bars,lines)
plot(i) = bars
end do

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
amres@amParallelPosF      =  -0.50
amres@amOrthogonalPosF    =  -0.10
; annoid1 = gsn_add_annotation(bars,lbid,amres)     ;-- add legend to plot

;-- draw the plot


;--- Panel plots
panelres =  True          ; Panel resources
panelres@gsnFrame = False


panelres@gsnPanelTop =  0.95

;-- create the panel
gsn_panel(wks,plot,(/5,3/),panelres)  ; now draw plots

;----- legend
   colors = (/"darkseagreen","red"/) 
   line_dash = (/0,0/)
   nsrc = (/"Media mensal"," Climatologia"/)  

   gsres = True
   gsres@gsLineThicknessF = 6
   txres = True
   txres@txFontHeightF = 0.008
   txres@txJust = "CenterLeft"

   x  = (/.38,.55/) 
   x2 = (/.41,.58/)  
   xt = (/.42,.59/)  
   y  = (/.97,.97/)  

 do i=0,1
   gsres@gsLineColor       = colors(i)
   gsres@gsLineDashPattern = line_dash(i)
   gsn_polyline_ndc(wks, (/x(i),x2(i)/),(/y(i),y(i)/),gsres)
   gsn_text_ndc    (wks,nsrc(i),xt(i),y(i),txres)
 end do


frame(wks)
   
end 
