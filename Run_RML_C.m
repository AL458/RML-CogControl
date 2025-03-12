% Function for running the RML-C-DDM. The results of this function can be
% used by the function Plot_RML_C


currwd = pwd;

cd(fullfile('DDM','DDM_RML_C'))
Simulate_optimal_location_DDM()
cd(currwd)