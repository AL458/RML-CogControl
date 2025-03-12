function [behavior,tooptimize] = extract_behavior(dat,arg)
% Function for extracting the mean behavior for each state

nstates = size(arg.RWM,1);

decisions = zeros(nstates,1);
boost = zeros(nstates,1);
VTA = zeros(nstates,2);
nsets = arg.settingsenv.nsets;
nstatesperset = arg.settingsenv.ntrialsperset;

for state = (nsets+1):nstates
    % Determine the moments the decision about this state was made
    indices = dat.state==state;

    % Determine the average behavior
    decisions(state) = mean(mean(dat.action(indices)));

    % Determine the average selected boost
    boost(state) = mean(mean(dat.boost(indices)));

    % Determine the VTA value
    VTA(state,1) = mean(mean(dat.VTA(indices)));
    VTA(state,2) = mean(mean(dat.VTA_boost(indices)));

    actualvalueaccept(state) = mean(mean(dat.value_1(indices)));
    actualvalueforage(state) = mean(mean(dat.value_2(indices)));
    
    RTmean(state) = mean(log(dat.RT(indices&(dat.RT<=arg.rt_timeout))));
end


% Transform the decision into an acceptance parameter
acceptance = 2-decisions;

% Calculate FV, decision difficulty for all different states

FV = arg.foragevalue;
accept_value = max(arg.RWM');
accept_value_true = accept_value;
accept_value_true((nsets+1):nsets*(nstatesperset+1)) = accept_value(1+nsets*(nstatesperset+1):end);
relvalofengage = actualvalueaccept-actualvalueforage;
true_relative_forage_value = FV'-accept_value_true;

TrueAV = accept_value_true;
TrueFV = true_relative_forage_value;

% Get the indifference point
try
    indifference_point = get_indifference_point(acceptance(1:arg.settingsenv.nsets*(1+arg.settingsenv.ntrialsperset)),relvalofengage(1:arg.settingsenv.nsets*(1+arg.settingsenv.ntrialsperset))); % Fit curve to behavior, esitmating the indifference point
catch
    indifference_point = 0;
end
experienced_value_forage = actualvalueforage-indifference_point;
decision_value = abs(experienced_value_forage-actualvalueaccept);
decision_difficulty = max(decision_value)-decision_value;

% Get boost and VTA for each state, as well as decision difficulty and FV
output = table(boost,VTA(:,1),VTA(:,2),FV,experienced_value_forage',actualvalueaccept',decision_value',decision_difficulty');
output.Properties.VariableNames = {'Mean_boost','Mean_VTA_action','Mean_VTA_boost','Foraging value','Experienced_foraging_value','Accept_value','Decision_value','Decision_difficulty'};
output.zscored_boost = zeros(height(output),1);
output.zscored_VTA = zeros(height(output),1);
output.stage = ones(height(output),1);
output.stage((arg.settingsenv.nsets+1):height(output)) = 2;
boosts = output.Mean_boost(output.stage==2);
zscoredboosts = zscore(boosts);
VTA = output.Mean_VTA_action(output.stage==2)+output.Mean_VTA_boost(output.stage==2);
zscoredVTA = zscore(VTA);

output.zscored_boost(output.stage==2) = zscoredboosts;
output.zscored_VTA(output.stage==2) = zscoredVTA;

output.dACC = output.zscored_boost+output.zscored_VTA;

behavior = [];
behavior.output = output;
behavior.indifference_point = indifference_point;

percieved_difference_FVacc = actualvalueforage-actualvalueaccept;

tooptimize = table(acceptance,RTmean',FV,TrueAV',TrueFV',boost,percieved_difference_FVacc');
tooptimize = tooptimize((nsets+1):(nsets*(nstatesperset+1)),:);
end