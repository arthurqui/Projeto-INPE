load "/mnt/c/users/arthur/documents/ic/4.5/shapefile_utils.ncl" ; script usado para shapefiles
load "/mnt/c/users/arthur/documents/ic/4.5/text.ncl"

begin

cod = (/"3501","3502","3503","3504","3505","3506","3507","3508","3509","3510","3511","3512","3513","3514","3515"/)

minlat = -25
maxlat = -19
minlon = -54
maxlon = -43

dir = "/mnt/c/users/arthur/documents/ic/4.5/" ;local mascara
;dirc = "/mnt/c/users/arthur/documents/ic/4.3.2/";local chirps pequeno
dird = "/mnt/c/users/arthur/documents/ic2/4.2/" ;local chirps grande
sname = dir+"SP_Mesorregioes_2019.shp"
;f = addfile(sname,"r") ;Mascara

;fc = addfile(dirc+"novochirps2.nc","r") ;chirps 256mb 
fd = addfile (dird+"novochirps2.nc","r") ;chirps 6gb

media = new((/15,480/),float) 

;clm = fc->precip(:,:,:)
f1 = fd->precip(:,{minlat:maxlat},:)

lat = fd->latitude      
rad = 4.0*atan(1.0)/180
clat = cos(lat*rad)
clat!0 = "lat"
clat&lat = lat

opt             = True
opt@return_mask = True
opt@debug       = True
opt@shape_var   = "CD_MESO"  ; variavel do shapefile

do j=0,14
	opt@shape_names = cod(j)     
	prec_mask      := shapefile_mask_data(f1(0,:,:),sname,opt)
	copy_VarMeta(f1(0,:,:),prec_mask)
	m3 := conform_dims(dimsizes(f1),prec_mask,(/1,2/))  ; 3Dmask 
	;printVarSummary(m3)
	n1 :=  mask(f1,m3,1) 
	;printVarSummary(n1)
	media(j,:) = wgt_areaave(n1(:,:,:),clat({minlat:maxlat}),1.0,0) 
	printVarSummary(media)
	print("media")
end do

media!0 = "area"
media!1 = "time"
media&time = f1&time

;---Write new mask to file

print("Creating the mask file...")
mask_fname = "prec-mensal.nc"
system("rm -f " + mask_fname)
fout = addfile(mask_fname,"c")
fout->pr = media(:,:)

end



