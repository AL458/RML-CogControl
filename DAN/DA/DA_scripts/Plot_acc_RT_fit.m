function Plot_acc_RT_fit()
% Generates the plot comparing the accuracy and RT of the RML-DAN with the
% data from Vassena et al.

% Load the stored RT and accuracy values
load('RTandACC.mat','RT','acc_mean')

nparts = size(RT,1);

RT_found_mean = zscore(mean(RT));
sem_RT = std(mean(RT));
RT_found_sem = std((RT))/sem_RT/sqrt(nparts);

acc_found_mean = mean(acc_mean);
acc_found_sem = std(acc_mean)/sqrt(nparts);

% Get values from Vassena et al. (retreived using webplotdigitizer)
acc_yvals_mean = [nan 0.909, 0.822, 0.730, 0.613, 0.491, 0.580, 0.711, 0.844, 0.873];
acc_yvals_sem = [nan 0.0179,0.0289,0.0325,0.0348,0.0211,0.0355,0.0319,0.028,0.0160];
acc_xvals_true = linspace(-4,4,9);

RT_yvals_mean = [nan -1.675,0.059,-0.009,1.315,0.879,0.127,0.919,-0.295,-1.320];
RT_yvals_sem = [nan 1.267,1.087,1.242,1.175,1.142,0.983,1.188,1.095,1.302];
RT_xvals_true =linspace(-4,4,9);

% Plot RT

f = figure;
subplot(1,2,1)
title('Accuracy fit')
errorbar(linspace(-5,5,11),acc_found_mean,acc_found_sem,'LineWidth',1,'Color','blue')
hold on 
errorbar(linspace(-5,4,10),acc_yvals_mean,acc_yvals_sem,'LineWidth',1,'Color','red')
plot(linspace(-5,5,11),acc_found_mean,'Linewidth',2,'Color','blue')
plot(linspace(-5,4,10),acc_yvals_mean,'Linewidth',2,'Color','red')
xlim([-6,6])

subplot(1,2,2)
title('RT fit')
errorbar(linspace(-5,5,11),RT_found_mean,RT_found_sem,'LineWidth',1,'Color','blue')
hold on 
errorbar(linspace(-5,4,10),RT_yvals_mean,RT_yvals_sem,'LineWidth',1,'Color','red')
plot(linspace(-5,5,11),RT_found_mean,'Linewidth',2,'Color','blue')
plot(linspace(-5,4,10),RT_yvals_mean,'Linewidth',2,'Color','red')
xlim([-6,6])

saveas(f,'Accuracy_RT_fit.png')
saveas(f,'Accuracy_RT_fit')

