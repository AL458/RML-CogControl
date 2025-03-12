function Plot_acc_and_RT()

% Reads the simulated accuracy and RT
load('Output.mat')

addpath('Functions')

% Perform preprocessing
[totaloptimization] = Get_optimization_pars(dat,arg);
[fullavgs] = get_accuracy_and_RT(totaloptimization);

foundacc = 1-fullavgs.mean_Acceptance'; % P(choose forage)
semRTnew = fullavgs.sem_RT./std(fullavgs.mean_RT);
foundRT = zscore(fullavgs.mean_RT)';

% Get the RT and accuracy as reported by Shenhav et al. (estimated using
% webplotdigitizer) 
truert = zscore([0.6615,0.7149,0.8262,0.9559,1.0516,1.2103,1.1413,1.0753]);
sdrt = [0.04004,0.03114,0.03114,0.03559,0.04004,0.04598,0.04449,0.06674];
trueacc = [0.0449,0.0508,0.0771,0.2124,0.3594,0.5791,0.7129,0.8145];
sdacc = [0.01563,0.00977,0.01367,0.02051,0.02539,0.02930,0.03125,0.03516];

% Plot the comparison between the measured RT and acc and the RT and acc
% reported by Shenhav et al.
f = figure;
subplot(1,2,1)
title('Accuracy fit')
hold on 
errorbar(linspace(1,8,8),foundacc,fullavgs.sem_Acceptance,'LineWidth',1,'Color','blue')
errorbar(linspace(1,8,8),trueacc,sdacc,'LineWidth',1,'Color','red')
plot(linspace(1,8,8),foundacc,'Linewidth',2,'Color','blue')
plot(linspace(1,8,8),trueacc,'Linewidth',2,'Color','red')
xlim([0,9])
ylim([0,1])

subplot(1,2,2)
title('RT fit')
hold on 
errorbar(linspace(1,8,8),foundRT,semRTnew,'LineWidth',1,'Color','blue')
errorbar(linspace(1,8,8),truert,sdrt,'LineWidth',1,'Color','red')
plot(linspace(1,8,8),foundRT,'Linewidth',2,'Color','blue')
plot(linspace(1,8,8),truert,'Linewidth',2,'Color','red')
xlim([0,9])

saveas(f,'RT_and_acceptance.png')
saveas(f,'RT_and_acceptance.fig')

rmpath('Functions')
