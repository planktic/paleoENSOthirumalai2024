%% Program to plot supplementary figure of depth profiles
%%

clear;
clc;

load('CESM1.2_LGM+MH+PI_timeslices_indices_sites_data.V11.mat')

%% Plot
% Mg/Ca Sites: ODP 806; ODP 849; CDP; MD-02; V21-30; MG
% LON = [60;151;170];
% LAT = [10;11;9];
% LON = [159;211;231;236;232;163];
% LAT = [27;25;24;34;24;25];
% 

LON = [162;121;211;231;230;236];
LAT = [27;26;26;24;24;17];
depth = [5;10;20;30;40;50;60;70;80;90;100;120;150;200];


%%

profiles = nan(14,4);
timeslice = 5;
for site = 1:6
    profiles(1,site) = (- squeeze(tos_sdev(timeslice,LAT(site),LON(site))) + squeeze(tos_sdev(1,LAT(site),LON(site))))./squeeze(tos_sdev(1,LAT(site),LON(site)))*100;
    profiles(2,site) = (- squeeze(to10_sdev(timeslice,LAT(site),LON(site))) + squeeze(to10_sdev(1,LAT(site),LON(site))))./squeeze(tos_sdev(1,LAT(site),LON(site)))*100;
    profiles(3,site) = (- squeeze(to20_sdev(timeslice,LAT(site),LON(site))) + squeeze(to20_sdev(1,LAT(site),LON(site))))./squeeze(tos_sdev(1,LAT(site),LON(site)))*100;
    profiles(4,site) = (- squeeze(to30_sdev(timeslice,LAT(site),LON(site))) + squeeze(to30_sdev(1,LAT(site),LON(site))))./squeeze(tos_sdev(1,LAT(site),LON(site)))*100;
    profiles(5,site) = (- squeeze(to40_sdev(timeslice,LAT(site),LON(site))) + squeeze(to40_sdev(1,LAT(site),LON(site))))./squeeze(tos_sdev(1,LAT(site),LON(site)))*100;
    profiles(6,site) = (- squeeze(to50_sdev(timeslice,LAT(site),LON(site))) + squeeze(to50_sdev(1,LAT(site),LON(site))))./squeeze(tos_sdev(1,LAT(site),LON(site)))*100;
    profiles(7,site) = (- squeeze(to60_sdev(timeslice,LAT(site),LON(site))) + squeeze(to60_sdev(1,LAT(site),LON(site))))./squeeze(tos_sdev(1,LAT(site),LON(site)))*100;
    profiles(8,site) = (- squeeze(to70_sdev(timeslice,LAT(site),LON(site))) + squeeze(to70_sdev(1,LAT(site),LON(site))))./squeeze(tos_sdev(1,LAT(site),LON(site)))*100;
    profiles(9,site) = (- squeeze(to80_sdev(timeslice,LAT(site),LON(site))) + squeeze(to80_sdev(1,LAT(site),LON(site))))./squeeze(tos_sdev(1,LAT(site),LON(site)))*100;
    profiles(10,site) =( - squeeze(to90_sdev(timeslice,LAT(site),LON(site))) + squeeze(to90_sdev(1,LAT(site),LON(site))))./squeeze(tos_sdev(1,LAT(site),LON(site)))*100;
    profiles(11,site) = (- squeeze(to100_sdev(timeslice,LAT(site),LON(site))) + squeeze(to100_sdev(1,LAT(site),LON(site))))./squeeze(tos_sdev(1,LAT(site),LON(site)))*100;
    profiles(12,site) = (- squeeze(to120_sdev(timeslice,LAT(site),LON(site))) + squeeze(to200_sdev(1,LAT(site),LON(site))))./squeeze(tos_sdev(1,LAT(site),LON(site)))*100;
    profiles(13,site) = (- squeeze(to150_sdev(timeslice,LAT(site),LON(site))) + squeeze(to150_sdev(1,LAT(site),LON(site))))./squeeze(tos_sdev(1,LAT(site),LON(site)))*100;
    profiles(14,site) = (- squeeze(to200_sdev(timeslice,LAT(site),LON(site))) + squeeze(to200_sdev(1,LAT(site),LON(site))))./squeeze(tos_sdev(1,LAT(site),LON(site)))*100;
end

profiles = profiles * -1;

% profiles_s = nan(4,4);
% for site = 1:4
%     profiles_s(1,site) = squeeze(sos_anom_sdev(timeslice,LAT(site),LON(site))) - squeeze(sos_anom_sdev(1,LAT(site),LON(site)));
%     profiles_s(2,site) = squeeze(so50_anom_sdev(timeslice,LAT(site),LON(site))) - squeeze(so50_anom_sdev(1,LAT(site),LON(site)));
%     profiles_s(3,site) = squeeze(so60_anom_sdev(timeslice,LAT(site),LON(site))) - squeeze(so60_anom_sdev(1,LAT(site),LON(site)));
%     profiles_s(4,site) = squeeze(so70_anom_sdev(timeslice,LAT(site),LON(site))) - squeeze(so70_anom_sdev(1,LAT(site),LON(site)));
% end


%% Plot Figure
sites = ["CEP","ODP806","ODP849","CD38-17P","V21-30","MD02-2529","Line of No Change"];
figure(1);clf;hold on;
% subplot(1,2,1);hold on;
plot(profiles,depth','-o');set(gca,'ydir','rev');legend(sites);hold on;
plot(ones(size(depth))*0,depth,'k--');
set(gca,'ylim',[0 200]);
legend(sites);
% subplot(1,2,2);hold on;
% plot(profiles_s,depth(1:4),'-o');set(gca,'ydir','rev');legend(sites);
% set(gca,'ylim',[0 80]);

% set(gcf, 'Position',  [100, 100, 200, 600])
print('-dpdf','-r400','-cmyk','Profiles');