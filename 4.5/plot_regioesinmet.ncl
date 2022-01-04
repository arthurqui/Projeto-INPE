;-------------------------------------------------------
; Mapa Mesorregioes de SP - INMET
;-------------------------------------------------------
load "/mnt/c/users/arthur/documents/ic/4.5/shapefile_utils.ncl" ; script usado para shapefiles
load "/mnt/c/users/arthur/documents/ic/4.5/text.ncl"

begin

;-------------------------------------------------------
; User specifications
;-------------------------------------------------------
palT1  = "GMT_drywet"  ; paleta de cores
   
dir = "/mnt/c/users/arthur/documents/ic/4.5/" ; Mudar 
sname = dir+"SP_Mesorregioes_2019.shp"        ; e nome do shapefile  
f = addfile(sname,"r")
print_shapefile_info(sname);printar informações sobre o shapefile

;-------------------------------------------------------

wks_type = "png"
wks_type@wkWidth  = 5500  ; usado para figura em alta
wks_type@wkHeight = 5500  ; resolucao
wksName = "meida 4x3 inmet"

;-----------------------------------------------------
; Read in netCDF files
;-----------------------------------------------------
fc = addfile(dir+"Normais_INMET_1981_2010_prec.nc","r")
prec = fc->prec
printVarSummary(prec)

media = new((/1,12/),float) ; (regioes,tempo)
time = ispan(1,12,1)
time@long_name = "Time"
time_lab = (/"Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago","Set","Out","Nov","Dez"/) ;label
lat = fc->lat  

;---Comandos para salvar apenas os dados sobre o estado
dims = dimsizes(prec) 
opt             = True
opt@return_mask = True
opt@debug       = True
opt@shape_var   = "SIGLA_UF"  ; variavel do shapefile
opt@shape_names = (/"SP"/)     ; codigo do estado
prec_mask       = shapefile_mask_data(prec(0,:,:),sname,opt)
copy_VarMeta(prec(0,:,:),prec_mask)
m3 = conform_dims(dimsizes(prec),prec_mask,(/1,2/))  ; 3Dmask
n1 = mask(prec,m3,1)

;----------------Mudar rotulo da variável----
n1!0 = "time"
n1!1 = "lat"
n1!2 = "lon"
n1&lat = prec&lat
n1&lon = prec&lon
;---------------------------------------------
;printVarSummary(n1) ; printar variável

;-- annual mean

; do j=0,11
; media(:,j) = wgt_areaave(n1(j,:,:),lat,1.0,0)
; printVarSummary(media)
; end do

;vm = dim_avg_n_Wrap(n1,0)
;printVarSummary(vm)
;printVarSummary(n1)
;-------------------------------------------------------
; create plots
;-------------------------------------------------------
wks = gsn_open_wks(wks_type,wksName) 
setvalues NhlGetWorkspaceObjectId() ; usado para chirps
   "wsMaximumSize" : 800000000
end setvalues

res = True
res@gsnDraw = False
res@gsnFrame = False
res@gsnAddCyclic = False
res@gsnRightString = ""
res@gsnLeftString = ""
res@cnLineLabelsOn = False
res@cnFillOn = True         
res@cnLinesOn = False
res@cnFillPalette = palT1
res@mpMinLatF = -26  ; Zoom in on SP
res@mpMaxLatF = -19
res@mpMinLonF = -54
res@mpMaxLonF = -43
res@cnFillMode = "RasterFill"
res@cnFillDrawOrder = "Predraw"
res@cnSpanFillPalette = True
res@cnLevelSelectionMode = "ManualLevels"
res@cnMaxLevelValF = 260     ; mudar valores maximos
res@cnMinLevelValF = 100      ; e intervalo
res@cnLevelSpacingF = 20
res@tmYROn = False
res@tmXTOn = False
res@tmXTOn      = False
res@tmYROn      = False
res@tmXBOn      = False
res@tmYLOn      = False
res@tmBorderLineColor = 0

; Zoom in SP
res@mpDataSetName = "Earth..4"
res@mpDataBaseVersion = "MediumRes"
res@mpFillBoundarySets = "NoBoundaries"
res@mpFillAreaSpecifiers = (/"Land","brazil","Water"/)
res@mpSpecifiedFillColors = (/"white","transparent","white"/)
res@mpOutlineOn = False

plot = new(12,graphic)    ; create a 4D array

do i=0,11
plot(i) = gsn_csm_contour_map(wks,media(:,i),res)
res = True                  ; desenha os contornos
res@gsLineColor = "black"
res@gsLineThicknessF = 6.0
poly = gsn_add_shapefile_polylines(wks,plot(i),sname,res)

end do

 ;--- Panel plots
 panelres =  True          ; Panel resources
 panelres@gsnFrame = False
 panelres@gsnPanelTop =  0.95

;-- create the panel
gsn_panel(wks,plot,(/4,3/),panelres)  ; now draw plots

frame(wks)

end




