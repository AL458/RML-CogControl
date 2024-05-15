function create_fullfigure(xvals,fulldata)

f = figure;
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
hold on
yvals_true = [0.909, 0.822, 0.730, 0.613, 0.491, 0.580, 0.711, 0.844, 0.873];
xvals_true = linspace(-4,4,9);
plot(xvals_true,yvals_true,'LineWidth',4)
legend('Simulated Acc','Real Acc')

subplot(2,3,5)
yvals = zscore(fulldata.RTmean);
std = fulldata.RTstd;
plot(xvals,yvals,'LineWidth',4);
xlim([-5.25 5.25])
ylabel('RT');
xlabel('value diff.');
title('Response times');
hold on
yvals_true = zscore([486.49,503.65,502.97,516.08,511.76,504.32,512.16,500.14,490.00]);
xvals_true = linspace(-4,4,9);
plot(xvals_true,yvals_true,'LineWidth',4)
legend('Simulated RT','Real RT')

subplot(2,3,6)
yvals = fulldata.boosttruemean;
std = fulldata.boosttruestd;
errorbar(xvals,yvals,std,'LineWidth',4);
xlim([-5.25 5.25])
ylabel('Activity');
xlabel('value diff.');
title('Boost');
saveas(f,'Output.png')

f = figure;
subplot(2,2,1)
yvals = fulldata.Vactmean;
std = fulldata.Vactstd;
errorbar(xvals,yvals,std,'LineWidth',4);
xlim([-5.25 5.25])
ylabel('Activity');
xlabel('value diff.');
title('V act');

subplot(2,2,2)
yvals = fulldata.Vboostmean;
std = fulldata.Vbooststd;
errorbar(xvals,yvals,std,'LineWidth',4);
xlim([-5.25 5.25])
ylabel('Activity');
xlabel('value diff.');
title('V Boost');

subplot(2,2,3)
yvals = fulldata.Vdiffactmean;
std = fulldata.Vdiffactstd;
errorbar(xvals,yvals,std,'LineWidth',4);
xlim([-5.25 5.25])
ylabel('Activity');
xlabel('value diff.');
title('V Act diff');

subplot(2,2,4)
yvals = fulldata.Vdiffboostmean;
std = fulldata.Vdiffbooststd;
errorbar(xvals,yvals,std,'LineWidth',4);
xlim([-5.25 5.25])
ylabel('Activity');
xlabel('value diff.');
title('V boost diff');
saveas(f,'Output_Vdiff.png')