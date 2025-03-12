% Function for plotting the RML-C-DDM results. Requires running the function
% Run_RML_C before running this function

currwd = pwd;

cd(fullfile('DDM','DDM_RML_C'))
Plot_DDM_data()
cd(currwd)