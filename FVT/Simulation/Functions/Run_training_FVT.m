function [W,We] = Run_training_FVT(n_training_trials,arg,seed,optimization_pars)
% Performs the full training of the forage value task for the RML. Performs
% the training in three parts. First, it clamps the boost and action,
% learning the rewards for each of the possible options. Then, it clamps
% the boost, and lets the model select the action by itself. Thirdly, the
% model performs the entire task without clamping any actions or boost
% values.

%create a specific random stream for current workspace (for parallel batching)
rss = RandStream('mt19937ar','Seed',seed);
RandStream.setGlobalStream(rss);

nstate=arg.constAct.nstate;

BL=arg.BL; % Get the length of each block
%number of trials
NTRI=BL*length(arg.SEN);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Start Experiment%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%create RML object%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AccAct=RML(nstate,arg.nactions,arg.constAct);
AccActBuff=RML(nstate,arg.nactions,arg.constAct);
AccBoost=RML(nstate,arg.nactions_boost,arg.constBoost);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nsets = arg.settingsenv.nsets;
ntrials = arg.settingsenv.ntrialsperset*nsets;
endofforage = nsets+ntrials;

% Set prior forage values to the actual forage values
AccAct.V(1:nsets,1) = arg.foragevalue(floor(nsets+(1:nsets)*ntrials/nsets));

% Set the initial values of the second bandit to the true values
AccAct.V(endofforage+1:end-1,1:2)= arg.RWM(endofforage+1:end,:);

%Set initial values to the optimal values of the engage option
AccAct.V(nsets+1:endofforage,1)= max(AccAct.V(endofforage+1:end-1,1:2)')';

% Set initial forage values
AccAct.V(nsets+1:endofforage,2)= arg.foragevalue(nsets+1:endofforage);

% Set boost prior to be the max value in each state, discounted by the
% boost cost

% Set prior boost values to 1-the boost cost
AccBoost.V(1:nstate,:) = max(AccAct.V(1:nstate,:)')'-AccBoost.omega*[1:10];
AccActBuff.V=AccAct.V;

% Identify the states determining the start of stage 2, the end of stage 2,
% the start of the set cues, the end of the set cues, the start of stage 1,
% and the end of stage 1

startsetcues = 1;
endsetcues = arg.settingsenv.nsets;
startstatecues = arg.settingsenv.nsets+1;
endstatecues = arg.settingsenv.nsets+arg.settingsenv.nsets*arg.settingsenv.ntrialsperset*2;
endstatecues = arg.settingsenv.nsets+arg.settingsenv.nsets*arg.settingsenv.ntrialsperset;

% The training consists of several different training steps. In the first
% step, the value of the rewards states is learned.
% 
% As the cues are trained until the participants know them fully, the
% rewards for these cues is set to the environment reward value.
% Afterwards, the model is trained on these cues for several trials,
% learning the influence the boost has on these values, and the optimal
% boost values as well.


trial = 1; % Keep track of the trailnumber

% Part 1: keep boost equal to 5, clamp action
for training_trial = 1:n_training_trials
    for state = startstatecues:endstatecues
        for action = 1:2
            clampedboost = 5;
            [~,AccAct,AccBoost] = Perform_RML_trial(arg,AccAct,AccBoost,optimization_pars,state,clampedboost,action);
            trial = trial+1;
        end
    end
end


% Part 2: Clamp boost, select action based on boost
for training_trial = 1:n_training_trials
    for state = startstatecues:endstatecues
        for boost = 1:arg.nactions_boost
            [~,AccAct,AccBoost] = Perform_RML_trial(arg,AccAct,AccBoost,optimization_pars,state,boost);
            trial = trial+1;
        end
    end
end

% Part 3: Perform the full task, starting from each foraging decision
% reward

for training_trial = 1:(n_training_trials)
    for state = startstatecues:endstatecues
        [~,AccAct,AccBoost] = Perform_RML_trial(arg,AccAct,AccBoost,optimization_pars,state);
        trial = trial+1;
    end
end

% Store the values of W and We for use in the model estimation. These are
% the prior values from the training

W = AccAct.V(1:end-1,:);
We = AccBoost.V(1:end-1,:);

end











