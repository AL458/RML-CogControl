%RML function
% Adapted to generates the environment structure from Vassena et al. 2020

function arg = param_build

arg.nsubj=108;
arg.nexcltri=108; % Number of trials
arg.nactions=3;%numb of possible actions by dACC_Action
arg.nactions_boost=10;%numb of possible actions by dACC_Boost

arg.rt_baseline_dualattr = 0; % minimal RT for dual attractor, in case you optimize over the parameter dualattractor.bias
arg.rt_baseline_DDM = 0;% % minimal RT for the DDM

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
arg.BL = 108;
%arg.volnum=[14,22];%min and max trials before a change point in volatility task (SE=3)
arg.constAct.DAlesion = 1;
arg.constAct.NElesion = 1;
arg.constAct.HTlesion = 1;
%reward mean magnitude and variance by SE
% State 1, 2: no difference in reward

% Set the reward magnitude matrix
c1 = sort(repmat([1:6]',6,1));
c2 = repmat([1:6]',6,1);
cdiff = c1-c2;
[~,ind] = sort(cdiff);
arg.RWM = zeros(36,6);
arg.RWM(:,1)=c1(ind)+1;
arg.RWM(:,2)=c2(ind)+1;

% Set the reward variance

arg.var = zeros(36,6);
arg.var(:,1:2)=0.05;

% Set transition matrix
arg.trans = zeros(36,2)+37;

% Generate the reward probability matrix: for all options, this probability
% is 1.
arg.RWP = zeros(36,6);
arg.RWP(:,1:2)=1;


 %number of statistical environments administered
arg.SEN=[0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];%SE*REPS;
arg.chance=0.5;%specify what is the a priori chance level to execute the task optimally
arg.chance2=0;%specify what is the a priori chance level to execute the task optimally 
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

% Generate the cost matrix: the cost for both accepting and rejecting is
% set to 0.5, while the cost for the third option is set high to avoid the
% RML selecting this option
arg.constAct.costs = repmat([.5 .5 2000],36,1);
                
arg.constAct.nstate=length(arg.trans);
arg.constBoost=arg.constAct;
arg.constBoost.costs=zeros(arg.constAct.nstate,arg.nactions_boost);
arg.constBoost.temp=0.3;
arg.constBoost.omega=0.15;


% %init value weights
% W3=zeros(arg.constAct.nstate,arg.nactions);
% We3=zeros(arg.constAct.nstate,arg.nactions_boost);

