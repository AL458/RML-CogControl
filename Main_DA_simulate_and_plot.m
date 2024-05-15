% Script for executing all DA analyses as performed in the supplementary
% materials, by first simulating the data and subsequently plotting the
% results


cd('DA')
% Run the simulation of the optimal location
Simulate_optimal_location()
% Run the simulation of the VRT simulation
Perform_vrt_simulation()
% plot the VRT output
Plot_vrt_simulation()
cd('..')

