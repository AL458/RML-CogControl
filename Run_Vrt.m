% Simulates the data for the Vrt analysis. This analysis can take a while
% to run

% Simulate the DDM vrt analysis
cd('DDM')
cd('Generate_vrt_plot')
Run_for_different_variables()
cd('..')
cd('..')

% Simulate the DAN vrt analysis
cd('DAN')
cd('DA')
cd('Generate_vrt_plot')
Run_for_different_variables()
cd('..')
cd('..')
cd('..')
