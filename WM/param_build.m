%write down parameters data structure from Gersch et al., 2015

function arg = param_build(param_set,RWM,btemp,nrep)

arg.nsubj=nrep;
arg.initstate=1;
arg.nexcltri=160;
arg.nactions=3;%numb of possible actions by dACC_Action
arg.nactions_boost=10;%numb of possible actions by dACC_Boost

arg.constAct.DAlesion=1;%DA lesion, 1=no lesion,0=shutdown;
arg.constAct.NElesion=1;
arg.constAct.RW=param_set(1);%NE lesion, 1=no lesion, 0=shutdown; Engagement
arg.constAct.hlesion=param_set(2);%parameter modulating the weigth of information gain
arg.constAct.HTlesion=param_set(3);%param_set(2);%5HT lesion, 1=no lesion, 2=half 5HT;
arg.constAct.gamma=param_set(4);%NE lesion, attention


cost2=.2;%param_set(2);


arg.punish=0; %in case of error, punishment is x% of primary reward magnitude

arg.pred=2;%defines whether dots cloud is a predictive cue (only for Gottlieb's study); 2=pred, 0=nopred;

arg.LAmult=50;

RWM=RWM*param_set(1);

arg.HR=RWM(1);%HR magnitude
arg.LR=RWM(2);%LR magnitude

arg.volnum=[14,22];%min and max trials before a change point in volatility task (SE=3)

%reward mean magnitude and variance by SE
arg.RWM=[RWM(1) RWM(1) 0 0 0 0
         RWM(1) RWM(1) 0 0 0 0
         RWM(1) RWM(1) 0 0 0 0
         RWM(1) RWM(1) 0 0 0 0];

arg.var=[0 0 0 0 0 0
         0 0 0 0 0 0
         0.0 0.0 0 0 0 0
         0.0 0.0 0 0 0 0];
     %state-action transitions (4=end of trial)

arg.trans=[5 5
           5 5
           5 5
           5 5];

%reward prob by SE
arg.RWP=[1 0 0 0 0 0
         1 0 0 0 0 0
         1 0 0 0 0 0
         1 0 0 0 0 0];
 
 %number of statistical environments administered
arg.SEN=[1 1 1 1 1 1];%SE*REPS;
arg.chance=0.5;%specify what is the a priori chance level to execute the task optimally
arg.chance2=0;%specify what is the a priori chance level to execute the task optimally 
%(if prob is referred to completing the task, then 0, otherwise it refers to the prob of answering correclty to each state within a trial)

arg.constAct.temp=0.6;%temperature
arg.constAct.k=0.3;%initial kalman gain;
arg.constAct.mu=0.1;
arg.constAct.omega=0;
arg.constAct.alpha=0.6;
arg.constAct.eta=0.01;
arg.constAct.beta=1;
arg.constAct.gamma=arg.constAct.gamma;
arg.constAct.classic=0;

arg.constAct.costs=[cost2 cost2 0
                    cost2 cost2 0
                    cost2 cost2 0
                    cost2 cost2 0];
                
arg.constAct.nstate=max(max(arg.trans))-1;
arg.constBoost=arg.constAct;
arg.constBoost.costs=zeros(arg.constAct.nstate,arg.nactions_boost);
arg.constBoost.temp=btemp;
arg.constBoost.omega=0.15*arg.constAct.HTlesion;

%init value weights
arg.W_init=[0 0 0
    0 0 0
    0 0 0
    0 0 0];


arg.We_init=[1.0000    0.8500    0.7000    0.5500    0.4000    0.2500    0.1000   -0.0500   -0.2000   -0.3500
    1.0000    0.8500    0.7000    0.5500    0.4000    0.2500    0.1000   -0.0500   -0.2000   -0.3500
    1.0000    0.8500    0.7000    0.5500    0.4000    0.2500    0.1000   -0.0500   -0.2000   -0.3500
    1.0000    0.8500    0.7000    0.5500    0.4000    0.2500    0.1000   -0.0500   -0.2000   -0.3500];

