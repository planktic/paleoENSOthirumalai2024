# %%markdown
#
## Maps for PyPaleoENSO
# *Program to plot a map of surface and sub-surface extremes *
#
# ----
# Written by: Kaustubh Thirumalai, University of Arizona | [Github](https://github.com/planktic)
#
# Written on: April 14, 2024 | Updated: 
# ----
### Notes
#
# %%

import matplotlib.pyplot as plt
import cartopy.crs as ccrs
import matplotlib as mpl
import scipy.io as spio
import seaborn as sns
import pandas as pd
import xarray as xr
import numpy as np
import sys

# %%--------------------------------#
#-----Load Model Data from CESM-----#
#-----------------------------------#

from scipy.io import loadmat
cesm = loadmat('/Users/kaustubh/Documents/MATLAB/Scripts/Projects/02-PaleoENSO/CESM1.2_LGM+MH+PI_timeslices_indices_sites_data.V11.mat', struct_as_record=False,squeeze_me=True)

lon = cesm['ocngr_lon']
lat = cesm['ocngr_lat']

# tos_0ka = np.squeeze(cesm['tos_sdev'][0,:,:])
# tos_18ka = np.squeeze(cesm['tos_sdev'][3,:,:]) 
# tosub_0ka = np.squeeze(cesm['to40_sdev'][0,:,:])
# tosub_18ka = np.squeeze(cesm['to40_sdev'][3,:,:])

# tos_0ka_anom = np.squeeze(cesm['tos_anom_sdev'][0,:,:])
# tos_18ka_anom = np.squeeze(cesm['tos_anom_sdev'][3,:,:])
# tosub_0ka_anom = np.squeeze(cesm['to100_anom_sdev'][0,:,:])
# tosub_18ka_anom = np.squeeze(cesm['to100_anom_sdev'][3,:,:])

tos_0ka = (np.squeeze(cesm['to40_sdev'][0,:,:])+np.squeeze(cesm['to70_sdev'][0,:,:])+np.squeeze(cesm['to90_sdev'][0,:,:]))/3
tos_18ka = (np.squeeze(cesm['to40_sdev'][4,:,:])+np.squeeze(cesm['to70_sdev'][4,:,:])+np.squeeze(cesm['to90_sdev'][4,:,:]))/3
# tosub_0ka = (np.squeeze(cesm['to70_sdev'][0,:,:]) + np.squeeze(cesm['to100_sdev'][0,:,:]) + np.squeeze(cesm['to150_sdev'][0,:,:]))/3
# tosub_18ka = (np.squeeze(cesm['to70_sdev'][3,:,:]) + np.squeeze(cesm['to100_sdev'][3,:,:]) + np.squeeze(cesm['to150_sdev'][3,:,:]))/3

tos_0ka_anom = (np.squeeze(cesm['to40_anom_sdev'][0,:,:])+np.squeeze(cesm['to70_anom_sdev'][0,:,:])+np.squeeze(cesm['to90_anom_sdev'][0,:,:]))/3
tos_18ka_anom = (np.squeeze(cesm['to40_anom_sdev'][4,:,:])+np.squeeze(cesm['to70_anom_sdev'][4,:,:])+np.squeeze(cesm['to90_anom_sdev'][4,:,:]))/3
# tosub_0ka_anom = (np.squeeze(cesm['to70_anom_sdev'][0,:,:]) + np.squeeze(cesm['to100_anom_sdev'][0,:,:]) + np.squeeze(cesm['to150_anom_sdev'][0,:,:]))/3
# tosub_18ka_anom = (np.squeeze(cesm['to70_anom_sdev'][3,:,:]) + np.squeeze(cesm['to100_anom_sdev'][3,:,:]) + np.squeeze(cesm['to150_anom_sdev'][3,:,:]))/3

Gunte = tos_18ka - tos_0ka
# Gunte_sub = tosub_18ka - tosub_0ka

Int_change = (tos_18ka_anom - tos_0ka_anom)/tos_0ka_anom*100
Ful_change = (tos_18ka - tos_0ka)/tos_0ka*100

# Int_change_sub = (tosub_18ka_anom - tosub_0ka_anom)/tosub_0ka_anom*100
# Ful_change_sub = (tosub_18ka - tosub_0ka)/tosub_0ka*100

# %%----------------------------------------#
#-----Disentangle Variance at each Site-----#
#-------------------------------------------#

IC = (Int_change <= 0)
FC = (Ful_change >= 0)

# Make a matrix whose elements are 0 if both are True, 1 if neither True, else 2.
K = np.vectorize( lambda a,b: 1.0 if a and b else 0.0)(IC,FC)
K[K==0] = np.nan

# IC_sub = (Int_change_sub <= 0)
# FC_sub = (Ful_change_sub >= 0)

# Make a matrix whose elements are 0 if both are True, 1 if neither True, else 2.
# K_sub = np.vectorize( lambda a,b: 1.0 if a and b else 0.0)(IC_sub,FC_sub)
# K_sub[K_sub==0] = np.nan

# %%
# ============================= #
# ========== Plot ============= #
# ============================= #

from matplotlib import gridspec
sns.set(style='white',palette='muted',font='Helvetica',font_scale=1.5)
fig1a = plt.figure(constrained_layout=False,figsize=(10,10))
spec2 = gridspec.GridSpec(ncols=1, nrows=1, figure=fig1a)

#------------------------------------#
#---- Figure 1a: Surface-Ocean ENSO -#
#------------------------------------#

#---- Projection ----#

# sns.set(style='darkgrid',palette='muted',font='SF Compact Display',font_scale=1.5)

ax1 = fig1a.add_subplot(spec2[0,0], projection=ccrs.Mercator(central_longitude=200))
ax1.set_extent([135,285,-12,12],crs=ccrs.PlateCarree())
sv = 0.45 # Shrink value for colorbars

#---- Colormap ----#
import matplotlib as mpl
# cmap1 = mpl.colors.LinearSegmentedColormap.from_list("", ["xkcd:ocean blue","xkcd:blue","xkcd:sky blue","xkcd:white","xkcd:sandy","xkcd:light red","xkcd:burgundy"],N=128)
# cmap1 = cmap1.reversed()
# cmap1 = mpl.cm.get_cmap('bwr')
cmap1 = mpl.colormaps['RdBu_r']
# cmap1.set_bad(color='xkcd:dark gray')

#---- Plot SST ----#
im1 = ax1.contourf(lon,lat,Gunte,np.arange(-0.6,0.7,0.01),transform=ccrs.PlateCarree(),cmap=cmap1,extend='both',corner_mask=True,zorder=1)
im2 = ax1.contourf(lon,lat,K,transform=ccrs.PlateCarree(),hatches=['....'],cmap='Greys',alpha=0.1,linewidth=0.5)
mpl.rcParams['hatch.linewidth'] = 0.8

#---- Colorbar: Precipitation ----#
cbar1 = plt.colorbar(im1,ax=[ax1],location='bottom',shrink=sv,pad=0.08)
cbar1.set_label('SST Variance',size=15)
# cbar1.set_ticks(np.arange(-1,1.3,0.5))
cbar1.set_ticks(np.arange(-0.6,0.7,0.2))
# cbar1.ax.tick_params(labelsize=13)

#---- Land & Boundaries ----#
from cartopy.io.shapereader import Reader
from cartopy import feature as cfeature
fname = '/Users/kaustubh/Documents/Python/Datasets/Maps/ne_50m_land/ne_50m_land.shp'
ax1.add_geometries(Reader(fname).geometries(),
                  ccrs.PlateCarree(),
                  edgecolor='xkcd:black',linewidth=1.5,facecolor='xkcd:black',zorder=3)

#---- Gridlines ----#
from cartopy.mpl.gridliner import LONGITUDE_FORMATTER, LATITUDE_FORMATTER
gl1 = ax1.gridlines(crs=ccrs.PlateCarree(central_longitude=180), draw_labels=False,linewidth=1.5, color='xkcd:gray', alpha=0.5, linestyle=':')
gl1.top_labels = False
gl1.bottom_labels = True
gl1.left_labels = True
gl1.right_labels = False
# gl1.xlocator = mpl.ticker.FixedLocator(np.arange(100,720,10))
gl1.xlocator = mpl.ticker.FixedLocator(np.arange(-100,100,20))
# gl1.xlocator = mpl.ticker.FixedLocator(np.arange(300,300,10))
gl1.ylocator = mpl.ticker.FixedLocator(np.arange(-10,35.5,5))
gl1.xformatter = LONGITUDE_FORMATTER    # Gives the degree sign
gl1.yformatter = LATITUDE_FORMATTER
gl1.xlabel_style = {'size': 14}
gl1.ylabel_style = {'size': 14}

Sites = np.array([[159,0],[-110,0],[-89.68,-1.21],[-84,8],[-90,-1.5],[-157.26,1.27]])
ax1.plot(Sites[:,0],Sites[:,1],'o',transform=ccrs.PlateCarree(),color='xkcd:bright yellow',mec='black',linewidth=3,ms=5) # Plot Box Outline

#---- Save figure ----#
mpl.rcParams['pdf.fonttype'] = 42
fig1a.savefig('/Users/kaustubh/Documents/Python/Projects/PyPaleoENSO/New_Map_SubMidSurface.pdf')


# # %%
# # ============================= #
# # ======SubSurface=Plot======== #
# # ============================= #

# fig1b = plt.figure(constrained_layout=False,figsize=(10,10))
# spec2b = gridspec.GridSpec(ncols=1, nrows=1, figure=fig1b)

# #------------------------------------#
# #---- Figure 1a: Surface-Ocean ENSO -#
# #------------------------------------#

# #---- Projection ----#

# # sns.set(style='darkgrid',palette='muted',font='SF Compact Display',font_scale=1.5)

# ax2 = fig1b.add_subplot(spec2b[0,0], projection=ccrs.Mollweide(central_longitude=180))
# ax2.set_extent([115,290,-10,20],crs=ccrs.PlateCarree())

# #---- Colormap ----#
# import matplotlib as mpl
# # cmap1 = mpl.colors.LinearSegmentedColormap.from_list("", ["xkcd:ocean blue","xkcd:blue","xkcd:sky blue","xkcd:white","xkcd:sandy","xkcd:light red","xkcd:burgundy"],N=128)
# # cmap1 = cmap1.reversed()
# cmap1 = mpl.cm.get_cmap('coolwarm')
# # cmap1.set_bad(color='xkcd:dark gray')

# #---- Plot Sub-T ----#
# im3 = ax2.contourf(lon,lat,Gunte_sub,np.arange(-1.1,1.1,0.05),transform=ccrs.PlateCarree(),cmap=cmap1,extend='both',corner_mask=True,zorder=1)
# im4 = ax2.contourf(lon,lat,K_sub,transform=ccrs.PlateCarree(),hatches=['//--'],cmap='Greys',alpha=0.1,linewidth=0.5)
# mpl.rcParams['hatch.linewidth'] = 0.8

# #---- Colorbar: Precipitation ----#
# cbar2 = plt.colorbar(im3,ax=[ax2],location='bottom',shrink=sv,pad=0.08)
# cbar2.set_label('Temperature Variability',size=15)
# cbar2.set_ticks(np.arange(-2,2.3,0.5))
# # cbar1.ax.tick_params(labelsize=13)

# #---- Land & Boundaries ----#

# ax2.add_geometries(Reader(fname).geometries(),
#                   ccrs.PlateCarree(),
#                   edgecolor='xkcd:black',linewidth=1.5,facecolor='xkcd:dark brown',zorder=3)

# #---- Gridlines ----#

# gl2 = ax2.gridlines(crs=ccrs.PlateCarree(central_longitude=180), draw_labels=False,linewidth=1.5, color='xkcd:gray', alpha=0.5, linestyle=':')
# gl2.top_labels = False
# gl2.left_labels = True
# gl2.right_labels = False
# # gl1.xlocator = mpl.ticker.FixedLocator(np.arange(100,720,10))
# gl2.xlocator = mpl.ticker.FixedLocator(np.arange(-100,100,20))
# # gl1.xlocator = mpl.ticker.FixedLocator(np.arange(300,300,10))
# gl2.ylocator = mpl.ticker.FixedLocator(np.arange(-10,35.5,5))
# gl2.xformatter = LONGITUDE_FORMATTER    # Gives the degree sign
# gl2.yformatter = LATITUDE_FORMATTER
# gl2.xlabel_style = {'size': 14}
# gl2.ylabel_style = {'size': 14}

# Sites = np.array([[159,0],[-84,8],[-90,-1.5]])
# ax2.plot(Sites[:,0],Sites[:,1],'o',transform=ccrs.PlateCarree(),color='xkcd:bright yellow',mec='black',linewidth=3,ms=5) # Plot Box Outline

# #---- Save figure ----#
# mpl.rcParams['pdf.fonttype'] = 42
# fig1b.savefig('/Users/kaustubh/Documents/Python/Projects/PyPaleoENSO/SubSurfaceMap.pdf')
# #

# %%
