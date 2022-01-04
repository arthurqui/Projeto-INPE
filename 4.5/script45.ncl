;-------------------------------------------------
; Plot serie temporal de precipitacao
;-------------------------------------------------
load "/mnt/c/users/arthur/documents/ic/4.5/shapefile_utils.ncl" ; script usado para shapefiles
load "/mnt/c/users/arthur/documents/ic/4.5/text.ncl"

begin

;abrindo o arquivo shapefile e verificando o codigo do estado
dir = "/mnt/c/users/arthur/documents/ic/4.5/"
f = addfile(dir + "SP_Mesorregioes_2019.shp", "r") 
sname = dir+"SP_Mesorregioes_2019.shp"
;print_shapefile_info(sname)
var = f->CD_MESO(:)
print(var)

cod = (/"3501","3502","3503","3504","3505","3506","3507","3508","3509","3510","3511","3512","3513","3514","3515"/)
reg = (/"S"+atilde+"o Jos"+eacute+" do Rio Preto","Ribeir"+atilde+"o Preto","Ara"+cedil+"atuba","Bauru","Araraquara","Piracicaba","Campinas","Presidente Prudente","Mar"+iacute+"lia","Assis","Itapetininga","Macro Metropolitana Paulista","Vale do Para"+iacute+"ba","Litoral Sul","Metropolitana de SP"/)

; abrindo arquivo de precipitação
dirp = "/mnt/c/users/arthur/documents/ic/4.5/"
g = addfile(dirp+"Normais_INMET_1981_2010_prec.nc","r")
prec = g->prec

media = new((/15,12/),float) ; (regioes,tempo)

;--- para a media ponderada
lat = g->lat      
rad = 4.0*atan(1.0)/180
clat = cos(lat*rad)
clat!0 = "lat"
clat&lat = lat

;---Comandos para salvar apenas os dados sobre o estado, funciona para apenas um tempo
dims = dimsizes(prec) 
opt             = True
opt@return_mask = True
opt@debug       = True
opt@shape_var   = "CD_MESO"  ; variavel do shapefile

do j=0,14
	opt@shape_names = cod(j)     ; codigo da região - (0) colocar (j) quando começar a repetição
	prec_mask      := shapefile_mask_data(prec(0,:,:),sname,opt)
	copy_VarMeta(prec(0,:,:),prec_mask)
	m3 := conform_dims(dimsizes(prec),prec_mask,(/1,2/))  ; 3Dmask
	n1 :=  mask(prec,m3,1); (":=" força sobreescrever a variavel)
	media(j,:) = wgt_areaave(n1(:,:,:),clat,1.0,0)
end do
printVarSummary(n1)

wksName = "graficoBarra5x3"         ; nome da figura
wks_type          = "png"
wks_type@wkWidth  = 2500  ; para figura com
wks_type@wkHeight = 2500  ; maior qualidade

time = ispan(1,12,1)
time@long_name = "Time"
time_lab = (/"Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago","Set","Out","Nov","Dez"/) ;label

;-------------------------------------------------
; Plot
;--------------------------------------------------
wks = gsn_open_wks(wks_type,wksName)

;--------plot barra-----------

 res   = True
 res@gsnScale = True               
 
 res@gsnFrame = False
 res@gsnDraw  = False
 
 res@tmXBMode = "Explicit"
 res@tmXBValues = time
 res@tmXBLabels = time_lab

 ;plot(j) = gsn_csm_xy (wks,time,media(j,:),res)

 plot = new(15,graphic)    ; create a 4D array
 res@gsnCenterString = "Climatologia Mensal (INMET)"; center title
 
 do i=0,14
	res@tiMainString  = reg(i) ; 
	res@tiYAxisString = "Precipita"+cedil+atilde+"o" ; y-axis label 
	res@trYMaxF   =  310.0        ; max value on y-axis
	res@gsnXYBarChartBarWidth = 0.7 ;DIMINUIR LARGURA
	res@vpHeightF = 0.43        ; Changes the aspect ratio
	res@vpWidthF  = 0.85
	res@gsnMaximize = True
	res@trYMinF   = 0.0        ; min value on y-axis
	res@gsnYRefLine           = 0.              ; reference line   
	res@gsnXYBarChart         = True            ; create bar chart 
	res@gsnAboveYRefLineColor = "cadetblue"           ; above ref line fill red
	;res@gsnBelowYRefLineColor = "blue"          ; below ref line fill blue
	;res@gsnXYBarChartColors   = "gray60"
	plot(i)= gsn_csm_xy(wks,time,media(i,:),res) ; plot 1
 end do
   
 ;--- Panel plots
 panelres =  True          ; Panel resources
 panelres@gsnFrame = False
 panelres@gsnPanelTop =  0.95

;-- create the panel
gsn_panel(wks,plot,(/5,3/),panelres)  ; now draw plots

frame(wks)
end


