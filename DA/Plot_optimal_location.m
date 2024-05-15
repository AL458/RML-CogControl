function Plot_optimal_location()

% Generate plots of the dACC activity at the optimal location
% It requires data to already be simulated. 

cd('DA_scripts')
addpath('Input')
addpath('Scripts')
addpath('Scripts/All_scripts')
addpath(pwd)

cd('Output/')
figure
second_level_an_ho2_dual_attractor_full();
cd('..')
rmpath('Input')
rmpath('Scripts')
rmpath('Scripts/All_scripts')
rmpath(pwd)

cd('..')

end