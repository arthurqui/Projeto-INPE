;-------------------------------------------------
; Plot serie temporal de precipitacao
;-------------------------------------------------
load "/mnt/c/users/arthur/documents/ic/4.5/shapefile_utils.ncl" ; script usado para shapefiles
load "/mnt/c/users/arthur/documents/ic/4.5/text.ncl"

begin

;abrindo o arquivo shapefile e verificando o codigo do estado
; dir = "/mnt/c/users/arthur/documents/ic/4.5/"
; f = addfile(dir + "SP_Mesorregioes_2019.shp", "r") 
; sname = dir+"SP_Mesorregioes_2019.shp"
; print_shapefile_info(sname)
; var = f->CD_MESO(:)
; print(var)

palT1  = "GMT_drywet"  ; paleta de cores
   
dir = "/mnt/c/users/arthur/documents/ic/4.5/" ; Mudar 
sname = dir+"SP_Mesorregioes_2019.shp"        ; e nome do shapefile  
f = addfile(sname,"r")
print_shapefile_info(sname)

fc = addfile(dir+"Normais_INMET_1981_2010_prec.nc","r")
prec = fc->prec
printVarSummary(prec)

cod = (/"3501","3502","3503","3504","3505","3506","3507","3508","3509","3510","3511","3512","3513","3514","3515"/)
reg = (/"S"+atilde+"o Jos"+eacute+" do Rio Preto","Ribeir"+atilde+"o Preto","Ara"+cedil+"atuba","Bauru","Araraquara","Piracicaba","Campinas","Presidente Prudente","Mar"+iacute+"lia","Assis","Itapetininga","Macro Metropolitana Paulista","Vale do Para"+iacute+"ba","Litoral Sul","Metropolitana de SP"/)


time_lab = (/"Janeiro", "Fevereiro", "Mar"+cedil+"o", "Abril", "Maio", "Junho", "Julho", "Agosto","Setembro","Outubro","Novembro","Dezembro"/) ;label


;---Comandos para salvar apenas os dados sobre o estado, funciona para apenas um tempo
dims = dimsizes(prec) 
opt             = True
opt@return_mask = True
opt@debug       = True
opt@shape_var   = "SIGLA_UF"  ; variavel do shapefile
opt@shape_names = (/"SP"/)    ; codigo da região - (0) colocar (j) quando começar a repetição
prec_mask      := shapefile_mask_data(prec(0,:,:),sname,opt)
copy_VarMeta(prec(0,:,:),prec_mask)
m3 := conform_dims(dimsizes(prec),prec_mask,(/1,2/))  ; 3Dmask
n1 :=  mask(prec,m3,1); (":=" força sobreescrever a variavel)

;----------------Mudar rotulo da variável----
n1!0 = "time"
n1!1 = "lat"
n1!2 = "lon"
n1&lat = prec&lat
n1&lon = prec&lon
;---------------------------------------------

wksName = "graficoregioes4x3-rotulo"         ; nome da figura
wks_type          = "png"
wks_type@wkWidth  = 2500  ; para figura com
wks_type@wkHeight = 2500  ; maior qualidade

;-------------------------------------------------
; Plot
;--------------------------------------------------
wks = gsn_open_wks(wks_type,wksName)

;--------plot-----------

res = True
res@gsnDraw = False
res@gsnFrame = False
res@lbLabelBarOn = False
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
res@cnMaxLevelValF = 340    ; mudar valores maximos
res@cnMinLevelValF = 0      ; e intervalo
res@cnLevelSpacingF = 30
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
 ; center title
 
 do i=0,11
	;res@gsnCenterString = time_lab(i)
	plot(i)= gsn_csm_contour_map(wks,n1(i,:,:),res) ; plot 1
 end do
 
 ;---Section to add polylines to map.
pres = True                  ; desenha os contornos
pres@gsLineColor = "black"
pres@gsLineThicknessF = 6.0
poly = gsn_add_shapefile_polylines(wks,plot,sname,pres)
   
 ;--- Panel plots
 panelres =  True          ; Panel resources
 panelres@gsnPanelLabelBar = True
 panelres@gsnFrame = False
 panelres@txString = "M"+eacute+"dia mensal de precipita"+cedil+atilde+"o"
 panelres@gsnPanelTop =  0.95
 panelres@gsnPanelFigureStrings = time_lab

;-- create the panel
gsn_panel(wks,plot,(/4,3/),panelres)  ; now draw plots

frame(wks)
end


