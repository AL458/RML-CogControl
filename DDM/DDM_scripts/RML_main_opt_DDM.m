function RML_main_opt_DDM(optimal_location,nsubj,savename,W,We)
% Script for simulating the dACC activity at the optimal location, using
% the DDM-RML combined model. This function uses the location containing
% the optimized parameter values (optimal_location), the number of subjects
% (nsubj), the location the data is saved (savename), and the prior value
% for the action and boost modules (W and We respectively) as input.


addpath('Scripts')
addpath('Scripts/All_scripts')
addpath('Input')
addpath(pwd)
currwd = pwd;
cd(savename)

% Get the arg structure
arg = param_build;
arg.nsubj= nsubj;

seed=round(rand(1,arg.nsubj)*1000);

% Set some of the parameters for the drift diffusion network, that could
% potentially be interesting to optimize over. In the simulations for the
% paper, only the congruency parameter, information parameter, standard
% deviation of the gaussian noise, kappa parameter and interface parameter
% between the reaction time generated by the DDM and the reward penalty.

optimization_pars.quadratic.rt_baseline = 1;
optimization_pars.quadratic.multiplication = 3;

optimization_pars.rwupperlimit = 510; % From what time the system starts deducting reward. 
                                      % Setting this equal to the non-response time allows 
                                      % the system to start deducting reward for each time 
                                      % unit the non-resposne time is passed. 
arg.rt_timeout = 600; % Time limit for the DDM
optimization_pars.DDM.bias = 510;% The non-response time of the system
optimization_pars.DDM.threshold_var = optimal_location(1); % Threshold part influenced by boost (the variable thetaDDM indicated in Equation S11).
optimization_pars.DDM.threshold_fix = 0; % Fixed part of threshold. If set to a non-zero value, this value is added to the boost-specific value indicated in the supplementary methods
optimization_pars.DDM.gaussian_noise = optimal_location(2); % Standard deviation of the white noise added to the DDM (sigma parameter in Equation S12)
optimization_pars.DDM.vdiff_mult = optimal_location(3); % Parameter determining the interface between the boost and the drift rate (vDDM parameter in Equation S10)
optimization_pars.rwmult = 1/optimal_location(4); % Set the vRT parameter to the inverse of the scaling factor, equal to the vRT parameter in Equation S13
n_training_trials = 10; % Number of times each state-boost pair is visited during the training

 for s=1:arg.nsubj
    % For each subject, we first perform the DAN training
    [W,We]=Run_training_DDM(n_training_trials,arg,seed(s),optimization_pars,0,W,We);
    dat{s} = kenntask_vass_DDM(s,arg,seed(s),optimization_pars,1,W,We); % Run the RML model
    % Store the results from the model to generate the relevant plots
    mean_RT = zeros(1,arg.constAct.nstate);
    sd_RT = zeros(1,arg.constAct.nstate);
    for state = 1:arg.constAct.nstate
        mean_RT(state) = mean(dat{s}.RT(dat{s}.s==state));
        mean_acc(state) = get_mean_acc(dat{s}.res(dat{s}.s==state),state,(dat{s}.RT(dat{s}.s==state)>arg.rt_timeout));
        sd_RT(state) = std(dat{s}.RT(dat{s}.s==state));
    end
    acc_mean(s,:) = get_mean_difficulty_level(mean_acc);
    RT(s,:) = get_mean_difficulty_level(mean_RT);
    RT_sd(s,:) = get_mean_difficulty_level(sd_RT);
 end
% Get mean value for accuracy and RT
acc_grandavg = mean(acc_mean);
RT_grandavg = mean(RT);

% Plot the results
output = [];
output.acc_mean = acc_mean;
output.RT = RT;
output.acc_grandavg = acc_grandavg;
output.RT_grandavg = RT_grandavg;

% %save('Current_data')
second_level_an_ho2_DDM(dat,'Output');
cd(currwd)
rmpath Scripts
rmpath Scripts/All_scripts
rmpath Input
