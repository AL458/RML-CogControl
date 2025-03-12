function arg = param_build_FVT(optimization_pars)

arg.nactions=2;%number of possible actions by dACC_Action
arg.nactions_boost=10;%number of possible actions by dACC_Boost

arg.rt_timeout=2000;%maximal RT in ms. While there is not a timeout in this task, we need this to avoid the script from running indefinately

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
arg.constAct.DAlesion = 1;
arg.constAct.NElesion = 1;
arg.constAct.HTlesion = 1;

% Generate the environment
settingsenv = [];


% Read the minimum and maximum reward options
minreward = optimization_pars.lowvalue; % Minimal reward to be earned during the task
maxreward = optimization_pars.highvalue;

nsets = 16; % Generate 16 'sets' of trials, each representing one set which the forage option selects from
settingsenv.nsets = nsets;
ntrialsperset = 8; % Each set consists of 8 different valued cues
settingsenv.ntrialsperset = ntrialsperset;
settingsenv.numberofrewardcues = 12; % In total, 12 cues are available to the subjects
settingsenv.rewardrange = [minreward maxreward];
settingsenv.foragecost = optimization_pars.cost;
settingsenv.banditcost = optimization_pars.banditcost;
settingsenv.foragepunishment = -.1; % Punishment when foraging. Not used in the current version
settingsenv.foragepunprob = .7; % Probability of punishment when foraging. Not used in the current version

envgenerated = Generate_environment(settingsenv); % Function for generating the rewards earned in the environment

arg.BL = nsets*ntrialsperset*2; % Each block has two of each trial

RWM = envgenerated.RWM;
arg.RWM = RWM;
arg.RWname = envgenerated.RWname;
arg.settingsenv = settingsenv;
arg.foragevalue = envgenerated.foragevalue;

arg.var = zeros(size(RWM));
arg.var(:,1:2)=0.05;

arg.trans = zeros(size(RWM)); % Transition is performed by different function

arg.RWP = zeros(size(RWM));
arg.RWP(:,1:2)=1;
arg.RWP(nsets+1:nsets+nsets*ntrialsperset,2) =settingsenv.foragepunprob; % Not in use currently


 %number of statistical environments administered
arg.SEN=[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];%SE*REPS;
%(if prob is referred to completing the task, then 0, otherwise it refers to the prob of answering correclty to each state within a trial)

arg.constAct.temp=.6;%temperature
arg.constAct.k=0.3;%initial kalman gain;
arg.constAct.mu=0.1;
arg.constAct.omega=0;
arg.constAct.alpha=0.3;
arg.constAct.eta=0.15;
arg.constAct.beta=1;
arg.constAct.gamma=0.2;
arg.constAct.classic=0;

arg.constAct.lesion=1;%DA lesion, 1=no lesion;

arg.constAct.costs = repmat([.5 .5 10000],length(arg.RWM),1); % Sets costs for all actions equal
arg.constAct.costs((1+nsets):(nsets*ntrialsperset+nsets),:) = repmat([.5 .5+settingsenv.foragecost 10000],nsets*ntrialsperset,1); % Foraging has an additional cost
arg.constAct.costs((1+nsets+nsets*ntrialsperset):(end),:) = repmat([.5+settingsenv.banditcost .5 10000],nsets*ntrialsperset,1); % Recieving reward durign the second part has an additional cost 
arg.constAct.costs(1:nsets,:) = repmat([.5 10000 10000],nsets,1); % Allow only action 1 when selecting the random trial 

arg.constAct.nstate=length(arg.trans);
arg.constBoost=arg.constAct;
arg.constBoost.costs=zeros(arg.constAct.nstate,arg.nactions_boost);
arg.constBoost.temp=0.3;
arg.constBoost.omega=0.15;



