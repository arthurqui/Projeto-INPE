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
<<<<<<< HEAD
dird = "/mnt/c/users/arthur/documents/ic2/4.2/" ;local chirps grande
=======
dird = "/mnt/c/users/arthur/documents/ic/4.2/" ;local chirps grande
>>>>>>> 72e1c76ab40ee615ec0162cfa55588a6963e3ca7
sname = dir+"SP_Mesorregioes_2019.shp"
;f = addfile(sname,"r") ;Mascara

;fc = addfile(dirc+"novochirps2.nc","r") ;chirps 256mb 
fd = addfile (dird+"novochirps2.nc","r") ;chirps 6gb

<<<<<<< HEAD
media = new((/15,12/),float) 
=======
media = new((/15,480/),float) 
>>>>>>> 72e1c76ab40ee615ec0162cfa55588a6963e3ca7

;clm = fc->precip(:,:,:)
tot = fd->precip(:,:,:)

<<<<<<< HEAD
va = clmMonTLL (tot(0:359,:,:)) ; 
print("clm")
printVarSummary(va)
; va := month_to_annual(clm,0) ;[total,climatologia]
; print("va")
=======
clm = clmMonTLL (tot(0:359,:,:)) ; 
print("clm")
va := month_to_annual(clm,0) ;[total,climatologia]
print("va")
>>>>>>> 72e1c76ab40ee615ec0162cfa55588a6963e3ca7
;var1 := lonFlip(va)              ; -180 to 180
f1 := va(:,{minlat:maxlat},{minlon:maxlon}) ;- restrict range  
print("f1")

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
	n1 :=  mask(f1,m3,1) 
	media(j,:) = wgt_areaave(n1(:,:,:),clat({minlat:maxlat}),1.0,0) 
	print("media")
end do

media!0 = "area"
media!1 = "time"
<<<<<<< HEAD
media&time = va&month
=======
media&time = tot&time
>>>>>>> 72e1c76ab40ee615ec0162cfa55588a6963e3ca7

;---Write new mask to file

print("Creating the mask file...")
mask_fname = "prec-clim.nc"
system("rm -f " + mask_fname)
fout = addfile(mask_fname,"c")
fout->pr = media(:,:)

end

;usar yclim = month_to_annual(vm,1)
