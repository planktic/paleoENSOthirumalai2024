clear

load boxRGB.mat
boxRGB = boxRGB(:,:);

invtimeaxis = 1;
plotHardEdges = 1;

[ label_font_size, anot_font_size, font_weight ] = get_plot_font;

load Fig1_data.mat

plot_kabp_r = [ -1 21 ];

kabp = [timeslice_stats.kabp];

kk = find( kabp >= plot_kabp_r(1) & kabp <= plot_kabp_r(2) );

timeslice_stats = timeslice_stats(kk);
boxRGB = boxRGB(kk,:);
kabp = kabp(kk);

per_ext_nino = [timeslice_stats.n_2deg_nino_events]./[timeslice_stats.n_nino_events].*100;
leg = [];
for ll = 1 : length([timeslice_stats.kabp])
               
	leg{ll} = [ num2str(timeslice_stats(ll).kabp) ' ka' ];

        if timeslice_stats(ll).kabp == -1
                leg{ll} = '2XCO2';
	end
        if timeslice_stats(ll).kabp == -2
                leg{ll} = '4XCO2';
	end
end

figure(1); clf

subplot(2,1,1); hold on
plot_boxplot_timeslice( timeslice_stats, 'nino34a_sdev', [timeslice_stats.kabp], boxRGB, invtimeaxis, plotHardEdges );
set(gca,'fontSize',anot_font_size)
xlabel('interval \rm(ka BP)','fontSize',18,'fontWeight','bold')
%ylabel({'ENSO amplitude \rm(K)' '\rm\sigma(NDJ Nino-3.4 SST index)'},'fontSize',20,'fontWeight','bold')
ylabel({'ENSO amplitude \rm(K)' },'fontSize',20,'fontWeight','bold')
%ylabel({'ENSO amplitude \rm(K)'},'fontSize',20)
set(gca,'yTick',.4:.4:2)
yLim = [ .41 1.99 ];
set(gca,'yLim',yLim)
xLim = .5 + [ 0 length(timeslice_stats) ];
set(gca,'xLim',xLim)
set(gca,'lineWidth',2)
text(-.177,2.15,'A','fontSize',label_font_size+4,'fontWeight',font_weight)

subplot(2,2,3)

hold  on
plot([0 0],[0 1],'k:','lineWidth',1)
for ll = length(timeslice_stats) : -1 : 1
        h(ll) = plot(timeslice_stats(ll).nino34_sst_xaxis,timeslice_stats(ll).nino34_pdf,'color',boxRGB(ll,:),'lineWidth',3);
end
ll=9;
plot(timeslice_stats(ll).nino34_sst_xaxis,timeslice_stats(ll).nino34_pdf,'color',boxRGB(ll,:),'lineWidth',3);
ll=8;
plot(timeslice_stats(ll).nino34_sst_xaxis,timeslice_stats(ll).nino34_pdf,'color',boxRGB(ll,:),'lineWidth',3);
hleg = legend(h,leg,'Location','NorthEast');
set(hleg,'fontSize',11);

box on
set(gca,'lineWidth',2)
set(gca,'fontSize',anot_font_size)
set(gca,'yLim',[ 0 .6 ])
set(gca,'xLim',[ -1 1 ].*4.5)
set(gca,'xTick',-6:2:6)
xlabel({'{Nino-3.4 SST anomaly}' '\rm November to January'},'fontSize',label_font_size,'fontWeight',font_weight)
ylabel({'Frequency'},'fontSize',label_font_size,'fontWeight',font_weight)
set(gca, 'Layer', 'Top');
text(-5.98,.68,'B','fontSize',label_font_size+4,'fontWeight',font_weight)

subplot(2,2,4)

hold on
sdev=[];
for ll = length(timeslice_stats) : -1 : 1
	sdev(ll)=nanmedian(timeslice_stats(ll).nino34a_sdev);
        plot(per_ext_nino(ll),nanmedian(timeslice_stats(ll).nino34a_sdev),'markerFaceColor',boxRGB(ll,:),'marker','o','MarkerEdgeColor',.5*[1 1 1],...
        'markerSize',14);
end

kk2 = find(kabp>=-1);
r = corrcoef(per_ext_nino(kk2)',sdev(kk2)');
text(30,.8,sprintf('r = %0.2f',r),'fontSize',16,'fontWeight',font_weight);
text(-11.1,1.94,'C','fontSize',label_font_size+4,'fontWeight',font_weight)

box on
set(gca,'lineWidth',2)
set(gca,'fontSize',anot_font_size)
set(gca,'yLim',[ .6 1.8 ])
set(gca,'xLim',[ -2 52])
set(gca,'xTick',0:10:50)
set(gca,'yTick',.8:.4:1.6)
%ylabel({'ENSO amplitude \rm(K)' '\rm\sigma(NDJ Nino-3.4 SST index)'},'fontSize',label_font_size,'fontWeight',font_weight)
ylabel({'ENSO amplitude \rm(K)'},'fontSize',label_font_size,'fontWeight',font_weight)
xlabel('% of extreme El Nino','fontSize',label_font_size,'fontWeight',font_weight)

set(gca, 'Layer', 'Top');

set(gcf,'Position',[ 190 80 870 720 ])

oldunits = get(gcf,'Units');
set(gcf, 'PaperUnits', 'centimeters', 'Units', 'centimeters');
figpos = get(gcf, 'Position');
set(gcf, 'PaperSize', figpos(3:4), 'Units', oldunits);
print(gcf, '-dpdf', [get_fig_dir '/FIGURE1.pdf'],'-bestfit');
%export_fig('FIGURE1.pdf','-rgb','-transparent')

