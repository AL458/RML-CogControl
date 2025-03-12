% Function for running the DAN simulations performed. Required before
% running the function plot_DAN

currwd = pwd;

cd('DAN')
Main_DA_simulate_only()
cd(currwd)