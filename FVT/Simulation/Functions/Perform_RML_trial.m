function [dat_single_trial,AccAct,AccBoost] = Perform_RML_trial(arg,AccAct,AccBoost,optimization_pars,startstate,clampedboost,clampedaction)
% Function for performing a single RML trial during the training. Allows
% for setting a start state, clamping the action and clamping the boost. If
% any of the clamped values are given, they are only used for the first
% state.

try
    clampedaction; % Actions are clamped for the first stage of the training
catch
    clampedaction = -1; % Value indicating that no clamped action was given
end

try
    clampedboost; % Boost is clamped for the first two stages of the training
catch
    clampedboost = -1; % Value indicating that no clamped boost was given
end

% The function starts in the start state indicated, and performs action
% selection and boost selection if required. It then performs environment
% transition, and learning. These steps are repeated until the RML
% transitions to the next trial

dat_single_trial = [];
s = startstate;
first = 1; % Whether the clamepd boost and action are to be used
nstate = size(AccAct.D,1);
counter = 1; % Keeps track of the number of the step within the trial
arg.laststate = 0; % First time this state is seen
while s<=nstate % Until the end of the trial
    % Perform boost selection
    if (first&clampedboost>-1)
        b=clampedboost;
    else
        b=action(AccBoost,s,[1:arg.nactions_boost],1); %boost selection only if this is not the first state visited, or no clamped boost was provided
    end

    % Perform action selection based on the current action selection model
    % Action selection can use: difference in value (Vdiff), boost (b) and
    % the optimzation parameters defined in the GD algorithm
    Vdiff = AccAct.V(s,2)-AccAct.V(s,1); % Estimated relative advantage over choosing option 2 over option 1
    if (first&clampedaction>-1)
        res = clampedaction;
        RT = 0; % No time discounting
    else
        if s<=arg.settingsenv.nsets 
            % The environment is currently in the helper state for
            % selecting the next environment. The RML therefore always
            % selects action 1, and a boost value of 1. No reaction time is
            % provided, since there is no action to be selected
            res = 1; % Set action to 1; no action required
            b = 1; % Set boost to 1; no action required
            RT = 0; % No time discounting 
        elseif s>(arg.settingsenv.nsets+arg.settingsenv.nsets*arg.settingsenv.ntrialsperset) % If the RML is only viewing the reward
            % The environment is currently in the reward viewing state,
            % where no action is to be selected. The RML therefore always
            % selects action 1. No reaction time is provided, since there
            % is no action to be selected 
            res = action(AccAct,s,[1:arg.nactions],b);
            RT = 0;
        else
            % If the RML needs to make a decision, pass the value
            % difference to the DDM to receive the RT and the selected
            % response
            [RT,res] = get_response(Vdiff,b,optimization_pars,AccAct,s); % Runs the DDM, and transforms the response
        end
    end

    % In order to avoid the agent to get stuck in foraging endlessly, we
    % set a limit of 10 forages in a row. At this point, we set the RML to
    % engage in the next trial
    if ((counter>20)&(s<=arg.settingsenv.nsets+arg.settingsenv.nsets*arg.settingsenv.ntrialsperset))
        res = 1;
    end

    % Perform reward evaluation and environment transition
    [RW,s1] = evaluate_environment(arg,s,res,RT,optimization_pars); % Evaluates the response

    % If next state is a setstate, set the laststate to the current state,
    % avoiding reselection of said state
    if s1<=arg.settingsenv.nsets
        arg.laststate = s;
    end

    % Store the values, boost, action, and state
    dat_single_trial.state(counter) = s;
    dat_single_trial.action(counter) = res;
    dat_single_trial.boost(counter) = b;
    if res == 0 
        dat_single_trial.Vpre(counter) = NaN;
    else
        dat_single_trial.Vpre(counter) = AccAct.V(s,res);
    end
    dat_single_trial.V2pre(counter)=AccBoost.V(s,b);
    dat_single_trial.value_1(counter) = AccAct.V(s,1);
    dat_single_trial.value_2(counter) = AccAct.V(s,2);
    dat_single_trial.RW(counter) = RW;
    dat_single_trial.RT(counter) = RT;

    % Perform value updating
    % In case the state is one of the set states, set the temporal
    % difference parameter to 1 temporarily. This reflects the idea that
    % the first states, where the model transitions to a random state of
    % the same set, exists only as a helper state, and no penalty or
    % benefit exists due to this state.
    if s<=arg.settingsenv.nsets 
        gamma = AccAct.gamma;
        AccAct.gamma = 1;
        AccBoost.gamma = 1;
    end
    if RW<0
        RW = 0; % Disallow negative rewards
    end
    rw = 1; % 
    if res ~=0
        VTA = learn(AccAct,rw,s,s1,res,RW,b); % Action value updating
    end
    VTA_boost = learn(AccBoost,rw,s,s1,b,RW,b); % Boost updating
    dat_single_trial.VTA(counter) = VTA;
    dat_single_trial.VTA_boost(counter) = VTA_boost;

    % Return the gamma parameter to its original value
    if s<=arg.settingsenv.nsets 
        AccAct.gamma = gamma;
        AccBoost.gamma = gamma;
    end


    if first == 1 % First trial is over
        first = 0;
    end
    % Perform variable updating
    counter = counter+1; % Indicate next step
    s = s1; % Go to next state
end