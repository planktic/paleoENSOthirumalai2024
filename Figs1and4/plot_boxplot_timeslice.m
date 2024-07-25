function plot_boxplot_timeslice( timeslice_stats, var_name, kabp, boxRGB, invtimeaxis, plotHardEdges )

medianRGB = [ 1 1 1 ]*0;
medianRGB = [ 1 1 1 ]*.0;
whiskersRGB = medianRGB;
boxEdgeRGB = medianRGB;
whiskersRGB = .7*[1 1 1];
whiskersRGB = .5*[1 1 1];

if nargin == 5
	plotHardEdges = 1;
end
if ~plotHardEdges
	whiskersRGB = boxRGB(1,:);
end

if invtimeaxis
	boxRGB = flipud(boxRGB);
end

all_vals = [];
all_xvals = [];

if invtimeaxis
for mm = length(timeslice_stats) : -1 : 1

	vals = eval([ 'timeslice_stats(mm).' var_name ])';
	all_vals = [ all_vals; vals ];
	xvals_b = [];
	for ll = 1:length(vals)
		if invtimeaxis
			xvals_b{ll} = [ num2str(kabp(mm)) ];
		else
			xvals_b{ll} = [ num2str(kabp(mm)) ];
		end
	end
	all_xvals = [ all_xvals; xvals_b' ];
end
else
for mm = 1 : length(timeslice_stats)

	vals = eval([ 'timeslice_stats(mm).' var_name ])';
	all_vals = [ all_vals; vals ];
	xvals_b = [];
	for ll = 1:length(vals)
		if invtimeaxis
			xvals_b{ll} = [ num2str(kabp(mm)) ];
		else
			xvals_b{ll} = [ num2str(kabp(mm)) ];
		end
	end
	all_xvals = [ all_xvals; xvals_b' ];
end
end

%h = boxplot(all_vals,all_xvals,'symbol','','orientation', 'horizontal'); % won't display outliers
h = boxplot(all_vals,all_xvals,'symbol',''); % won't display outliers
%h = boxplot(all_vals,all_xvals,'symbol','','notch','on'); % won't display outliers

if strcmp(var_name,'linedelOper')
	plot(get(gca,'xLim'),[0 0],'k:','lineWidth',1)
end
if strcmp(var_name,'nino34a_sdev')
	kk = find( kabp == 0 );
	nino34sdev_0ka = nanmedian(timeslice_stats(kk).nino34a_sdev);
	if plotHardEdges
		plot(get(gca,'xLim'),nino34sdev_0ka*[1 1],'k:','lineWidth',1)
	end
end

set(h(1:4,:),'Color',whiskersRGB,'LineStyle','-','LineWidth',1)

xDataAll = get(h(5,:),'XData');
yDataAll = get(h(5,:),'YData');

hold on

for ll = 1 : length(xDataAll)
	xData = xDataAll{ll};
	yData = yDataAll{ll};
	if plotHardEdges
		boxEdgeRGB_b = boxEdgeRGB;
	else
		boxEdgeRGB_b = boxRGB(ll,:);
	end
	rectangle('Position',[ xData(1) yData(1) diff(xData(2:3)) diff(yData(1:2))],'faceColor',boxRGB(ll,:),'lineWidth',1,'EdgeColor',boxEdgeRGB_b);
	%rectangle('Position',[ xData(1) yData(1) diff(xData(1:2)) diff(yData(2:3))],'faceColor',boxRGB(ll,:),'lineWidth',1,'EdgeColor',boxEdgeRGB);
end

xDataAll = get(h(6,:),'XData');
yDataAll = get(h(6,:),'YData');

for ll = 1 : length(xDataAll)
	xData = xDataAll{ll};
	yData = yDataAll{ll};
	if plotHardEdges
		plot(xData,yData,'color',medianRGB,'LineWidth',1)
	end
end

kabp_labels = [];
if invtimeaxis
	kabp = fliplr(kabp);
end
for ll = 1 : length(kabp)
	kabp_labels{ll} = num2str(kabp(ll));
	if kabp(ll) == -1
		kabp_labels{ll} = '2XCO2';
	end
	if kabp(ll) == -2
		kabp_labels{ll} = '2XCO4';
	end
end

set(gca,'xTickLabels',kabp_labels)

