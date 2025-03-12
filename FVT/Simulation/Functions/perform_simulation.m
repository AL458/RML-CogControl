function [dat,arg,behavior] = perform_simulation(optimization_pars,ntrain,nparts)
% Function for performing the simulation. Starts by defining the
% environment (param_build_FVT), followed by running the simulation for 40
% subjects

% Define environment
arg = param_build_FVT(optimization_pars); % Define environment and parameters for the RML
optimization_pars.DDM.RT_timeout = arg.rt_timeout; % To avoid the model running infinitely

behavior_out = [];
dat = [];

arg.nsubj = nparts;         % Run for 40 participants
n_training_trials=ntrain;   % Sets the rigorousness of the training. This 
                        % parameter indicates the number of times each
                        % action-state pair is shown to the model, the
                        % number of times each boost-state pair is shown to
                        % the model, and is multiplied by 10 for the number
                        % of training trials on the full model

%seed = [42]*[1:arg.nsubj]; % Set a fixed seed for all participants
seed=round(rand(1,arg.nsubj)*1000);

for s=1:arg.nsubj
    disp(['Subject_number:' num2str(s)])
    % Run the training
    [W,We]=Run_training_FVT(n_training_trials,arg,seed(s),optimization_pars);
    % Perform the simulation, using the trained values
    dat{s} = kenntask_FVT(s,arg,seed(s),optimization_pars,0,W,We);
    % Store behavior by state
    behavior_out{s} = extract_behavior(dat{s},arg);
end

% Summarize the full behavior

behavior = mean_behavior(behavior_out);

end