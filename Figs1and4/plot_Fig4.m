clear

load Fig4_data.mat
load Fig1_data.mat
load boxRGB.mat
boxRGB = boxRGB(1:10,:);
%boxRGB = [ boxRGB(end,:); boxRGB(1:end-1,:) ];

per_ext_nino = [timeslice_stats.n_2deg_nino_events]./[timeslice_stats.n_nino_events].*100;

[ label_font_size, anot_font_size, font_weight ] = get_plot_font;

figure(1); clf

kabp = [ timeslice_stats.kabp ];
leg = [];
for ll = 1 : length(kabp)
	switch kabp(ll)
		case -1
			leg{ll} = '4XCO2';
		case -1
			leg{ll} = '2XCO2';
		otherwise
			leg{ll} = [ num2str(kabp(ll)) ' ka' ];
	end
end

ax1 = subplot(3,2,1);
ax1pos = get(ax1,'Position');
ax1pos = [ ax1pos(1:2) ax1pos(3) ax1pos(4).*1.2 ];
set(ax1,'Position',ax1pos)
xLim = [6 10.1];
yLim = [-.09 .49];
yLim = [-.09 .49];
bj_lim = [-.09 .39];
h = rectangle('Position',[ xLim(1) bj_lim(1) diff(xLim) diff(bj_lim) ],'faceColor',.9*[1 1 1],'edgeColor',.9*[1 1 1]);
xLim = [1.5 12.5];

plot(xLim,[0 0],'k:','lineWidth',1)

bj_all_c = bj_all;
bj_all_c = bj_all_b;
bj_all_plot = [ bj_all_c(end-1,:); bj_all_c(end,:); bj_all_c ];

hold on
h_leg = [];
for mm = 1 : size(bj_all_plot,2)
	h = plot(.5:13.5,bj_all_plot(:,mm),'color',boxRGB(mm,:),'lineWidth',3);
	h_leg = [ h_leg h ];
end
set(gca,'xLim',xLim)
text(-1.9,.431,'A','fontSize',label_font_size+4,'fontWeight',font_weight)

%monTick = [ 2 6 10 ];
%monTickLabel = { 'FMAM' 'JJAS' 'ONDJ' };
monTick = 1.5 : 1 : 12.5;
monTickLabel = { 'J' 'F' 'M' 'A' 'M' 'J' 'J' 'A' 'S' 'O' 'N' 'D' };

set(gca,'xTick',monTick)
set(gca,'xTickLabel',monTickLabel)

ll = find( kabp == -1 );
text(5.05,.35,'2XCO2','color',boxRGB(ll,:),'fontSize',14,'FontWeight',font_weight)
ll = find( kabp == 0 );
text(7.65,.25,'PI','color',boxRGB(ll,:),'fontSize',14,'FontWeight',font_weight)
ll = find( kabp == 21 );
text(10.37,.18,'LGM','color',boxRGB(ll,:),'fontSize',14,'FontWeight',font_weight)

box on
set(gca,'lineWidth',2)
set(gca,'fontSize',anot_font_size)
set(gca,'yLim',bj_lim)
set(gca,'yTick',0:.1:.5)
ylabel({'Bjerknes feedback strength' '\rm (month^{-1})'},'fontSize',label_font_size,'fontWeight',font_weight)
xlabel({'month'},'fontSize',label_font_size,'fontWeight',font_weight)
set(gca, 'Layer', 'Top');
%legend(h_leg,leg,'location','northeastoutside','fontSize',14)

ax2 = subplot(3,2,2);
ax2pos = get(ax2,'Position');
ax2pos = [ ax2pos(1:2) ax2pos(3) ax2pos(4).*1.2 ];
set(ax2,'Position',ax2pos)
hold on
h_leg = [];
h = plot(bj_nino(ll),timeslice_stats(ll).T_nino,'markerFaceColor',.5*[1 1 1],'marker','o','MarkerEdgeColor',.5*[1 1 1],'markerSize',14);
h_leg = [ h_leg h ];
for ll = 1 : length(per_ext_nino)
	%plot(bj_nino(ll),per_ext_nino(ll),'markerFaceColor',boxRGB(ll,:),'marker','o','MarkerEdgeColor',.5*[1 1 1],...
	%plot(bj_nino(ll),nanmedian(timeslice_stats(ll).nino34a_sdev),'markerFaceColor',boxRGB(ll,:),'marker','o','MarkerEdgeColor',.5*[1 1 1],...
	plot(bj_nino(ll),timeslice_stats(ll).T_nino,'markerFaceColor',boxRGB(ll,:),'marker','o','MarkerEdgeColor',.5*[1 1 1],...
	'markerSize',14,'lineWidth',2);
end
box on
text(-.19,2.38,'B','fontSize',label_font_size+4,'fontWeight',font_weight)
r = corrcoef(bj_nino',per_ext_nino');
set(gca,'lineWidth',2)
set(gca,'fontSize',anot_font_size)
set(gca,'xLim',bj_lim)
set(gca,'xtick',-.5:.1:.5)
%set(gca,'yLim',[.61 2.19])
%set(gca,'yLim',[.85 2.65])
%set(gca,'yTick',.5:.5:2.5)
%set(gca,'yLim',[ -2 52])
%set(gca,'yTick',0:10:50)
set(gca,'yLim',[ .61 1.79])
set(gca,'yLim',[.7 2.3])
set(gca,'yTick',.5:.5:2)
ylabel({'El Nino amplitude \rm(K)' },'fontSize',label_font_size,'fontWeight','bold')
plot([0 0],get(gca,'yLim'),'k:','lineWidth',1)
text(.29,48,'2XCO2','color',boxRGB(1,:),'fontSize',18,'FontWeight',font_weight)
text(.26,34,'pre-industrial','color',boxRGB(2,:),'fontSize',16,'FontWeight',font_weight)
text(.11,13,'LGM','color',boxRGB(9,:),'fontSize',18,'FontWeight',font_weight)
xlabel({'Bjerknes feedback strength' '\rm Jun-Sep (month^{-1})'},'fontSize',label_font_size,'fontWeight',font_weight)
%hh = legend(h_leg,{'Growing phase (Jun-Sep)'},'fontSize',14);
%set(hh,'lineWidth',1)

plotHardEdges = 0;

[ label_font_size, anot_font_size, font_weight ] = get_plot_font;

boxGray = ones(size(boxRGB)).*.85;
boxGray = ones(size(boxRGB)).*.75;

invtimeaxis = 1;

kabp = [ timeslice_stats.kabp ];

ax3 = subplot(3,2,3); hold on
plot_boxplot_timeslice( timeslice_stats, 'nino34a_sdev', kabp, boxGray, invtimeaxis, plotHardEdges );
plot(get(gca,'xLim'),[ 1 1 ]*nanmedian(timeslice_stats(2).nino34a_sdev),'k:','lineWidth',1)
set(gca,'fontSize',anot_font_size)
xlabel('interval \rm(ka BP)','fontSize',label_font_size,'fontWeight','bold')
ylabel({'ENSO amplitude \rm(K)'},'fontSize',label_font_size,'fontWeight','bold')
set(gca, 'YAxisLocation', 'right')
set(gca,'yTick',.4:.4:2)
yLim = [ .41 1.99 ];
yLim = [ .45 1.85 ];
set(gca,'yLim',yLim)
set(gca,'lineWidth',1)
set(gca,'xTickLabel',{ '21' '18' '15' '12' '9' '6' '3' '0' '2XCO2' '4XCO2' })

axPos = get(gca,'Position');

text(-.68,2.1,'C','fontSize',label_font_size+4,'fontWeight',font_weight)

RGB_betau = [ 223 90 137 ]./255;
RGB_mu = [ 75 171 229 ]./255;
RGB_grad = [ 126 170 84 ]./255;
box off

kabp(1) = -3;
ax4 = axes('Position',axPos);
h = [];
h(1) = plot(-kabp,bj_nino,'color',0*[1 1 1],'lineWidth',3);
hold on
h(2) = plot(-kabp,bj_nino_grad,'color',RGB_grad','lineWidth',3);
h(3) = plot(-kabp,bj_nino_mu,'color',RGB_mu,'lineWidth',3);
h(4) = plot(-kabp,bj_nino_beta,'color',RGB_betau,'lineWidth',3);
set(ax4,'color','none')
get(ax3,'xLim')
set(ax4,'xLim',[ -22.5 4.5 ]);
set(ax4,'yLim',bj_lim)
ylabel({'Bjerknes feedback strength' '\rm(month^{-1})' },'fontSize',label_font_size,'fontWeight','bold');
set(gca,'fontSize',anot_font_size)
set(gca, 'YAxisLocation', 'left')
set(gca, 'xAxisLocation', 'top')
box off
set(gca,'lineWidth',1)
set(gca,'xTick',[])
leg=legend(h,'All couplings','Thermal (SST gradient)','Wind-SST','Mechanical','fontSize',10,'Location','NorthWest');
legPos = get(leg,'Position');
set(leg,'lineWidth',1,'EdgeColor',[1 1 1])
set(leg,'Position',legPos+[.55 -.18 0 0])

pos =[  0.1300    0.36    0.78    0.22]
set(ax3,'Position',pos)
set(ax4,'Position',pos)
set(ax3,'lineWidth',2)
set(ax4,'lineWidth',2)

ax5 = subplot(3,2,5); hold on
ax5pos = get(ax5,'Position');

RGB_betau = [ 223 90 137 ]./255;
RGB_mu = [ 75 171 229 ]./255;
RGB_grad = [ 126 170 84 ]./255;
box off

kabp(1) = -3;
h = [];
ax5 = gca;
axPos = get(gca,'Position');
h(1) = plot(-kabp,-mld,'color',RGB_betau,'lineWidth',3);
ax6 = axes('Position',axPos);
h(2) = plot(-kabp,clim_wp_edge,'color',RGB_mu','lineWidth',3);
ax7 = axes('Position',axPos);
rgb_tauu = [0.9942    0.7583    0.4312];
h(3) = plot(-kabp,tauu*100,'color',rgb_tauu,'lineWidth',3);
set(ax5,'color','none')
set(ax6,'color','none')
set(ax7,'color','none')
set(ax5,'xLim',[ -22.5 4.5 ]);
set(ax7,'xLim',[ -22.5 4.5 ]);
set(ax7,'yLim',[ -6.5 -3 ]);
set(ax5,'yLim',[-105 -45])
set(ax6,'yLim',[150 200])
set(ax5,'yTick',-100:10:-50)
set(ax6,'yTick',160:10:200)
set(ax5,'yTickLabel',{ '100' '90' '80' '70' '60' '50' })
set(ax6,'yTickLabel',{ '160^oE' '170^oE' '180^o' '170^oW' '160^oW'})
ylabel(ax5,{'mixed layer depth' '\rm(m)' },'fontSize',label_font_size,'fontWeight','bold');
ylabel(ax6,{'warm pool eastern edge' },'fontSize',label_font_size,'fontWeight','bold');
set(ax5,'fontSize',anot_font_size)
set(ax6,'fontSize',anot_font_size)
set(ax7,'fontSize',anot_font_size)
set(ax5, 'YAxisLocation', 'left')
set(ax6, 'YAxisLocation', 'right')
set(ax7, 'YAxisLocation', 'right')
%set(gca, 'xAxisLocation', 'top')

text(-26,-2.7,'D','fontSize',label_font_size+4,'fontWeight',font_weight)

pos =[  0.1300    0.05    0.775    0.2]
set(ax5,'Position',pos)
set(ax7,'Position',pos)
set(ax5,'lineWidth',2)
set(ax6,'lineWidth',2)
set(ax7,'lineWidth',2)
pos =[  0.1300    0.05    0.775+.03    0.2]
set(ax6,'Position',pos)
set(ax6,'xLim',[ -22.5 5.5 ]);

leg=legend(h,'Mixed layer depth','Warm pool edge','Trade wind strength','fontSize',10,'Location','NorthWest');

set(leg,'lineWidth',1,'EdgeColor',[1 1 1])
set(ax5,'fontSize',anot_font_size)
set(ax6,'fontSize',anot_font_size)
set(ax7,'fontSize',anot_font_size)
xlabel('interval \rm(ka BP)','fontSize',label_font_size,'fontWeight','bold')
%ylabel({'ENSO amplitude \rm(K)'},'fontSize',label_font_size,'fontWeight','bold')
set(ax7, 'YAxisLocation', 'right')
set([ax5 ax6],'xTickLabel',[])
set([ax5 ax6],'xTick',[])
%set(gca,'yLim',yLim)
set(ax7,'xTick',-21:3:3)
set(ax7,'xTickLabel',{ '21' '18' '15' '12' '9' '6' '3' '0' '2XCO2' })
box(ax5,'off')
box(ax6,'off')
box(ax7,'off')

set(ax7,'lineWidth',2)
set(ax7,'yTick',-6:-3)
drawaxis(ax7, 'y', 4.5, 'movelabel', 1)
%ylabel(ax7,{'trade wind strees streght \rm(Pa)'},'fontSize',label_font_size,'fontWeight','bold')

set(gcf,'Position',[ 180 60 800 800 ])
exportgraphics(gcf,[ get_fig_dir '/FIGURE4.pdf'],'BackgroundColor','none','ContentType','vector')
