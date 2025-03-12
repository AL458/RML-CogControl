% Generates plots for the vrt analysis for the DDM and DAN. Requires to
% have run the function Run_Vrt before running this.

% Plot the DDM vrt analysis
cd('DDM')
cd('Generate_vrt_plot')
Plot_varied_parameters()
cd('..')
cd('..')

% Plot the DAN vrt analysis
cd('DAN')
cd('DA')
cd('Generate_vrt_plot')
Plot_varied_parameters()
cd('..')
cd('..')
cd('..')
