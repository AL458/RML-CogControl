function create_fullfigure_AIC_poly(xvals,fulldata,AIC_struct)

figure
yvals = fulldata.dACCmean;
std = fulldata.dACCstd;
f = errorbar(xvals,yvals,std,'LineWidth',4,'Color', 'black');
xlim([-6 6])
%ylim([0.172,0.189])
ylabel('Activity (z-scored)');
xlabel('value diff.');
title('dACC activity');
saveas(f,'dACC_activity.png')

% Plot best fitting polynomial
poly_y = AIC_struct.stats_quartic.estimate;
hold on
plot(xvals,poly_y,'LineStyle','--','Color','blue','LineWidth',3)
poly = polyfit(xvals,poly_y,4);
save('estimated_poly.mat','poly')
saveas(f,'dACC_activity_withestimatedpoly.png')

% box(axes1,'on');
% set(axes1,'FontSize',16,'FontWeight','bold','XTick',linspace(-5,5,11));
figure;
yvals = fulldata.Vmean;
std = fulldata.Vstd;
f = errorbar(xvals,yvals,std,'LineWidth',4,'Color', 'black');
xlim([-6 6])
%ylim([-1,1.7])
ylabel('Activity (z-scored)');
xlabel('value diff.');
title('Mean sum of value and PE');
saveas(f,'Value.png')

figure;
yvals = fulldata.boostmean;
std = fulldata.booststd;
f = errorbar(xvals,yvals,std,'LineWidth',4,'Color', 'black');
xlim([-6 6])
%ylim([0.065,0.12])
ylabel('Activity (z-scored)');
xlabel('value diff.');
title('Mean boost');
saveas(f,'Boost.png')
