%% Code to plot up a four panel plot of model-data change for Pacific LGM
%
%% Load Data

clear;
clc;

load('CESM1.2_LGM+MH+PI_timeslices_indices_sites_data.V11.mat')
load('20230521-PaleoENSO_Data.mat')

%% Site 2: Eastern Central Pacific: Site 849

cp_pi_t = sites_data(1).site(1).to50;
cp_lgm_t = sites_data(5).site(1).to50;
cp_pi_s = sites_data(1).site(1).so50;
cp_lgm_s = sites_data(5).site(1).so50;

% cp_pi_sw = cp_pi_s.*0.27 - 8.88;
% cp_lgm_sw = cp_lgm_s.*0.27 - 8.88;

cp_pi = cp_pi_t;
cp_lgm = cp_lgm_t;

% L = -20;

%% Foram picking: Recall, there are four timeseries
% One is PI, one is second PI, one is LGM, one is LGMalt (Preanom)

num = 60;
mc = 1000;

% Preindustrial
ifa_ind_pi = ceil(rand(num,mc).*length(cp_pi));
ifa_pi = cp_pi(ifa_ind_pi);
SD_pi = std(ifa_pi,0,1);

ifa_ind_pi_2 = ceil(rand(num,mc).*length(cp_pi));
ifa_pi_2 = cp_pi(ifa_ind_pi_2);
SD_pi_2 = std(ifa_pi_2,0,1);

% LGM
ifa_ind_lgm = ceil(rand(num,mc).*length(cp_lgm));
ifa_lgm = cp_lgm(ifa_ind_lgm);
SD_lgm = std(ifa_lgm,0,1);

%% Altred TimeSeries: Swapping PI Annual Cycle with LGM Annual Cycle

cp_pi_clim = nan(12,1);
cp_lgm_clim = nan(12,1);

for month=1:12
	cp_pi_clim(month) = mean(cp_pi(month:12:end),'omitnan');
    cp_lgm_clim(month) = mean(cp_lgm(month:12:end),'omitnan');
end

% Removing Means from Seasonal Cycles
preSCA = cp_pi_clim - mean(cp_pi_clim,'omitnan');
lgmSCA = cp_lgm_clim - mean(cp_lgm_clim,'omitnan');

cp_pi_anom = nan(length(cp_pi),1);

for jj=1:length(cp_pi)
        if (mod(jj,12)==0)
            cp_pi_anom(jj) = cp_pi(jj) - cp_pi_clim(12);
        else
            cp_pi_anom(jj) = cp_pi(jj) - cp_pi_clim(mod(jj,12));
        end
end

% Construct LGM Anomalies with Preindustrial Seasonal Cycle    
preanom_ts = nan(length(cp_pi),1); % preanom_d18O is what we want: Preindustrial anomalies (unchanged interannual) with LGM seasonal cycle

for jj=1:length(cp_pi)
    if (mod(jj,12)==0)
        preanom_ts(jj) = cp_pi_anom(jj) + lgmSCA(12) + nanmean(cp_pi_clim);        
    else
        preanom_ts(jj) = cp_pi_anom(jj) + lgmSCA(mod(jj,12))  + nanmean(cp_pi_clim);
    end
end

%% Foram picking for new anomaly time series

ifa_ind_preanom = ceil(rand(num,mc).*length(preanom_ts));
ifa_preanom = preanom_ts(ifa_ind_preanom);
SD_preanom = std(ifa_preanom,0,1);

%% Histogram Plot

figure(11);clf;hold on;
h1 = histogram((SD_preanom-SD_pi)./SD_pi.*100,-60:2:60);
h2 = histogram((SD_lgm-SD_pi)./SD_pi*100,-60:2:60);
h3 = histogram((SD_pi_2-SD_pi)./SD_pi*100,-60:2:60);
legend(["Preanom","LGM_Full","PI_2"])

% L = -25; % Comes from data
% L = -round((std(CP_Costa_LH(:,2))-std(CP_Costa_LGM(:,2)))./std(CP_Costa_LH(:,2))*100);

L = -round((std(EEP_849_LH(:,2))-std(EEP_849_LGM(:,2)))./std(EEP_849_LH(:,2))*100);

tots_for_40 = h1.Values(h1.BinEdges==L)+h2.Values(h1.BinEdges==L)+h3.Values(h1.BinEdges==L);
prob_2 = h2.Values(h2.BinEdges==L)/tots_for_40 *100

%% Q-Q Plot

figure(21);
clf;
hold on;
numbs = round(num/2);
h = qqplot(ifa_pi-mean(ifa_pi,'omitnan'),ifa_lgm-mean(ifa_lgm,'omitnan'),linspace(1,100,numbs));
set(h,'linest','none','marker','none');

X = nan(mc,numbs);Y = nan(mc,numbs);
XL = nan(mc,2);YL = nan(mc,2);
XXL = nan(mc,2);YYL = nan(mc,2);
p = 1;

for jj=1:mc
    X(p,:) = h(jj).XData;
    Y(p,:) = h(jj).YData;
    XL(p,:) = h(jj+mc).XData;
    YL(p,:) = h(jj+mc).YData;
    XXL(p,:) = h(jj+mc+mc).XData;
    YYL(p,:) = h(jj+mc+mc).YData;
    p = p+1;
end

kk=linspace(-1.8,1.8,numbs);
dk = diff(kk);
ll = (kk(1)+dk(1)/2:dk(1):kk(end))';
MM = nan(length(kk)-1,1);HH = nan(length(kk)-1,1);LL = nan(length(kk)-1,1);
for jj=1:length(kk)-1
    LL(jj) = prctile(Y(X > kk(jj) & X < kk(jj+1)),2.5);
    HH(jj) = prctile(Y(X > kk(jj) & X < kk(jj+1)),97.5);
    MM(jj) = prctile(Y(X > kk(jj) & X < kk(jj+1)),50);
end
hold on;
hh = plot(ll,LL,'linewi',1,'linest','-','color','r');
plot(ll,HH,'linewi',1,'linest','-','color','r');
plot(-1.75:0.1:1.75,-1.75:0.1:1.75,'--');
dec = ([abs(MM-LL)';abs(HH-MM)'])';kr = 0;
[gb1,gb2] = boundedline(ll(1:end-kr),MM(1:end-kr),dec(1:end-kr,:),'-','alpha','transparency',0.1);
set(gb1,'color','r');
set(gb2,'Facecolor','r');

h2 = qqplot(ifa_pi-mean(ifa_pi,'omitnan'),ifa_preanom-mean(ifa_preanom,'omitnan'),linspace(1,100,numbs));
set(h2,'linest','none','marker','none');
X = nan(mc,numbs);Y = nan(mc,numbs);
XL = nan(mc,2);YL = nan(mc,2);
XXL = nan(mc,2);YYL = nan(mc,2);
p = 1;
for jj=1:mc
    X(p,:) = h2(jj).XData;
    Y(p,:) = h2(jj).YData;
    XL(p,:) = h2(jj+mc).XData;
    YL(p,:) = h2(jj+mc).YData;
    XXL(p,:) = h2(jj+mc+mc).XData;
    YYL(p,:) = h2(jj+mc+mc).YData;
    p = p+1;
end
kk=linspace(-1.8,1.8,numbs);
dk = diff(kk);
ll = (kk(1)+dk(1)/2:dk(1):kk(end))';
MM = nan(length(kk)-1,1);HH = nan(length(kk)-1,1);LL = nan(length(kk)-1,1);
for jj=1:length(kk)-1
    LL(jj) = prctile(Y(X > kk(jj) & X < kk(jj+1)),2.5);
    HH(jj) = prctile(Y(X > kk(jj) & X < kk(jj+1)),97.5);
    MM(jj) = prctile(Y(X > kk(jj) & X < kk(jj+1)),50);
end
hold on;
hh = plot(ll,LL,'linewi',1,'linest','-','color','g');
plot(ll,HH,'linewi',1,'linest','-','color','g');
plot(-1.75:0.1:1.75,-1.75:0.1:1.75,'k:');
dec = ([abs(MM-LL)';abs(HH-MM)'])';kr = 0;
[gb21,gb22] = boundedline(ll(1:end-kr),MM(1:end-kr),dec(1:end-kr,:),'-','alpha','transparency',0.1);
set(gb21,'color','g');
set(gb22,'Facecolor','g');

hm = qqplot(EEP_849_LH(:,2)-mean(EEP_849_LH(:,2)),EEP_849_LGM(:,2)-mean(EEP_849_LGM(:,2)),linspace(1,100,numbs));
    set(hm(2:3),'linewi',1.5,'linest','--');
    set(hm(1),'marker','o','markeredgecol','r','markerfacecol','r','color','r');

set(gca,'xlim',[-2 2]);
% set(gca,'xdir','rev');
set(gca,'ylim',[-2 2]);
% set(gca,'ydir','rev');
grid('on')

