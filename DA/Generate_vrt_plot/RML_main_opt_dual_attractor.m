
function [dat, output,optimization_pars] = RML_main_opt_dual_attractor(location,nparts)
% Performs the simulation for one location (given as input location),
% containing five variables: the congruency parameter, the information
% parameter, the standard deviation of the DAN noise, the kappa parameter,
% and the vrt parameter. This function returns the data for nparts
% simulated participants

substart = 1;
arg = param_build;
arg.RWM(:,1:2)=arg.RWM(:,1:2);

RT = [];
dat = [];
try
    arg.nsubj = nparts;
end

seed=round(rand(1,arg.nsubj)*100000);

% Set some of the parameters for the dual attractor, that could potentially
% be interesting to optimize over. In the simulations for the paper, only
% the congruency parameter, information parameter, standard deviation of
% the gaussian noise, kappa parameter and interface parameter between the
% reaction time generated by the DAN and the reward penalty.
arg.rt_timeout = 700; % The time limit for the dual attractor
optimization_pars.dualattractor.bias = 510; % The non-response time of the system
optimization_pars.rwupperlimit = 510; % From what time the system starts deducting reward. 
                                      % Setting this equal to the non-response time allows 
                                      % the system to start deducting reward for each time 
                                      % unit the non-resposne time is passed. 
optimization_pars.dualattractor.threshold_parameter = 3; % The treshold of the dual attractor. This value was not optimized over during the gradient descent
optimization_pars.dualattractor.congruency_parameter = location(1); % Parameter determining the congruency effect (the variable Dual_cong in Equations S16a and S16b)
optimization_pars.dualattractor.information_parameter = location(2); % Parameter determining the interface between the boost value and the beta value (see Equation S15)
optimization_pars.dualattractor.randstd = location(3); % Parameter determining the strength of the gaussian noise in Equation S14a and S14b.
optimization_pars.dualattractor.kappa= location(4); %Parameter determining the characteristic decay rate in Equation S14a and S14b.
optimization_pars.rwmult = location(5); % Parameter determining the scaling between the DAN reaction time units and the reward penalty in Equation S17
n_training_trials = 10; % Number of times each state-boost and state-action pair is visited during the training



for sub=substart:arg.nsubj
    [W,We] = Run_training_DAN(n_training_trials,arg,seed(sub),optimization_pars,0);
    dat{sub} = kenntask_vass_dual_attractor(sub,arg,seed(sub),optimization_pars,1,W,We);
    mean_RT = zeros(1,arg.constAct.nstate);
    sd_RT = zeros(1,arg.constAct.nstate);
    for state = 1:arg.constAct.nstate
        mean_RT(state) = mean(dat{sub}.RT(dat{sub}.s==state));
        mean_acc(state) = get_mean_acc(dat{sub}.res(dat{sub}.s==state),state,(dat{sub}.RT(dat{sub}.s==state)>arg.rt_timeout));
        sd_RT(state) = std(dat{sub}.RT(dat{sub}.s==state));
    end
    acc_mean(sub,:) = get_mean_difficulty_level(mean_acc);
    RT(sub,:) = get_mean_difficulty_level(mean_RT);
    RT_sd(sub,:) = get_mean_difficulty_level(sd_RT);
end
% Get mean value for accuracy and RT
acc_grandavg = mean(acc_mean);
RT_grandavg = mean(RT);

% Generate the output structure, containing information about the reaction
% time and accuracy
output = [];
output.acc_mean = acc_mean;
output.RT = RT;
output.acc_grandavg = acc_grandavg;
output.RT_grandavg = RT_grandavg;



