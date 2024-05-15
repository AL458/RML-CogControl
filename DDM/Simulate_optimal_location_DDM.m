function Simulate_optimal_location_DDM()

cd('DDM_scripts')



optimal_location = [40.83, 33.39, 0.39, 28.96]; % Otherwise, set to the defaults described in the supplementary material

% Optimal location contains four variables: The first variable is the
% scaling factor for the threshold in the DDM (see supplementary Equation
% S11). The second variable is the standard error of the Gaussian noise in
% the DDM (Equation S12). The third parameter is the scaling factor for the
% reaction time output (vrt, Equation S13), while the fourth parameter is
% the inverse of the scaling factor for the value difference in the DDM
% (Equation S10).

% Folder name to save the simulation output
savename = '.';

% Load priors
load('W3.mat');
load("We3.mat");
cwd = pwd;

restoredefaultpath;
clear subj_out
addpath(cwd)
nsubj = 200;


if ~isfolder(fullfile(savename,'Output'))
    mkdir(fullfile(savename,'Output'))
end
% Perform simulation
RML_main_opt_DDM(optimal_location,nsubj,savename,W,We)
end
