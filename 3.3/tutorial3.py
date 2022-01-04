#-----------------
# python tutorial
# Annual mean
#-----------------

import xarray as xr
import numpy as np
import Ngl

#--- open NC file
#dset = xr.open_dataset("/mnt/c/data/reanalysis/prec/mon/gpcp_1979-2019.nc") 
dset = xr.open_dataset("/mnt/c/Users/Arthur/Documents/IC/3.3/gpcp_1979-2019.nc")

#--- read variable
lat = dset.lat.values
lon = dset.lon.values
var = dset['precip'][24:383,:,:].values  # precip[time,lat,lon] select Jan1981 to Dec2010

#--- Temporal mean
clim = np.mean(var,axis = 0)
print(clim)

#---- Plots
wks = Ngl.open_wks("png","tutorial3") #figure name

res = Ngl.Resources()      # configuration for plots 
res.cnFillOn = True        # shaded plot
res.cnLinesOn = False      # no lines
res.cnLineLabelsOn = False # no label on lines
res.cnFillPalette = "precip_11lev"
res.cnLevelSelectionMode = "ManualLevels"  # sel. levels
res.cnMinLevelValF = 0      # min value
res.cnMaxLevelValF = 10     # max value
res.cnLevelSpacingF = 1

res.sfXArray = lon  # necessary for 
res.sfYArray = lat  # lat-lon plots

res.mpLimitMode = "LatLon"  # restrict plot
res.mpMinLatF = -60         # for South
res.mpMaxLatF = 15          # America
res.mpMinLonF = -90
res.mpMaxLonF = -30

# In PyNGL, ~H10Q~ inserts 10 horizontal spaces before the text, and ~C~ causes a line feed.
res.tiMainString = "~H05Q~Annual climatology 1981-2010~C~Precipitation~H16Q~(mm/day)"# title

plot = Ngl.contour_map(wks, clim, res) # type of plot (contour_map)

Ngl.end()




