function Simulate_FVT()

% Function that first performs the simulation, and then the plot script

ntrain = 4; % Number of training trials
nparts = 40; % Number of participants to simulate
estimated_parameters = [12.410,3.014,1.519,22.549]; % Define parameters for DDM and environment

cd('Simulation')
% Perform simulation
main_simulation(estimated_parameters,ntrain,nparts)
cd('..')

addpath('Functions')
% Convert output for use in the plot_FVT script
Generate_fullfile();
rmpath('Functions')


end
