function [W,We] = Run_training_DDM(n_training_trials,arg,seed,optimization_pars,save_subject_data,W,We)
% Modified from the RML function generating the responses for one
% simulated participant
% Runs the training for the RML-DDM. Trains the AccAct and AccBoost module
% to teach them the values of the cues and the value of boosting for each of
% the different states.

try 
    save_subject_data; 
catch
    save_subject_data = 0; 
end

%create a specific random stream for current workspace (for parallel batching)
rss = RandStream('mt19937ar','Seed',seed);
RandStream.setGlobalStream(rss);
nstate=arg.constAct.nstate;
BL=arg.BL;


arg.SEN(2:end)=randperm(max(arg.SEN));
%number of trials
NTRI=BL*length(arg.SEN);


%binary reward list
RWLIST=zeros(nstate,length(arg.RWP),NTRI);
for i=1:size(arg.RWP,2)
    for s=1:nstate
        RWLIST(s,i,1:round(arg.RWP(s,i)*NTRI))=1;
        RWLIST(s,i,:)=RWLIST(s,i,randperm(NTRI));
    end
end

%reward list magnitude
RWLISTM=zeros(size(arg.RWM,1),size(arg.RWM,2),NTRI);
for i=1:size(arg.RWM,2)
    for j=1:nstate
        RWLISTM(j,i,:)=arg.RWM(j,i)+randn(1,NTRI)*arg.var(j,i).^.5;
    end
end



%data structure storing all events
dat.s=zeros(NTRI,1); %statistical environment 1=Stat;2=Stat2;3=Vol
dat.RT=zeros(NTRI,1); %block number
dat.ttype=zeros(NTRI,1); %trial type
dat.res=zeros(1,NTRI); %response side
dat.optim=zeros(1,NTRI); %response optimality in terms of rw probability
dat.rw=zeros(1,NTRI); %reward 1=yes
dat.V=zeros(1,NTRI);
dat.V2=zeros(1,NTRI);
dat.Vpre=zeros(1,NTRI); % Before updating
dat.V2pre=zeros(1,NTRI); % Before updating
dat.meanV = zeros(1,NTRI); % Mean value
dat.meanV=zeros(1,NTRI);
dat.meanV2=zeros(1,NTRI);
dat.PE_chosen_V=zeros(1,NTRI);
dat.PE_chosen_V2=zeros(1,NTRI);
dat.PE_prechosen_V=zeros(1,NTRI);
dat.PE_prechosen_V2=zeros(1,NTRI);

dat.D=zeros(1,NTRI);
dat.D2=zeros(1,NTRI);
dat.k=zeros(nstate,NTRI);
dat.k2=zeros(nstate,NTRI);
dat.varD=zeros(nstate,NTRI);
dat.varV=zeros(1,NTRI);
dat.varV2=zeros(1,NTRI);
dat.VTA=zeros(nstate,NTRI);
dat.VTA2=zeros(nstate,NTRI);

dat.b=zeros(nstate,NTRI);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Start Experiment%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%create RML object%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AccAct=RML(nstate,arg.nactions,arg.constAct);
AccActBuff=RML(nstate,arg.nactions,arg.constAct);
AccBoost=RML(nstate,arg.nactions_boost,arg.constBoost);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%initial weights: import prior weights
AccAct.V(1:nstate,:)=W;
AccActBuff.V=AccAct.V;
AccBoost.V(1:nstate,:)=We;

trial=1;%trials counter

b=1;
mb = 1;
se = 0;
start=repmat([1:nstate],1,NTRI/nstate);
start=start(randperm(NTRI));

% Cycle through all states and boost values to ensure sufficient
% exploration
for training_trial = 1:n_training_trials
    for state = 1:nstate
        for boost = 1:size(arg.constBoost.costs,2)
            s = state;
            while s<=nstate %within trial state transitions
                if s~=state % If the state transitioned, perform a normal RML loop
                    b=action(AccBoost,s,[1:arg.nactions_boost],1);%boost selection 
                else
                    b=boost;
                end
                Vdiff = AccAct.V(s,2)-AccAct.V(s,1);        % Get the difference in value
                RT_baseline = arg.rt_baseline_DDM+optimization_pars.DDM.bias;% This line allows for optimization of the RT_baseline value, but is currently not used
                % Run the drift diffusion model
                [RT,res] = get_RT_DDM(Vdiff,b,optimization_pars,RT_baseline,arg.rt_timeout);
                % Perform some operations on res to ensure it indicates the
                % chosen option as needed by the RML
                res = -res; 
                if res == 0
                    res = 1; 
                elseif res == -1
                    res = 2; 
                end
                
                % Perform the environmental response analysis
                [opt, rw, RW, s1]=resp_analys(trial,se,mb,s,res,RWLIST,RWLISTM,arg.RWM,arg.RWP,arg.trans,arg.chance);
                
                if RT>arg.rt_timeout
                    % If the participant was too late, no reward is given
                    rw=0;
                else
                    % Otherwise, subtract the reward penalty from the
                    % possible reward to be received
                    RW = RW+(optimization_pars.rwupperlimit-RT)*optimization_pars.rwmult;
                end
                
                % Store used values
                dat.Vpre(trial) = AccAct.V(s,res);
                dat.V2pre(trial)=AccBoost.V(s,b);
                dat.meanV(trial)=mean(max(AccAct.V(1:36,:)'));
                dat.meanV2(trial)=mean(max(AccBoost.V(1:36,:)'));
                dat.PE_chosen_V(trial)=AccAct.V(s,res)-mean(max(AccAct.V(1:36,:)'));
                dat.PE_chosen_V2(trial)=AccBoost.V(s,b)-mean(max(AccBoost.V(1:36,:)'));
                dat.PE_prechosen_V(trial)=max(AccAct.V(s,:))-mean(max(AccAct.V(1:36,:)'));
                dat.PE_prechosen_V2(trial)=max(AccBoost.V(s,:))-mean(max(AccBoost.V(1:36,:)'));
    
                %%%RML learning%%%%%%
                if rw == 1
                    learn(AccAct,rw,s,s1,res,RW,b);%feedback analysis dACC_Action
                end
                learn(AccBoost,rw,s,s1,b,RW,b);%feedback analysis dACC_Boost 
                s = s1;
            end
        end
    end
end
W = AccAct.V(1:end-1,:);
We = AccBoost.V(1:end-1,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% End the experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if save_subject_data
    eval(['save W3.mat' ' W']);
    eval(['save We3.mat' ' We']);
end
end











