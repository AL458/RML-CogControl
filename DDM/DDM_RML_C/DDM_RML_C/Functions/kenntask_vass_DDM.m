function dat = kenntask_vass_DDM(subID,arg,seed,optimization_pars,save_subject_data,W,We)
% RML-environment interaction. Runs the task for one participant. Uses the
% subject ID, the arg parameter as defined by param_build, allows for
% setting a seed for the randomization, uses the optimization pars, a
% variable indicating whether to save the subject data, and the prior value
% for the actions (W) and boost (We). If any of the last three are not
% supplied, set the data to their defaults

try 
    save_subject_data; 
catch
    save_subject_data = 0; 
end


%Variables and data structure initialization%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%create a specific random stream for current workspace (for parallel batching)
rss = RandStream('mt19937ar','Seed',seed);
RandStream.setGlobalStream(rss);

nstate=arg.constAct.nstate;

% Get the block length
BL=arg.BL;

% Shuffle all blocks
arg.SEN(2:end)=randperm(max(arg.SEN)); %first environment is always stat0
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
dat.V=zeros(1,NTRI); % Reward experienced by the action module
dat.V2=zeros(1,NTRI); % Reward experienced by the boost module
dat.Vpre=zeros(1,NTRI); % Action value before updating
dat.V2pre=zeros(1,NTRI); % Boost value before updating
dat.meanV = zeros(1,NTRI); % Mean value action module 
dat.meanV2=zeros(1,NTRI); % Mean value boost module 
dat.PE_chosen_V=zeros(1,NTRI);
dat.PE_chosen_V2=zeros(1,NTRI);
dat.PE_prechosen_V=zeros(1,NTRI);
dat.PE_prechosen_V2=zeros(1,NTRI);

dat.D=zeros(1,NTRI); % Kalman filter prediction error matrix for the action module
dat.D2=zeros(1,NTRI); % Kalman filter prediction error matrix for the boost module
dat.k=zeros(nstate,NTRI);  % KG value for the action module
dat.k2=zeros(nstate,NTRI); % KG value for the boost module
dat.varD=zeros(nstate,NTRI); % Kalman filter prediction error variance for the action module
dat.varV=zeros(1,NTRI);% Kalman filter value variance for the action module
dat.varV2=zeros(1,NTRI);% Kalman filter value variance for the boost module
dat.VTA=zeros(nstate,NTRI);% Reward experienced by the action module
dat.VTA2=zeros(nstate,NTRI);% Reward experienced by the boost module

dat.b=zeros(nstate,NTRI);% Boost value 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Start Experiment%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%create RML object%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AccAct=RML(nstate,arg.nactions,arg.constAct);
AccActBuff=RML(nstate,arg.nactions,arg.constAct);
AccBoost=RML(nstate,arg.nactions_boost,arg.constBoost);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%initial weights
AccAct.V(1:nstate,:)=W;
AccActBuff.V=AccAct.V;
AccBoost.V(1:nstate,:)=We;

trial=1;%trials counter

b=1;
mb = 1;

start=repmat([1:nstate],1,NTRI/nstate);
start=start(randperm(NTRI));


for se=arg.SEN
    for tri = 1:BL            
        %RML initialization
        if se==0 %if training
            AccAct.lesion=1;
            AccBoost.lesion=1;
        else
            AccAct.costs=arg.constAct.costs;
            AccAct.lesion=arg.constAct.lesion;
            AccBoost.lesion=arg.constBoost.lesion;
        end
        
        s=start(trial);%start trial from state s
        
        while s<=nstate %within trial state transitions
                                                      
            %%%%%RML action selection%%%%%%
            b=action(AccBoost,s,[1:arg.nactions_boost],1);% first select the boost value 
            Vdiff = AccAct.V(s,2)-AccAct.V(s,1); % Calculate the difficulty by estimating the value difference
            [RT,res] = get_RT_DDM(Vdiff,b,optimization_pars,arg.rt_timeout); % Perform DDM
            % Transform the res variable to correspond to the correct
            % action in the RML
            res = -res;
            if res == 0
                res = 1;
            elseif res == -1
                res = 2;
            end

   
            %%%%%environment analyzes the response by dCC_Action and
            %%%%%provides outcome (that can be a primary reward, a state transition or both)
            [opt, rw, RW, s1]=resp_analys(trial,se,mb,s,res,RWLIST,RWLISTM,arg.RWM,arg.RWP,arg.trans,arg.chance);
            
            if RT>arg.rt_timeout
                % If the participant is too late, set reward to 0
                rw=0;
            else
                % Otherwise, subtract the penalty from the reward
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
                [H,VTA]=learn(AccAct,rw,s,s1,res,RW,b,0);%feedback analysis dACC_Action
            end
            [H,VTA]=learn(AccBoost,rw,s,s1,b,RW,b,H);%feedback analysis dACC_Boost 
  
            %%%record events
            dat.s(trial)=s; %statistical environment 1=Stat;2=Stat2;3=Vol
            dat.res(trial)=res; %response side
            dat.RT(trial)=RT;
            dat.optim(trial)=opt; %response optimality in terms of rw probability                    
            dat.V(trial)=AccAct.V(s,res);
            dat.V2(trial)=AccBoost.V(s,b);
            dat.D(trial)=abs(AccAct.D(s,res));
            dat.D2(trial)=abs(AccBoost.D(s,b));
            dat.b(trial)=b;               
            s=s1; %update within trial state

        end
                 
        %update trial counter
        trial=trial+1;
    
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% End the experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if save_subject_data
    eval(['save Output/DDM_S' num2str(subID) ' dat']);
end
end









