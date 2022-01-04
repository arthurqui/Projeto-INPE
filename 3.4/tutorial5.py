#-----------------
# python tutorial
# seasonal mean
# panel plots
#-----------------

import xarray as xr
import numpy as np
import Ngl

#--- open NC file
dset = xr.open_dataset("/mnt/c/Users/Arthur/Documents/IC/3.4/gpcp_1979-2019.nc")

#--- read variable
lat = dset.lat.values
lon = dset.lon.values
var = dset['precip'][24:383,:,:]  # precip[time,lat,lon] select Jan1981 to Dec2010

#--- Seasonal mean
sclim = var.groupby('time.season').mean('time')
print(sclim)

#---- Plots
wks = Ngl.open_wks("png","tutorial5") #figure name

res = Ngl.Resources()      # configuration for plots 

res.nglDraw = False      # dont draw plots yet
res.nglFrame = False     # dont create figures yet

res.lbLabelBarOn = False # dont draw individual label bars

res.cnFillOn = True        # shaded plot
res.cnLinesOn = False      # no lines
res.cnLineLabelsOn = False # no label on lines
res.cnFillPalette = "precip_11lev"
res.cnLevelSelectionMode = "ManualLevels"  # sel. levels
res.cnMinLevelValF = 0      # min value
res.cnMaxLevelValF = 12     # max value
res.cnLevelSpacingF = 1

res.sfXArray = lon  # necessary for 
res.sfYArray = lat  # lat-lon plots

res.mpGridAndLimbOn = False  #-- don't draw grid lines
res.mpLimitMode = "LatLon"   # restrict plot
res.mpMinLatF = -60          # for South
res.mpMaxLatF = 15           # America
res.mpMinLonF = -90
res.mpMaxLonF = -30

# In PyNGL, ~H10Q~ inserts 10 horizontal spaces before the text, and ~C~ causes a line feed.


#create the plots
plot = []

res.tiMainString = " ~C~ DJF precipitation (1981-2010)"#title
plot.append(Ngl.contour_map(wks, sclim.sel(season='DJF'), res)) # plot 1

res.tiMainString = " ~C~ MAM precipitation (1981-2010)"#title
plot.append(Ngl.contour_map(wks, sclim.sel(season='MAM'), res)) # plot 2

res.tiMainString = " ~C~ JJA precipitation (1981-2010)"#title
plot.append(Ngl.contour_map(wks, sclim.sel(season='JJA'), res)) # plot 3

res.tiMainString = " ~C~ SON precipitation (1981-2010)"#title
plot.append(Ngl.contour_map(wks, sclim.sel(season='SON'), res)) # plot 4

#--- Panel plots
panelres =  Ngl.Resources()          # Panel resources
panelres.nglPanelLabelBar =  True # add a common label bar
panelres.nglPanelTop =  0.95

#-- create the panel
Ngl.panel(wks,plot,[2,2],panelres)  # now draw plots

Ngl.end()




