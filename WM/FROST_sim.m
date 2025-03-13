%script to build and plot FROST modulation by LC activity

function match=FROST_sim(p,f,stim,target,lc)


%initialize neural units
P=zeros(1,f.ncouple);
F=zeros(1,f.ncouple);
U=zeros(1,f.ncouple);
Att=zeros(1,f.ncouple);
recF=zeros(f.ncouple,f.max_time);


    
    f.gamma=f.gamma0;
    
    for tritime=1:f.max_time
        
        if (tritime>=p.phase_delay2)&&(tritime<p.phase_delay2+p.vstimd)%visual imput for the first n steps
            
            U(stim)=1;%half of visual units are activated (stimuli onset)
            Att=U*5;%attentional signal on
            
        elseif (tritime>p.phase_delay-p.vstimd)&&(tritime<=p.phase_delay)
            
            U(target)=1;%one visual unit is activated (target onset)
            recF(:,tritime)=F;
            
        else
            U=zeros(1,f.ncouple);%visual units off
        end
        
        if (tritime>p.phase_delay)
            
            Att=zeros(1,f.ncouple);%attentional signal off
            
        end
         
        [F,P]=wm_frost(F,P,U,p,f,1,Att);
        
        
    end

recF(:,recF(target(1),:)==0)=[];

recF=max(recF,[],2);



match=lc*max(recF)-f.wmthr1;
% match(2)=max(0,mean(recF)-f.wmthr2);

% match=mean(recF(recF>0))-f.wmthr1;

% match=sign(max(recF)-mean(recF))
    
    
    