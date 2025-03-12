function envgenerated = Generate_environment(settingsenv)
% Generates the environment using the settings as determined by
% param_build_FVT. Generates all possible sets of states for the rewards
% indicated, and selects an indicated number of sets from these sets
% equally spaced based on the percentile of the foraging value.

% Extract the relevant parameters 
nsets = settingsenv.nsets; % The number of different foraging sets
ntrialsperset = settingsenv.ntrialsperset; % The number of states each set has
rewardmin = settingsenv.rewardrange(1); % The minimal reward an engage option provides
rewardmax = settingsenv.rewardrange(2); % The maximal reward an engage option provides
possiblerewards = settingsenv.numberofrewardcues; % The number of different possible rewards for engage options

rewardspossiblyadded = linspace(rewardmin,rewardmax,possiblerewards); % Generates all possible rewardsd

subsetmat = nchoosek(rewardspossiblyadded,ntrialsperset); % Generates a matrix containing all possible foraging sets

subsetmat(:,ntrialsperset+1) = mean(subsetmat'); % Add the foraging value for each of these sets


% Sort the foraging sets by their foraging value
[~,inds] = sort(subsetmat(:,end));
subsetmat_sorted = subsetmat(inds,:);

% Select a number of foraging sets to be used in the environment, that are
% equidistant in terms of the percentile of foraging value

subsetstouse = round(linspace(1,height(subsetmat_sorted),nsets));

% Generate environments. Each set contains 17 states:
% - one general state for the foraging value, representing the moment the
%   possible cues are shown to the agent
% - eight different possible cues that the agent can choose to engage with,
%   or choose to forage
% - eight different cues representing the moment the agent engaged with the
%   task.
% In the environment, these states are ordered by type.
% No rewards are given in the first two types, only during the third type.

ntrialstotal = nsets+nsets*ntrialsperset*2; 
RWM = zeros(ntrialstotal,2);

% Set the values for the second type
RWM(nsets+1:nsets+nsets*ntrialsperset,2) = settingsenv.foragepunishment;
RWP = ones(ntrialstotal,2);
RWP(nsets+1:nsets+nsets*ntrialsperset,2) = settingsenv.foragepunprob;
RWname = zeros(ntrialstotal,1);
foragevalue = zeros(ntrialstotal,1);
counter = 1+nsets;
shift = nsets*ntrialsperset;
% Set the values for the third type
for env = 1:nsets
    % Generate single environment
    subset_current = subsetmat_sorted(subsetstouse(env),1:(end-1));
    fvcurrent = subsetmat_sorted(subsetstouse(env),end);
    for trialtoadd = 1:ntrialsperset
        RWM(counter+shift,1)=subset_current(trialtoadd); % Add the reward to the corresponding trial of the third type
        RWM(counter+shift,2) =subset_current(trialtoadd)+rand()-0.5; % Other option is similar in value compared to option 1
        foragevalue(counter) = fvcurrent; % Theoretical foraging value
        RWname(counter) = trialtoadd; % Store the numerical order of the current reward compared to all other rewards in this set
        counter = counter+1;
    end
end
env =[];
env.RWM = RWM;
env.RWP = RWP;
env.RWname = RWname;
env.foragevalue = foragevalue;
envgenerated = env;

end