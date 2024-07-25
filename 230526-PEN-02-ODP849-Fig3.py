# %%markdown
#
## May 30, 2023: PaleoENSO Plot
# *Program to plot histogram % explanations & Q-Q plots of two CP sites for LGM-Holocene *
#
# ----
# Written by: Kaustubh Thirumalai, University of Arizona | [Github](https://github.com/planktic)
#
# Written on: May 30, 2023 | Updated: April 14, 2024
# ----
### Notes
# Modified from 01-CP_Sites_Plots
# Updated April 14, 2024: To focus on 21 ka for Ford

# %% Import Modules
# Load up what is needed
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import numpy as np

# %% Import Data
# Retireve model output and observational data from the appropriate files
from scipy.io import loadmat
cesm = loadmat('/Users/kaustubh/Documents/MATLAB/Scripts/Projects/02-PaleoENSO/CESM1.2_LGM+MH+PI_timeslices_indices_sites_data.V11.mat', squeeze_me=True)

# Alternative IFA Data File: 
# dataset = loadmat('/Users/kaustubh/Documents/MATLAB/Scripts/Projects/02-PaleoENSO/20230521-PaleoENSO_Data.mat', squeeze_me=True)
# cp_data_lh = dataset['EEP_849_LH'][:,1]
# cp_data_lgm = dataset['EEP_849_LGM'][:,1]

# Retireve IFA data from freshly retrieved (May 30, 2023) data taken from NCDC/NOAA .txt file

from openpyxl import load_workbook
workbook = load_workbook('/Users/kaustubh/Documents/Python/PyProjects/01-PaleoENSO/230530-IFA_849_Surface.xlsx')
sheet = workbook.active
data_range = sheet['B2':'B59']
cp_data_lh = np.array([[cell.value for cell in row] for row in data_range])
data_range2 = sheet['B60':'B121']
cp_data_lgm = np.array([[cell.value for cell in row] for row in data_range2])

sites_data = cesm['sites_data']
sites_data.shape

cp_pi_t = sites_data[0]['site'][0]['to50']
cp_lgm_t = sites_data[4]['site'][0]['to50']

cp_pi = cp_pi_t
cp_lgm = cp_lgm_t

# %% Foram Picking Cell
# Calculate standard deviations from picked populations across PI, PI-2, and LGM

num = cp_data_lh.size
mc = 10000

# Preindustrial
ifa_pi = np.random.choice(cp_pi,size=(num,mc))
SD_pi = np.std(ifa_pi,axis=0)
 
# Random sampling of second Preindustrial timeseries for comparison
ifa_pi_2 = np.random.choice(cp_pi,size=(num,mc))
SD_pi_2 = np.std(ifa_pi_2,axis=0)

# LGM
ifa_lgm = np.random.choice(cp_lgm,size=(num,mc))
SD_lgm = np.std(ifa_lgm,axis=0)

# %% Calculate Anomalies of TimeSeries
# Use new Python way to do so via (reshaped) expanded annual cycle timeseries

# Another way to calculate annual cycle in Python
# cp_pi_clim = np.array([])
# cp_lgm_clim = np.array([])
# for month in range(0,12):
# 	cp_pi_clim = np.append(cp_pi_clim, np.mean(cp_pi[month::12]))
# 	cp_lgm_clim = np.append(cp_lgm_clim, np.mean(cp_lgm[month::12]))

# Preindustrial
years_pi = cp_pi.size // 12
cp_pi_reshaped = np.reshape(cp_pi, (years_pi, 12))
cp_pi_clim = np.mean(cp_pi_reshaped, axis=0)
cp_pi_clim_expanded = np.tile(cp_pi_clim, years_pi)
cp_pi_anom = cp_pi - cp_pi_clim_expanded

# LGM
years_lgm = cp_lgm.size // 12
cp_lgm_reshaped = np.reshape(cp_lgm, (years_lgm, 12))
cp_lgm_clim = np.mean(cp_lgm_reshaped, axis=0)
cp_lgm_clim_expanded = np.tile(cp_lgm_clim, years_lgm)
cp_lgm_anom = cp_lgm - cp_lgm_clim_expanded

# Calculate annual cycle anomalies
cp_pi_clim_anom = cp_pi_clim - np.mean(cp_pi_clim)
cp_lgm_clim_anom = cp_lgm_clim - np.mean(cp_lgm_clim)

# %% Alternate Timeseries Construction & Picking

# What we want: Preindustrial anomalies (unchanged interannual) with LGM annual cycle
# Equates to PI-ANOM + (LGM-AC - MEAN VALUE OF LGM-AC) + MEAN VALUE OF PI-AC
cp_alt_lgm_clim_expanded = np.tile(cp_lgm_clim, years_pi)
cp_alt = cp_pi_anom + (cp_alt_lgm_clim_expanded - np.mean(cp_alt_lgm_clim_expanded)) + np.mean(cp_pi_clim)

# Picking
ifa_alt = np.random.choice(cp_alt,size=(num,mc))
SD_alt = np.std(ifa_alt,axis=0)

# %% Histogram Plot
# Subplot (a)

ALT = (SD_alt-SD_pi)/SD_pi*100
PI2 = (SD_pi_2-SD_pi)/SD_pi*100
LGM = (SD_lgm-SD_pi)/SD_pi*100

df = pd.DataFrame({'PI2': PI2, 'ALT': ALT,'LGM': LGM})
labels = {'PI2','ALT','LGM'}

sns.set(style='darkgrid',palette="colorblind",font='Helvetica Neue',font_scale=1)
[fig,ax] = plt.subplots(1,1,figsize=(6,5))
sns.histplot(
   data=df, fill=True, palette="viridis",
   alpha=.5, linewidth=0,kde=True)
K = - (np.std(cp_data_lh) - np.std(cp_data_lgm)) / np.std(cp_data_lh) * 100

plt.bar(K,520,width=2,color='xkcd:Salmon')
plt.title('CESM1.2: Site ODP 849')
plt.xlabel('Change in variability detected by IFA (%)')
plt.ylabel('Frequency')
plt.legend(labels)
plt.tight_layout()

#---- Save figure ----#
plt.savefig('20240414-PEN-Fig-a-849-Hist.pdf', format='pdf', bbox_inches='tight')

plt.show()
# %% Quantile-Quantile Plot
# Subplot (b)

import scipy.stats as stats

q_pi = np.quantile(ifa_pi-np.mean(ifa_pi),np.linspace(0,1,num//2),axis=0)
q_alt = np.quantile(ifa_alt-np.mean(ifa_alt),np.linspace(0,1,num//2),axis=0)
q_lgm = np.quantile(ifa_lgm-np.mean(ifa_lgm),np.linspace(0,1,num//2),axis=0)
q_pi = np.where(q_pi > 7, np.nan, q_pi)
q_pi = np.where(q_pi < -5, np.nan, q_pi)

sns.set(style='darkgrid',palette='muted',font='Helvetica',font_scale=1)
[fig2,ax] = plt.subplots(1,1,figsize=(6,5))

# Plot Q-Q Envelope
ax.fill_between(np.median(q_pi,axis=1), np.percentile(q_lgm,11,axis=1), np.percentile(q_lgm,86,axis=1), 
                alpha=0.4,color='xkcd:sea blue',label='PI vs Full LGM ENSO')
ax.fill_between(np.median(q_pi,axis=1), np.percentile(q_alt,14,axis=1), np.percentile(q_alt,84,axis=1), 
                alpha=0.4,color='xkcd:Goldenrod',label='PI vs PI-Anom+LGM-AnnCyc')

a=4 # For dashed line
ax.plot([-a, a], [-a, a],':',color='xkcd:dark grey')

# Plot IFA data

q_cp_lh = np.quantile(cp_data_lh-np.mean(cp_data_lh),np.linspace(0,1,20),axis=0)
q_cp_lgm = np.quantile(cp_data_lgm-np.mean(cp_data_lgm),np.linspace(0,1,20),axis=0)

slope, intercept, r_value, p_value, std_err = stats.linregress(np.squeeze(q_cp_lh),np.squeeze(q_cp_lgm))
jj = np.arange(-a,a,a/10)*slope + intercept
ax.plot(np.arange(-a,a,a/10),jj,'-.',color='xkcd:bright red')

ax.plot(q_cp_lh,q_cp_lgm,marker='o',
        markersize=8,linewidth=0,
        markerfacecolor='xkcd:Salmon',markeredgecolor='xkcd:White',label='IFA @ ODP849')

# Graph Specifications
plt.xlabel('Late Holocene IFA-SST')
plt.ylabel('LGM IFA-SST')
plt.grid(linestyle='--')
plt.yticks(np.arange(-a,a+0.1*a,1))
plt.xticks(np.arange(-a,a+0.1*a,1))
plt.legend()

#---- Save figure ----#
fig2.savefig('20240414-PEN-Fig-b-849-QQ.pdf')

plt.show()

# %% Histogram plot

d = dict(LH=np.squeeze(cp_data_lh-np.median(cp_data_lh)),LGM=np.squeeze(cp_data_lgm-np.median(cp_data_lgm)))
df2 = pd.DataFrame(dict([ (k,pd.Series(v)) for k,v in d.items()]))
# df2 = pd.DataFrame({'LH': np.squeeze(cp_data_lh-np.median(cp_data_lh)),'LGM': np.squeeze(cp_data_lgm-np.median(cp_data_lgm))})
labels = {'LH','LGM'}

sns.set(style='darkgrid',palette="colorblind",font='Helvetica Neue',font_scale=1)
[fig,ax] = plt.subplots(1,1,figsize=(6,5))
sns.histplot(
   data=df2, fill=True, palette="RdBu",
   alpha=.5, linewidth=0,kde=True,bins=np.arange(-3,4.5,0.5),legend=True)

# K = - (np.std(cp_data_lh) - np.std(cp_data_lgm)) / np.std(cp_data_lh) * 100
# plt.bar(K,550,width=2,color='xkcd:Salmon')
plt.title('CESM1.2: Central Pacific')
plt.xlabel('Change in variability detected by IFA (%)')
plt.ylabel('Frequency')
# ax.set_xticks(np.arange(-1,1,0.2))
# ax.set_xlim([1,-1])
# plt.legend(df2)
plt.tight_layout()

#---- Save figure ----#
plt.savefig('20240414-PEN-849_Data_Hist.pdf', format='pdf', bbox_inches='tight')

plt.show()

# %% 

sns.set(style = "darkgrid",font_scale=1.4,font="DIN Alternate",palette='muted')
FS = (4,7)
[fig,axx] = plt.subplots(1, 1, figsize= FS)
axx.subplots = sns.boxplot(data=df2,showfliers=False,palette="bwr_r")
axx.subplots = sns.swarmplot(data=df2,color=".25")
# axx.set_ylim([-5,5])
# axx.invert_yaxis()
plt.savefig('20240414-PEN-849_Data_Swarm.pdf', format='pdf', bbox_inches='tight')
plt.show()