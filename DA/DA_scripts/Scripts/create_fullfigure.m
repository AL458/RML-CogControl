function create_fullfigure(xvals,fulldata)


subplot(2,3,1)
yvals = fulldata.dACCmean;
std = fulldata.dACCstd;
errorbar(xvals,yvals,std,'LineWidth',4);
xlim([-5.25 5.25])
ylabel('Activity (z-scored)');
xlabel('value diff.');
title('dACC activity');

% box(axes1,'on');
% set(axes1,'FontSize',16,'FontWeight','bold','XTick',linspace(-5,5,11));

subplot(2,3,2)
yvals = fulldata.Vmean;
std = fulldata.Vstd;
errorbar(xvals,yvals,std,'LineWidth',4);
xlim([-5.25 5.25])
ylabel('Activity (z-scored)');
xlabel('value diff.');
title('Mean value');

subplot(2,3,3)
yvals = fulldata.boostmean;
std = fulldata.booststd;
errorbar(xvals,yvals,std,'LineWidth',4);
xlim([-5.25 5.25])
ylabel('Activity (z-scored)');
xlabel('value diff.');
title('Mean boost');

subplot(2,3,4)
yvals = fulldata.accuracymean;
std = fulldata.accuracystd;
errorbar(xvals,yvals,std,'LineWidth',4);
xlim([-5.25 5.25])
ylabel('Accuracy');
xlabel('value diff.');
title('Accuracy');

subplot(2,3,5)
yvals = fulldata.RTmean;
std = fulldata.RTstd;
errorbar(xvals,yvals,std,'LineWidth',4);
xlim([-5.25 5.25])
ylabel('RT');
xlabel('value diff.');
title('Response times');

subplot(2,3,6)
yvals = fulldata.boosttruemean;
std = fulldata.boosttruestd;
errorbar(xvals,yvals,std,'LineWidth',4);
xlim([-5.25 5.25])
ylabel('Activity');
xlabel('value diff.');
title('Boost');
