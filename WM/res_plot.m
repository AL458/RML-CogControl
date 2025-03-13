function Plot_WM_data()

%plot results from WM sims for the EVC paper
close all
clear all 
clc
res=importdata('results.mat');

%plot boost
figure1 = figure;
axes1 = axes('Parent',figure1);
errorbar(mean(res(:,1:4)),std(res(:,1:4))/length(res).^.5,'LineWidth',2);
hold on
res2=res(:,1:4)';
res3=res2(:);
reg=repmat([1 2 3 4]',15,1);
mdl=fitlm(reg,res3)
x_fit = linspace(min(reg), max(reg), 100)'; % Column vector for prediction
y_fit = predict(mdl, x_fit);  % Predict corresponding y-values

% Plot only the linear trend as a dashed black line
plot(x_fit, y_fit, 'k--', 'LineWidth', 2); % 'k' for black, '--' for dashed



title('Boost');
xlim([.75 4.25]);
set(axes1,'FontSize',14,'FontWeight','bold','XTick',[1 2 3 4]);

%plot surpise
figure2 = figure;
axes2 = axes('Parent',figure2);
errorbar(mean(res(:,9:12)),std(res(:,9:12))/length(res).^.5,'LineWidth',2);
hold on
res2=res(:,9:12)';
res3=res2(:);
reg=repmat([1 2 3 4]',15,1);
mdl=fitlm(reg,res3)
x_fit = linspace(min(reg), max(reg), 100)'; % Column vector for prediction
y_fit = predict(mdl, x_fit);  % Predict corresponding y-values

% Plot only the linear trend as a dashed black line
plot(x_fit, y_fit, 'k--', 'LineWidth', 2); % 'k' for black, '--' for dashed

xlim([.75 4.25]);
title('Surprise');
% ylim([.9 2]);
set(axes2,'FontSize',14,'FontWeight','bold','XTick',[1 2 3 4]);

%plot value
figure3 = figure;
axes3 = axes('Parent',figure3);
errorbar(mean(res(:,17:20)./2),std(res(:,17:20)./2)/length(res).^.5,'LineWidth',2);
hold on
res2=res(:,17:20)'./2;
res3=res2(:);
reg=repmat([1 2 3 4]',15,1);
mdl=fitlm(reg,res3)
x_fit = linspace(min(reg), max(reg), 100)'; % Column vector for prediction
y_fit = predict(mdl, x_fit);  % Predict corresponding y-values

% Plot only the linear trend as a dashed black line
plot(x_fit, y_fit, 'k--', 'LineWidth', 2); % 'k' for black, '--' for dashed
% plot(mdl, 'k--', 'ConfidenceBounds', 'off', 'Marker', 'none');

title('Expected value');
xlim([.75 4.25]);

set(axes3,'FontSize',14,'FontWeight','bold','XTick',[1 2 3 4]);

%plot performance
figure4 = figure;
axes3 = axes('Parent',figure4);
errorbar(mean(res(:,25:28)),std(res(:,25:28))/length(res).^.5,'LineWidth',2);
title('Accuracy');
xlim([.75 4.25]);
ylim([.5 1]);

set(axes3,'FontSize',14,'FontWeight','bold','XTick',[1 2 3 4]);

end