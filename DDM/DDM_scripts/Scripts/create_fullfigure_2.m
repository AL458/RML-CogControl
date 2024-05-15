function create_fullfigure(xvals,fulldata)

figure
yvals = fulldata.dACCmean;
std = fulldata.dACCstd;
f = errorbar(xvals,yvals,std,'LineWidth',4,'Color', 'black');
xlim([-6 6])
%ylim([-0.3,0.3])
ylabel('Activity (z-scored)');
xlabel('value diff.');
title('dACC activity');
saveas(f,'dACC_activity.png')

poly = polyfit(xvals,yvals,4);
hold on
poly_y = poly(1)*xvals.^4+poly(2)*xvals.^3+poly(3)*xvals.^2+poly(4)*xvals+poly(5);
plot(xvals,poly_y,'LineStyle','--','Color','blue','LineWidth',3)
save('estimated_poly.mat','poly')
saveas(f,'dACC_activity_withestimatedpoly.png')

% box(axes1,'on');
% set(axes1,'FontSize',16,'FontWeight','bold','XTick',linspace(-5,5,11));
figure;
yvals = fulldata.Vmean;
std = fulldata.Vstd;
f = errorbar(xvals,yvals,std,'LineWidth',4,'Color', 'black');
xlim([-6 6])
ylim([-1,1.7])
ylabel('Activity (z-scored)');
xlabel('value diff.');
title('Mean sum of value and PE');
saveas(f,'Value.png')

figure;
yvals = fulldata.boostmean;
std = fulldata.booststd;
f = errorbar(xvals,yvals,std,'LineWidth',4,'Color', 'black');
xlim([-6 6])
ylim([-1.5,1.5])
ylabel('Activity (z-scored)');
xlabel('value diff.');
title('Mean boost');
saveas(f,'Boost.png')
