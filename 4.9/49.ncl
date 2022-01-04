load "/mnt/c/users/arthur/documents/ic/4.5/shapefile_utils.ncl" ; script usado para shapefiles
load "/mnt/c/users/arthur/documents/ic/4.5/text.ncl"

begin

wksName = "temporal-series2"         ; nome da figura
wks_type          = "png"
wks_type@wkWidth  = 2500  ; para figura com
wks_type@wkHeight = 2500  ; maior qualidade

reg = (/"S"+atilde+"o Jos"+eacute+" do Rio Preto","Ribeir"+atilde+"o Preto","Ara"+cedil+"atuba","Bauru","Araraquara","Piracicaba","Campinas","Presidente Prudente","Mar"+iacute+"lia","Assis","Itapetininga","Macro Metropolitana Paulista","Vale do Para"+iacute+"ba","Litoral Sul","Metropolitana de SP"/)


dir = "/mnt/c/users/arthur/documents/ic/4.5/" ;local mascara
dird = "/mnt/c/users/arthur/documents/ic/4.7/" ;local chirps 


fm = addfile (dird+"prec-anom.nc","r") ;chirps 
vm = fm->pr
printVarSummary(vm)

pr_order = vm(time|:,area|:) ;month_to_annual necessita variavel time no incio

;--- Media anual
yclim = month_to_annual(pr_order,1)
printVarSummary(yclim)
yclim_order = yclim(area|:,year|:) ;gsn_csm_xy necessita variavel time no final

print(2)
;-----------------------------------------
; Time dimension
; cria uma matriz para o tempo (ano e mes)
;------------------------------------------

timey = ispan(1981,2020,1)
timey@long_name = "Time"
print(3)
;-------------------------------------------------
; Plot
;--------------------------------------------------
wks = gsn_open_wks(wks_type,wksName)


; plot = new(15,graphic)    ; create a 4D array
xy_plot  = new(15,graphic)  ; xy line plots

resR = True

resR@gsnFrame = False
resR@gsnDraw  = False

resR@xyLineThicknessF = 4.0  ; espessura da linha
resR@xyDashPattern = 0       ; tipo de tracejado   
resR@xyLineColor = "black"     ; cor da linha
resR@gsnXYBarChartBarWidth = 1

resR@vpHeightF = 0.43        ; Changes the aspect ratio
resR@vpWidthF  = 0.85

resR@tmXTOn = False ; sem eixos superior
resR@tmYROn = False ; e direito
resR@tiXAxisString = ""
resR@tiYAxisString = ""
resR@trXMinF = 1980  ; valor minimo do eixo Y 
resR@trXMaxF = 2021 
resR@trYMinF = -45  ; valor minimo do eixo Y 
resR@trYMaxF = 75 
resR@gsnCenterString = "Anomalia de Precipita"+cedil+atilde+"o (mm/dia)";
resR@gsnXYBarChart         = True
resR@gsnYRefLine           = 0.
resR@gsnAboveYRefLineColor = "lightskyblue" 
resR@gsnBelowYRefLineColor = "lightcoral"

do i=0,14
resR@tiMainString  = reg(i) ; 
	
;--- plot media anual

xy_plot(i) = gsn_csm_xy (wks,timey,yclim_order(i,:),resR)

end do

;--- Panel plots
 panelres =  True          ; Panel resources
 panelres@gsnFrame = False
 panelres@gsnPanelTop =  0.95
 
;-- create the panel
gsn_panel(wks,xy_plot,(/5,3/),panelres)  ; now draw plots
frame(wks)
end


