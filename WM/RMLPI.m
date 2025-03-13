%Reinforcement Meta-Learner (RML) class, by massimo silvetti. cf. Silvetti
%et al., 2018. massimo.silvetti@istc.cnr.it
%

classdef RMLPI < handle
    
    properties
        W  %weight matrix
        k %kalman gain
        Temp %temperature
        V  %state-value vector
        D  %prediction error
        HO  %state vector
        p; %option probability for softmax
        res;  %option value
        varD;
        varV;
        varK;
        varV2;
        %meta-parameters for K filtering
        alpha
        beta
        eta
        mu
        omega
        gamma
        DAlesion
        NElesion
        HTlesion
        hlesion
        costs
        nstate
        
    end
    
    methods
        
        function obj=RMLPI(s,a,const)%alpha,beta,eta,mu,omega,gamma,lesion)
            
            obj.k=const.k;
            obj.alpha=const.alpha;
            obj.beta=const.beta;
            obj.eta=const.eta;
            obj.Temp=const.temp;
            obj.gamma=const.gamma;
            obj.omega=const.omega;
            
            obj.V=zeros(s+1,a);
            obj.V(s+1,:)=0;
            obj.V(:,3)=0;
            obj.costs=const.costs;
            
            obj.D=zeros(s,a);
            obj.varK=zeros(s,a)+0.3;
            obj.varD=zeros(s+1,a);
            obj.varV=zeros(s,a)+0.1;
            obj.varV2=zeros(s,a)+0.5;
            obj.mu=const.mu;
            obj.DAlesion=const.DAlesion;
            obj.NElesion=const.NElesion;
            obj.HTlesion=const.HTlesion;
            obj.hlesion=const.hlesion;
            obj.nstate=s;
                       
        end
        
        
        function resp=action(obj,s,a,b)%action selection
            
            a=a';

            obj.p=zeros(1,length(a));
            
            obj.res=obj.V(s,a)-obj.costs(s,a)./(b*obj.NElesion);
            
            for i=1:length(a)
            
                obj.p(i)=exp(obj.res(i)/obj.Temp)/(sum(exp(obj.res/obj.Temp))); %p of selecting option 2
            
            end
               
            resp=randsample(a,1,true,obj.p);%select response
                  
        end
        
        function p_resp=action_eval(obj,s,a,b,resp)%action selection
            
            a=a';

            obj.p=zeros(1,length(a));
            
            obj.res=obj.V(s,a)-obj.costs(s,a)./(b*obj.NElesion);%max([b*obj.NElesion,1]);
            
            for i=1:length(a) 
            
                obj.p(i)=exp(obj.res(i)/obj.Temp)/(sum(exp(obj.res/obj.Temp))); %p of selecting option 2
            
            end
               
            p_resp=obj.p(a==resp);
                  
        end
        
        function PI_eval(obj,b,sinit)%policy evaluation
            
            %policy evaluation as a path integral of discounted value
            VPI_buff=[0 0];
            merg=0;
             %policy run simulation
             for pi =1:length(VPI_buff) %for each policy
                 s=sinit;%set init state
                 t=1;%set time step
                 while s<=obj.nstate%until terminal state
                     if merg==0
                        VPI_buff(pi)=VPI_buff(pi)+obj.V(s,obj.PI(pi,t))-(obj.costs(s,obj.PI(pi,t))./(b*obj.NElesion));%sum net Q values
                     else
                        VPI_buff(pi)=VPI_buff(pi)+mean(obj.V(4:5,obj.PI(pi,t)),1)-(obj.costs(s,obj.PI(pi,t))./(b*obj.NElesion));%sum net Q values
                     end
                     if s==2 && pi==1
                         merg=1;
                     else    
                         merg=0;
                     end
                     
                     s=obj.trans(s,obj.PI(pi,t));%update state by trans matrix
                     
                     t=t+1;%scroll time
                 end
             end

               obj.VPI(sinit,:)=VPI_buff;

        end
        
        function [resp,p]=PI_select(obj,sinit)%policy selection
            
           
            obj.p=zeros(1,length(obj.VPI(sinit,:)));
            
            obj.res=obj.VPI(sinit,:);
            
            
            for i=1:length(obj.VPI(sinit,:)) 
            
                obj.p(i)=exp(obj.res(i)/obj.Temp)/(sum(exp(obj.res/obj.Temp))); %p of selecting option 2
            
            end
               
            resp=randsample([1:length(obj.VPI(sinit,:))],1,true,obj.p);%select response
            p=obj.p(1);
                  
        end
        
        
        function [H,VTA]=learn(obj,rw,s,s1,resp,RW,b,H)%outcome analysis and learning           
            
            
            if obj.omega==0 %if it's ACC Action
               H=tanh((obj.varD(s,resp)))*abs(sign(RW));%compute estimated entropy
               R=rw*(RW+(obj.mu*b))-obj.hlesion*H;%primary reward boost modulation
               VTA=obj.DAlesion*(R+(1-obj.mu)*b*obj.gamma*max(obj.V(s1,:)));
               obj.D(s,resp)=VTA-obj.V(s,resp); %TD learning for Action
                          
               
            else %if it's ACC Boost
                
               R=obj.DAlesion*(rw*RW)-obj.HTlesion*obj.omega*b-obj.DAlesion*obj.hlesion*H;%primary reward boost cost
               VTA=R+obj.DAlesion*max(obj.V(s1,:));
               obj.D(s,resp)=VTA-obj.V(s,resp); %TD learning for Boost
               
            end
            
            
            
            if isnan(resp)
                obj.k
            end
                
            %approximate Kalman
                obj.varD(s,resp)=obj.varD(s,resp)+obj.alpha*(abs(obj.D(s,resp))-obj.varD(s,resp));%overall variance 
          
                obj.varV2(s,resp)=obj.varV2(s,resp)+obj.alpha*((obj.V(s,resp))-obj.varV2(s,resp));%value estimation 
                
                obj.varV(s,resp)=((obj.V(s,resp))-obj.varV2(s,resp)).^2./(obj.varD(s,resp).^2);%value estimation variance/overall variance 
                
                if isnan(obj.varV(s,resp)) || obj.varV(s,resp)<0
                   obj.varV(s,resp)=0;
                elseif isinf(obj.varV(s,resp)) || obj.varV(s,resp)>1
                   obj.varV(s,resp)=1;
                elseif obj.varD(s,resp)==0
%                    obj.varV(s,resp)=0;
                end
                         
                obj.varK(s,resp)=obj.varV(s,resp); % obj.varK(s,resp)
                            
                obj.k=obj.beta*((mean(obj.varK(s,:))));%LR 
                
                %keep 1 >= k >= eta for numerical stability 
                if obj.k>1
                    obj.k=1;
                elseif obj.k<obj.eta
                    obj.k=obj.eta;
                end
                                   
                obj.V(s,resp)=obj.V(s,resp)+(obj.k)*obj.D(s,resp);%value update                                  
        end 
    end
end
            
            
