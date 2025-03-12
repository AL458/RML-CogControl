function Plot_optimal_location()

% Generate plots of the dACC activity at the optimal location
% It requires data to already be simulated. 

% Go to correct location, and add all funcitons to the path
cd('DA_scripts')
addpath('Functions')
addpath(pwd)

cd('Output')
% Retrieve the simulated data, and summarize it
second_level_an_ho2_dual_attractor_full();
% Plot the fit for the accuracy and the RT
Plot_acc_RT_fit;
rmpath('Functions')
rmpath(pwd)

cd('..')

end