;-------------------------------------------------
; Plot serie temporal de precipitacao
;-------------------------------------------------
load "/mnt/c/users/arthur/documents/ic/4.5/shapefile_utils.ncl" ; script usado para shapefiles

begin

;abrindo o arquivo shapefile e verificando o codigo do estado
dir = "/mnt/c/users/arthur/documents/ic/4.5/"
f = addfile(dir + "SP_Mesorregioes_2019.shp", "r") 
sname = dir+"SP_Mesorregioes_2019.shp"
;print_shapefile_info(sname)
var = f->SIGLA_UF(:)
;print(var)

; abrindo arquivo de precipitação
dirp = "/mnt/c/users/arthur/documents/ic/4.5/"
g = addfile(dirp+"Normais_INMET_1981_2010_prec.nc","r")
prec = g->prec

;ANTIGO--- Ler arquivo e variavel
;fm = addfile(dirm+"gpcp_1979-2019.nc","r")
;vm = fm->precip

;---Comandos para salvar apenas os dados sobre o estado, funciona para apenas um tempo
dims = dimsizes(prec) 
opt             = True
opt@return_mask = True
opt@debug       = True
opt@shape_var   = "CD_MESO"  ; variavel do shapefile
opt@shape_names = (/"3513"/)     ; codigo do estado
prec_mask       = shapefile_mask_data(prec(0,:,:),sname,opt)
copy_VarMeta(prec(0,:,:),prec_mask)
m3 := conform_dims(dimsizes(prec),prec_mask,(/1,2/))  ; 3Dmask
n1 := mask(prec,m3,1)
;printVarSummary(n1)

wksName = "graficoBarrabackup"         ; nome da figura
wks_type          = "png"
wks_type@wkWidth  = 2500  ; para figura com
wks_type@wkHeight = 2500  ; maior qualidade


;----------------------MEDIAS------------------------
;--- Media anual
yclim = month_to_annual(prec,0)

;--- para a media ponderada
lat = g->lat      ;o que era "FM" virou "g" e o que era "vm" virou "prec"
rad = 4.0*atan(1.0)/180
clat = cos(lat*rad)
clat!0 = "lat"
clat&lat = lat

;Modificado
;--- media espacial ponderada
media = wgt_areaave(n1(:,:,:),clat,1.0,0)

;--- media espacial ponderada e media anual
;ymedia = wgt_areaave(yclim(:,:,:),1.0,1.0,1)

;ORIGINAL
;--- media espacial ponderada
;media = wgt_areaave(vm(:,{lata:latb},{lona:lonb}),clat({lata:latb}),1.0,1)
;--- media espacial ponderada e media anual 
;ymedia = wgt_areaave(yclim(:,{lata:latb},{lona:lonb}),clat({lata:latb}),1.0,1)


; Time dimension
; cria uma matriz para o tempo (ano e mes)
;------------------------------------------
time = yyyymm_time(1979, 2019, "integer")
time@long_name = "Time"

timey = ispan(1,12,1)
timey@long_name = "Time"

;-------------------------------------------------
; Plot
;--------------------------------------------------
wks = gsn_open_wks(wks_type,wksName)
;xy_plot  = new(2,graphic)  ; xy line plots

;resR = True
;resR@xyLineThicknessF = 4.0  ; espessura da linha
;resR@xyDashPattern = 0       ; tipo de tracejado   
;resR@xyLineColor = "red"     ; cor da linha

;resR@tmXTOn = False ; sem eixos superior
;resR@tmYROn = False ; e direito
;resR@tiYAxisString = "Precipitacao (mm/dia)"
;resR@trXMinF =  197901 ; valor minimo do eixo X 

;--- plot media mensal
;xy_plot(0) = gsn_csm_xy (wks,timey,media,resR)

;--- plot media anual
;resR@trXMinF =  1979 ; valor minimo do eixo X 
;xy_plot(0) = gsn_csm_xy (wks,timey,ymedia,resR)


;--------plot barra-----------
;wks   = gsn_open_wks ("png", "bar" )  ; send graphics to PNG file
 res   = True
 res@gsnScale = True               

; these four resources allow the user to stretch the plot size, and
; decide exactly where on the page to draw it.

; res@vpXF      = 0.10        ; In page coordinates, where to start
; res@vpYF      = 0.75        ; the plot
 res@vpHeightF = 0.43        ; Changes the aspect ratio
 res@vpWidthF  = 0.85
 res@gsnMaximize = True

 res@trYMinF   = 40.0        ; min value on y-axis
 res@trYMaxF   =  280.0        ; max value on y-axis

 res@tiYAxisString = "Precipitacao" ; y-axis label      
 res@tiXAxisString = "Mes"
 res@tiMainString  = "Climatologia Mensal do Vale do Paraiba (INMET)" ; title

 res@gsnYRefLine           = 0.              ; reference line   
 res@gsnXYBarChart         = True            ; create bar chart 
 res@gsnAboveYRefLineColor = "grey"           ; above ref line fill red
 res@gsnBelowYRefLineColor = "blue"          ; below ref line fill blue

 plot = gsn_csm_xy (wks,timey,media,res)

end


