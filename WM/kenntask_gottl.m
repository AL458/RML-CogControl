
%RML-environment interaction. Simulation of one subject (subID). Argument "arg" defines the environment
%type. Arg is generated by param_build*.m

function dat=kenntask_gottl(arg)

%Variables and data structure initialization%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%create a specific random stream for current workspace (for parallel batching)
%create a specific random stream for current workspace (for parallel batching)
rng('shuffle');%rand initialization of random generator

nstate=arg.constAct.nstate;

%miniblock length in trials (each block consists of 5 miniblocks)
Nminiblock=5;
MBLOCK=arg.volnum(1):arg.volnum(2);%miniblocks possible lengths
while sum(MBLOCK(1:Nminiblock))~=(mean(arg.volnum)*Nminiblock)% 90 trials is the length of a block
    MBLOCK=MBLOCK(randperm(length(MBLOCK)));
end
MBLOCK=MBLOCK(1:Nminiblock);



%number of miniblock in each SE
MBLN=length(MBLOCK);
%statistical environment length (each SE is made of 4 miniblocks)
BL=sum(MBLOCK);


arg.SEN(2:end)=randperm(max(arg.SEN)); %first environment is always stat0
%number of trials
NTRI=BL*length(arg.SEN);


%binary reward list
RWLIST=zeros(nstate,size(arg.RWP,2),NTRI);
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
dat.se=zeros(NTRI,1); %statistical environment 1=Stat;2=Stat2;3=Vol
dat.blck=zeros(NTRI,1); %block number
dat.ttype=zeros(NTRI,1); %trial type
dat.respside=zeros(nstate,NTRI); %response side
dat.optim=zeros(nstate,NTRI)+arg.chance2; %response optimality in terms of rw probability
dat.rw=zeros(nstate,NTRI); %reward 1=yes
dat.V=zeros(nstate,NTRI);
dat.V2=zeros(nstate,NTRI);
dat.D=zeros(nstate,NTRI);
dat.D2=zeros(nstate,NTRI);
dat.k=zeros(nstate,NTRI);
dat.k2=zeros(nstate,NTRI);
dat.varD=zeros(nstate,NTRI);
dat.varV=zeros(nstate,NTRI);
dat.varV2=zeros(nstate,NTRI);
dat.VTA=zeros(nstate,NTRI);
dat.VTA2=zeros(nstate,NTRI);
dat.rewtype=zeros(NTRI,1);
dat.F=zeros(nstate,NTRI);
dat.b=zeros(nstate,NTRI);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Start Experiment%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%create RML object%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AccAct=RMLPI(nstate,arg.nactions,arg.constAct);
AccActBuff=RMLPI(nstate,arg.nactions,arg.constAct);
AccBoost=RMLPI(nstate,arg.nactions_boost,arg.constBoost);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%initial weights
AccAct.V(1:nstate,:)=arg.W_init;
AccBoost.V(1:nstate,:)=arg.We_init;

%add noise to initial s-a values
AccAct.V(1:nstate,:)=AccAct.V(1:nstate,:)+randn(nstate,arg.nactions)*.1.*AccAct.V(1:nstate,:);
AccActBuff.V(1:nstate,:)=AccAct.V(1:nstate,:);
AccBoost.V(1:nstate,:)=AccBoost.V(1:nstate,:)+randn(nstate,arg.nactions_boost)*.1.*AccBoost.V(1:nstate,:);

trial=1;%trials counter

b=1;
H=0;


%connection matrix linear_attractor-RML
W=arg.LAmult*[1 -1];

start=repmat(1:nstate,1,round(NTRI/nstate));

start=start(randperm(length(start)));



for se=arg.SEN
    for mb=1:MBLN%miniblock counter
        for mbtri=1:MBLOCK(mb)
                

            %assign the inital state (it can be from 1 to nstate)
            s=start(trial);
            
            %reset WM for cue direction
            AccActBuff.V=AccAct.V;
            
            if s==1
                stim=randperm(2,1);
                target=randi(2,1,1);
            elseif s==2
                stim=randperm(8,4);
                target=randi(8,1,1);
            elseif s==3
                stim=randperm(12,6);
                target=randi(12,1,1);
            elseif s==4
                stim=randperm(16,8);
                target=randi(16,1,1);
            end

            while s<=start(trial) %within trial state transitions
                                                          
                %%%%%RML action selection%%%%%%
                %AccBoost.V(s,:)=mean(AccBoost.V(3:4,:),1);%boosting value is back-propagated from primary reward to the other states
                b=action(AccBoost,s,[1:arg.nactions_boost],1);%boost selection 
                  
                %%linear attractor network for detecting dots
                %%motion%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                [f,p]=FROST_param(stim);%initialize FROST network parameters
                F=FROST_sim(p,f,stim,target,b);
                
                estmov=F*W;
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
                %linear attractor netw biases RML_Act response for the next state
                %AccActBuff is a volatile memory to retain the cue
                %information
                AccActBuff.V(s,1:2)=AccAct.V(s,1:2)+estmov;
                
                    
                %%Action selection%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                res=action(AccActBuff,s,[1:arg.nactions],b);%action selection

                if sum(stim==target)==0%if mismatch
                    if res==1
                        res=2;
                    else
                        res=1;
                    end
                end

                
                %%%%%environment analyzes the response by dCC_Action and
                %%%%%provides outcome (that can be a primary reward, a state transition or both)
                [opt, rw, RW, s1]=resp_analys(trial,se,mb,s,max(max(arg.trans)),res,RWLIST,RWLISTM,arg.RWM,arg.RWP,arg.punish,arg.trans,arg.chance);
                        
                
                %%%RML learning%%%%%%
                [H,VTA]=learn(AccAct,rw,s,s1,res,RW,b,H);%dACC_Action
                [~,VTA2]=learn(AccBoost,rw,s,s1,b,RW,b,H);%dACC_Boost
                
      
                %%%record events
                dat.se(trial)=se; %statistical environment 1=Stat;2=Stat2;3=Vol
                dat.blck(trial)=mb; %block number                             
                dat.respside(s,trial)=res; %response side
                dat.optim(s,trial)=opt; %response optimality in terms of rw probability                    
                dat.rw(s,trial)=rw*RW; %reward 1=yes           
                dat.VTA(s,trial)=VTA;
                dat.VTA2(s,trial)=H;                           
                dat.V(s,trial)=AccAct.V(s,res);
                dat.V2(s,trial)=AccBoost.V(s,b);
                dat.D(s,trial)=abs(AccAct.D(s,res));
                dat.D2(s,trial)=abs(AccBoost.D(s,b));
                dat.k(s,trial)=(AccAct.k);
                dat.k2(s,trial)=(AccBoost.k);
                dat.varD(s,trial)=mean(AccAct.varD(s,res));
                dat.varK(s,trial)=mean(AccAct.varK(s,res));
                dat.varV(s,trial)=mean(AccAct.varV(s,res));
                dat.varV2(s,trial)=mean(AccAct.varV2(s,res));
                dat.b(s,trial)=b;
                dat.F(s,trial)=max(max(F));
                
             
                                
                s=s1; %update within trial state
                
                
            end
                     
            %update trial counter
            trial=trial+1;
        
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% End the experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end









