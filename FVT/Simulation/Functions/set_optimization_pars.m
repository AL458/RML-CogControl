function optimization_pars = set_optimization_pars(optimal_location)
% Function for converting the parameters into a structure that is used by
% the rest of the script

optimization_pars.DDM.threshold_var = optimal_location(1); % Threshold part influenced by boost
optimization_pars.DDM.threshold_fix = 0; % Fixed part of threshold
optimization_pars.DDM.gaussian_noise = optimal_location(2); % Noise in the DDM
optimization_pars.DDM.vdiff_mult = optimal_location(3); % Drift rate multiplier (zoom factor)
optimization_pars.rwupperlimit = 0;
optimization_pars.rwmult = 0; % Effect of RT on percieved reward
optimization_pars.highvalue = 9; % Maximum value available during the task
optimization_pars.lowvalue = 0; % Minimal value available during the task
optimization_pars.cost = 0; % Cost for selecting the foraging option
optimization_pars.use_DDM = 1; % Use DDM
optimization_pars.banditcost = 0; % Cost for performing the bandit high value option
optimization_pars.DDM.bias_modifiable = optimal_location(4); % Bias to be discounted by boost

end