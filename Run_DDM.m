% Function for running the RML-DDM. The results of this function can be
% used by the function Plot_DDM

currwd = pwd;

cd('DDM')
Simulate_optimal_location_DDM()
cd(currwd)