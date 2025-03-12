function Make_figures_plot_new_AIC(summarized_data,AIC_struct,name)
% Function for generating the shown plots on the ability of the RML to
% simulate dACC activity during a forage value paradigm. Requires the
% summarized data as an input (from Generate_summary.m), and a name for the
% output image.

% Generates a plot with three different subplots. The first plot shows the
% boost activity as a function of forage value. The second plot shows the
% simulated dACC activity as a function of forage value. The final plot
% shows the simulated dACC activity as a function of decision difficulty.


% Generate relevant AIC parameters


nbins = 8;
% Initialization of the figure as a full screen object in Matlab
figure_to_store = figure('units','normalized','outerposition',[0 0 1 1]);

% Generate the figure layout
subplot(2,2,1)
toplot = summarized_data.normtable_FVsubj;
hold on
title('Simulated boost activity as function of FV')
xlabel('Forage value')
xlim([0.5,nbins+0.5])
ylabel('Simulated boost activity (a.u.)')
% Plot the data
errorbar(toplot.bin_FV,toplot.mean_Boost,toplot.sem_Boost,Color='k',LineWidth=3);

% Generate the second subplot, showing the simualted dACC activity as a
% function of forage value
subplot(2,2,2)
toplot = summarized_data.normtable_FVsubj;
hold on
title('Simulated dACC activity as function of FV')
xlabel('Forage value')
xlim([0.5,nbins+0.5])
ylabel('Simulated dACC activity (a.u.)')
% Plot the data
errorbar(toplot.bin_FV,toplot.mean_dACC,toplot.sem_dACC,Color='k',LineWidth=3);

% Generate the third subplot, showing the simualted dACC activity as a
% function of decision difficulty

subplot(2,2,3)
toplot = summarized_data.normtable_diffsubj;
hold on
title('Cognitive control as function of difficulty')
xlabel('Decision difficulty')
xlim([0.5,nbins+0.5])
ylabel('Simulated cognitive control (a.u.)')
% Plot the data
errorbar(toplot.bin_diff,toplot.mean_Boost,toplot.sem_Boost,Color='k',LineWidth=3);



subplot(2,2,4)
toplot = summarized_data.normtable_diffsubj;
hold on
title('dACC activity as function of difficulty')
xlabel('Decision difficulty')
xlim([0.5,nbins+0.5])
ylabel('Simulated dACC activity (a.u.)')
% Plot the data
errorbar(toplot.bin_diff,toplot.mean_dACC,toplot.sem_dACC,Color='k',LineWidth=3);

% Save plot
saveas(figure_to_store,strcat(name,'.fig'))
saveas(figure_to_store,strcat(name,'.png'))

%% Plot all separately

nbins = 8;
% Initialization of the figure as a full screen object in Matlab
figure_to_store = figure;

% Generate the figure layout
toplot = summarized_data.normtable_FVsubj;
hold on
title('Simulated boost activity as function of FV')
xlabel('Forage value')
xlim([0.5,nbins+0.5])
ylabel('Simulated boost activity (a.u.)')
% Plot the data
errorbar(toplot.bin_FV,toplot.mean_Boost,toplot.sem_Boost,Color='k',LineWidth=3);

% Get quadratic fit
p = AIC_struct.boost_FV.stats_quadratic.estimate;
plot([1:8],p,'--','LineWidth',2,'Color','b')

% Save plot
saveas(figure_to_store,strcat(name,'_poly_boost_FV.fig'))
saveas(figure_to_store,strcat(name,'_poly_boost_FV.png'))


close(figure_to_store)

figure_to_store = figure;
% Generate the second subplot, showing the simualted dACC activity as a
% function of forage value
toplot = summarized_data.normtable_FVsubj;
hold on
title('Simulated dACC activity as function of FV')
xlabel('Forage value')
xlim([0.5,nbins+0.5])
ylabel('Simulated dACC activity (a.u.)')
% Plot the data
errorbar(toplot.bin_FV,toplot.mean_dACC,toplot.sem_dACC,Color='k',LineWidth=3);

% Get quadratic fit
p = AIC_struct.dACC_FV.stats_quadratic.estimate;
plot([1:8],p,'--','LineWidth',2,'Color','b')

% Save plot
saveas(figure_to_store,strcat(name,'_poly_dACC_FV.fig'))
saveas(figure_to_store,strcat(name,'_poly_dACC_FV.png'))

close(figure_to_store)

figure_to_store = figure;

% Generate the third subplot, showing the simualted dACC activity as a
% function of decision difficulty
toplot = summarized_data.normtable_diffsubj;
hold on
title('Cognitive control as function of difficulty')
xlabel('Decision difficulty')
xlim([0.5,nbins+0.5])
ylabel('Simulated cognitive control (a.u.)')
% Plot the data
errorbar(toplot.bin_diff,toplot.mean_Boost,toplot.sem_Boost,Color='k',LineWidth=3);


% Get linear fit
p = AIC_struct.boost_diff.stats_linear.estimate;
plot([1:8],p,'--','LineWidth',2,'Color','b')


% Save plot
saveas(figure_to_store,strcat(name,'_poly_boost_diff.fig'))
saveas(figure_to_store,strcat(name,'_poly_boost_diff.png'))


close(figure_to_store)

figure_to_store = figure;

toplot = summarized_data.normtable_diffsubj;
hold on
title('dACC activity as function of difficulty')
xlabel('Decision difficulty')
xlim([0.5,nbins+0.5])
ylabel('Simulated dACC activity (a.u.)')
% Plot the data
errorbar(toplot.bin_diff,toplot.mean_dACC,toplot.sem_dACC,Color='k',LineWidth=3);

% Get linear fit
p = AIC_struct.dACC_diff.stats_linear.estimate;
plot([1:8],p,'--','LineWidth',2,'Color','b')

% Save plot
saveas(figure_to_store,strcat(name,'_poly_dACC_diff.fig'))
saveas(figure_to_store,strcat(name,'_poly_dACC_diff.png'))
close(figure_to_store)


end