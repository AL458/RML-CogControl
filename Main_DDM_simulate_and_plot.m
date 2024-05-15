% Script for executing all DDM analyses as performed in the supplementary
% and main materials, by first simulating the data and subsequently
% plotting the results


cd('DDM')
% Run the simulation of the optimal location
Simulate_optimal_location_DDM()
% Run the simulation of the VRT simulation
Perform_vrt_simulation()
% plot the VRT output
Plot_vrt_simulation()
cd('..')

