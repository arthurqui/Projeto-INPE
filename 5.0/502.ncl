;-------------------------------------------------------
; Plot NE e N basins 
; and annual precipitation
;-------------------------------------------------------
load "/mnt/c/users/arthur/documents/ic/4.3.2/shapefile_utils.ncl" ;
load "/mnt/c/users/arthur/documents/ic/4.5/text.ncl"
begin

;-------------------------------------------------------
; User specifications
;-------------------------------------------------------
;palT1  = "GMT_drywet"  ; paleta de cores
palT1  = "BrownBlue12"
   
dirc = "/mnt/c/users/arthur/documents/ic/4.2/" ; Mudar 
;dir  = "/mnt/c/users/arthur/documents/ic/4.3/"; diretorios
sname = dirc+"SP_Mesorregioes_2019.shp"        ; e nome do shapefile  
f = addfile(sname,"r")
print_shapefile_info(sname);printar informações sobre o shapefile

;-------------------shapefiles estados Brasil------------------------------------

;g = addfile(dirc + "BR_UF_2019.shp", "r") ;
;shname = dirc+"BR_UF_2019.shp"
;print_shapefile_info(shname)
;var = g->SIGLA_UF(:)
;print(var)

;-------------------------------------------------------

wks_type = "png"
wks_type@wkWidth  = 5500  ; usado para figura em alta
wks_type@wkHeight = 5500  ; resolucao
wksName = "fig-regioes1983"

mes = ispan(25,36,1)
labmes = (/"Jan","Fev","Mar","Abr","Mai","Jun","Jul","Ago","Set","Out","Nov","Dez"/)
; Read in netCDF files
;-----------------------------------------------------
fc = addfile(dirc+"novochirps2.nc","r")
vp = fc->precip(:,:,:)
printVarSummary(vp);printar dados da variavel

;-- annual mean
; vm = dim_avg_n_Wrap(n1,0)
clm = clmMonTLL(vp)
anom = calcMonAnomTLL (vp,clm)

;---Comandos para salvar apenas os dados sobre o estado
dims = dimsizes(anom) 
opt             = True
opt@return_mask = True
opt@debug       = True
opt@shape_var   = "SIGLA_UF"  ; variavel do shapefile
opt@shape_names = (/"SP"/)     ; codigo do estado
prec_mask       = shapefile_mask_data(anom(0,:,:),sname,opt)
copy_VarMeta(anom(0,:,:),prec_mask)
m3 = conform_dims(dimsizes(anom),prec_mask,(/1,2/))  ; 3Dmask
n1 = mask(anom,m3,1)


;----------------Mudar rotulo da variável----
n1!0 = "time"
n1!1 = "lat"
n1!2 = "lon"
n1&lat = vp&latitude
n1&lon = vp&longitude
;---------------------------------------------
printVarSummary(n1) ; printar variável



;-------------------------------------------------------
; create plots
;-------------------------------------------------------
wks = gsn_open_wks(wks_type,wksName) 
setvalues NhlGetWorkspaceObjectId() ; usado para chirps
   "wsMaximumSize" : 800000000
end setvalues

res = True
res@lbLabelBarOn = False
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
res@cnMaxLevelValF = 150     ; mudar valores maximos
res@cnMinLevelValF = -150      ; e intervalo
res@cnLevelSpacingF = 25
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

; plot = gsn_csm_contour_map(wks,vm,res)
plot = new(12,graphic)    ; create a 12D array

do i=0,11
res@gsnCenterString = "Anomalia "+labmes(i); center title
plot(i)= gsn_csm_contour_map(wks,n1(mes(i),:,:),res) ; plot 1 Jan
end do

;---Section to add polylines to map.
pres = True                  ; desenha os contornos
pres@gsLineColor = "black"
pres@gsLineThicknessF = 6.0
poly = gsn_add_shapefile_polylines(wks,plot,sname,pres)

;--- Panel plots
panelres =  True          ; Panel resources
panelres@gsnFrame = False
panelres@gsnPanelMainString       = "1983"
panelres@gsnPanelLabelBar = True ; add a common label bar

panelres@gsnPanelTop =  0.95

;-- create the panel
gsn_panel(wks,plot,(/4,3/),panelres)  ; now draw plots


frame(wks)

end




