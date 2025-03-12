function [RW,s1] = evaluate_environment(arg,s,res,RT,optimization_pars)
% Function governing the changes in the environment and the reward recieved
% for the selected response
    
    % Get the next state from the current state and response
    s1 = Select_environment_FVT(s,res,arg.settingsenv.nsets,arg.settingsenv.ntrialsperset,arg.laststate);

    % Get the reward from the current state and selected action
    RW = simulate_reward(s,res,arg);

    % Like the other simulations performed, the RML interacts with the DDM
    % by reducing the reward by a function of the reaction time
    RW = RW-RT*optimization_pars.rwmult;

end

function RW = simulate_reward(state,action,arg)
    % Function for simulating the reward given the state and selected
    % action
    if arg.RWM(state,action)==0
        % If the selected action did not yield an immediate reward (i.e.
        % when the action was engaging or viewing the foraging cues), set
        % the final reward to 0.
        RW = 0; 
    else
        % If any reward (including negative rewards) was recieved, add
        % random noise to the reward, to ensure the RML learning module
        % does not encounter numerical roundoff errors
        RW = normrnd(arg.RWM(state,action),arg.var(state,action));
    end
    if state<=(arg.settingsenv.nsets+arg.settingsenv.ntrialsperset)
        % Additionally, if the foraging action is selected, only provide a
        % reward in 70% of the cases
        if rand()>arg.RWP
            RW = 0; % No reward
        end
    end
end


function newstate = Select_environment_FVT(state,action,nsets,nstatesperset,laststate)
% Function for defining the environment from the state, action selected
% by the RML, and several environment parameters

% Check the current state

if state<=nsets
    % If the current state is smaller than or equal to the number of sets,
    % the state is the state used to select a random state from the set
    % indicated by the state number. In this case, the function returns a
    % random state from that set.
    if action > 1
        error('Incorrect action provided to the environment')
    end
    newstate = get_random_state(state,nsets,nstatesperset,laststate);
elseif state<=(nsets+nsets*nstatesperset)
    % Current state is the first phase of the trial, where the agent can
    % choose to engage (action number 1) or forage (action number 2).
    
    if action==1
        % Agent engages with the trial, and receives reward
        newstate = state + nsets*nstatesperset; % Transfer to next stage
    else % Agent selected the forage option
        % Return to the random state selection state, keeping in memory the
        % current state, so it will not be selected the next time
        randomlyselected = mod(state-nsets,nstatesperset); % Index of the 
                                % selected state
        newstate = 1+(state-randomlyselected-nsets)/nstatesperset; % Set 
                                % the new state to the state selecting a
                                % random state of the current set.                
    end
else
    % Agent is performing a phase 2 part of the trial, only viewing the
    % reward. Transition to the next trial
    newstate = nsets*nstatesperset*2+nsets+1; % Transition to next trial   
end


end

function newstate = get_random_state(state,nsets,nstatesperset,laststate)
% Function for selecting a random state of the set the previous state
% belonged to, avoiding the previously selected state

if laststate == 0 
    % If no forage action has been selected before, all subsequent states
    % can be selected 
    newstate_ind = floor(rand()*nstatesperset)+1; % State selected
    % Find the correct state number
    newstate = nsets+nstatesperset*(state-1)+newstate_ind;
else
    % This selection has happened before. Make sure not to provide the same
    % next trial
    newstate_ind = floor(rand()*(nstatesperset-1))+1; % State selected
    newstate = nsets+nstatesperset*(state-1)+newstate_ind;
    if newstate>=laststate
        newstate=newstate+1;
    end
end

end