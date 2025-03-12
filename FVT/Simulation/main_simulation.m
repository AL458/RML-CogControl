function main_simulation(estimated_parameters,ntrain,nparts)
% Function for performing the simulation 

addpath('Functions')

% Transform the estimated parameters into parameters that can be used by
% the script
optimization_pars = set_optimization_pars(estimated_parameters); 

% Perform simulation
[dat,arg,behavior] = perform_simulation(optimization_pars,ntrain,nparts);

% Save output
save(fullfile('..','Output.mat'),"behavior","dat","arg");

% Clean the path
rmpath('Functions')


end

