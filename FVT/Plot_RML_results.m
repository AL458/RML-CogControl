function Plot_RML_results()

addpath('Functions')

% Preprocess the data
Output = Preprocess_for_figures_plot_new();

% Get the AIC results
AIC_struct = Run_AIC(Output);

% Generate figures
Make_figures_plot_new_AIC(Output,AIC_struct,fullfile('Figures','Figure'))


rmpath('Functions')

end