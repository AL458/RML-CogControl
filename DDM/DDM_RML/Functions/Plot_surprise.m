function Plot_surprisetable()

% Requires surprisetable, which is stored by second_level_an_ho2_DDM

% Read surprise
load('surprisetable.mat')

% Average over subjects

high_surprisetable_grppersubj = grpstats(surprisetable,["Subject_ID","Accuracy"],"mean","DataVars",["Surprise"]);
high_surprisetable_grppersubj.GroupCount = [];

high_surprisetable_grppersubj.Properties.VariableNames = ["Subject_ID","Accuracy","Surprise"];
high_surprisetable_toplot = grpstats(high_surprisetable_grppersubj,["Accuracy"],["mean","sem"]);

meanstoplot = high_surprisetable_toplot.mean_Surprise;
semtoplot = high_surprisetable_toplot.sem_Surprise;

% Create figure

f = figure;
bar_handle = bar([meanstoplot(2),meanstoplot(1)], BarWidth=0.5); % Bar chart

% Add error bars
hold on;
errorbar(1:2, [meanstoplot(2) meanstoplot(1)], [semtoplot(2) semtoplot(1)], 'k.', 'LineWidth', 1.5);

xticks([1,2])
xticklabels({'Expected outcome','Unexpected outcome'})
ylabel('Total surprise (a.u.)')
%ylim([0,1.5])
saveas(f,fullfile('Output_plots','Accuracy_effect_on_PE.png'))
saveas(f,fullfile('Output_plots','Accuracy_effect_on_PE.fig'))