begin
;Endereço arquivo.nc
f = addfile("/mnt/c/Users/Arthur/Documents/IC/4.0/novo.nc","r")  ; "r" = read
;Leitura de variavel
precip = f->precip(0,:,:)

;---Open workstation
  wks = gsn_open_wks("png","printncl")       
  res                   = True
  res@gsnMaximize       = True        ; maximize plot in frame
  res@cnFillOn = True        ; shaded plot
  res@cnLinesOn = False      ; no lines
  res@cnLineLabelsOn = False ; no label on lines
  res@cnFillPalette = "precip_11lev"
  res@mpDataSetName = "Earth..4"
  res@mpDataBaseVersion = "MediumRes"
  res@mpOutlineBoundarySets = "National"
  res@mpOutlineSpecifiers = (/"Brazil:states"/)
  
  
  res@tiMainString      = "Plot NCL"    ; add a main title

  plot = gsn_csm_contour_map(wks,precip,res)

end 
