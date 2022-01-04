#-----------------
# python tutorial
#-----------------

import numpy
import xarray as xr
import Ngl

#--- open NC file
dset = xr.open_dataset("/mnt/c/Users/Arthur/Documents/IC/3.2/gpcp_1981-2010.nc") 
print(dset)            # print metadata
print(dset['precip'])  # print variable precip

#--- read variable
lat = dset.lat.values
lon = dset.lon.values
var = dset.precip[0,:,:].values  # precip[time,lat,lon] select only the first time

#---- Plots
wks = Ngl.open_wks("png","tutorial") #figure name


res = Ngl.Resources()      # configuration for plots 

res.tiMainString = "titulo1"

res.cnLevelSelectionMode = "ManualLevels"
res.cnMinLevelValF = 0      # min value
res.cnMaxLevelValF = 12     # max value
res.cnLevelSpacingF = 1
res.cnFillOn = True        # shaded plot
res.cnLinesOn = False      # no lines
res.cnLineLabelsOn = False # no label on lines


res.sfXArray = lon  # necessary for 
res.sfYArray = lat  # lat-lon plots
res.cnFillPalette = "precip_11lev"
           



plot = Ngl.contour_map(wks, var, res) # type of plot (contour_map)

#---- Plot 2
wks = Ngl.open_wks("png","tutorial2") #figure name
res.tiMainString = "titulo2"
res.mpLimitMode = "LatLon"  # restrict plot
res.mpMinLatF = -60         # for South
res.mpMaxLatF = 15          # America
res.mpMinLonF = -90
res.mpMaxLonF = -30


plot = Ngl.contour_map(wks, var, res) # type of plot (contour_map)

Ngl.end()




