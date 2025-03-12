function [opt, rw, RW,s1]=resp_analys(trin,se,miniblock,s,resp,rwlist,rwlistm,RWM,RWP,trans,chance)
% Function adapted from the RML
% Analyses the response, and gets the environment reward and state
% transition

if se==0 %SE 0 is stationary warmup
    se=1;
end



if resp<3 %if decides to engage in the task
    
    if se==2%if Stat2
        opt=1;%otpimality 1=yes
        rw=rwlist(s,resp+(se-1)*2,trin);
        RW=rwlistm(s,resp+(se-1)*2,trin);
    end
    
    if sum(RWM(s,resp+(se-1)*2))~=0 %if there is a primary reward in state s
        if se==1%if Stat
            if (RWM(s,resp+(se-1)*2)*RWP(s,resp+(se-1)*2))==max(RWM(s,[1:2]+(se-1)*2).*RWP(s,[1:2]+(se-1)*2))%pascalian optimum
                opt=1;%otpimality 1=yes
            else
                opt=0;
            end
            rw=rwlist(s,resp+(se-1)*2,trin);
            RW=rwlistm(s,resp+(se-1)*2,trin);
        end
        
        
        if se==3%if Vol--------------------------------------------------------------
            if sum(miniblock==[2 4])>=1%if it's the second or the fourth miniblock
                if (RWM(s,resp+(se-1)*2)*RWP(s,resp+(se-1)*2))==max(RWM(s,[1:2]+(se-1)*2).*RWP(s,[1:2]+(se-1)*2))%pasacalian optimum
                    
                    opt=1;%otpimality 1=yes
                else
                    opt=0;
                end
                
                rw=rwlist(s,resp+(se-1)*2,trin);
                RW=rwlistm(s,resp+(se-1)*2,trin);
                
            end
            
            if sum(miniblock==[1 3 5])>=1%if it's the second or the fourth or fifth
                
                resp=abs(resp-2)+1;%invert response because volatility
                
                if (RWM(s,resp+(se-1)*2)*RWP(s,resp+(se-1)*2))==max(RWM(s,[1:2]+(se-1)*2).*RWP(s,[1:2]+(se-1)*2))%pasacalian optimum (inverted due to Vol)
                    
                    
                    opt=1;%otpimality 1=yes
                else
                    opt=0;
                end
                rw=rwlist(s,resp+(se-1)*2,trin);
                RW=rwlistm(s,resp+(se-1)*2,trin);
                
            end
            
            
            
        end
        
        if rw==1%if successful transition to the next state
            s1=trans(s,resp); %transition based on transition matrix
            rw=abs(sign(RW*rw)); %check if there is primary reward 
        else%if unsuccessful transition non final state
            s1=max(max(trans));%end of trial
        end
        
    else
        
        if se==1%if Stat
            if (RWP(s,resp+(se-1)*2))==max(RWP(s,[1:2]+(se-1)*2))%pascalian optimum
                
                opt=1;%otpimality 1=yes   
                
            else
                
                opt=0;
                               
            end
            rw=rwlist(s,resp+(se-1)*2,trin);
            RW=rwlistm(s,resp+(se-1)*2,trin);
        end
        
        
        if se==3%if Vol--------------------------------------------------------------
            if sum(miniblock==[2 4])>=1%if it's the second or the fourth miniblock
                if (RWP(s,resp+(se-1)*2))==max(RWP(s,[1:2]+(se-1)*2))%pasacalian optimum
                    
                    opt=1;%otpimality 1=yes
                    
                else
                    opt=0;
                    
                end
                rw=rwlist(s,resp+(se-1)*2,trin);
                RW=rwlistm(s,resp+(se-1)*2,trin);
            end
            
            if sum(miniblock==[1 3 5])>=1%if it's the second or the fourth or fifth
                
                resp=abs(resp-2)+1;%invert response because volatility
                
                if (RWP(s,resp+(se-1)*2))==max(RWP(s,[1:2]+(se-1)*2))%pasacalian optimum (inverted due to Vol)
                    
                    opt=1;%otpimality 1=yes
                    
                else
                    opt=0;
                end
                rw=rwlist(s,resp+(se-1)*2,trin);
                RW=rwlistm(s,resp+(se-1)*2,trin);
            end
            
        end
        
        
        if rw==1%if successful transition to the next state
            s1=trans(s,resp); %transition based on transition matrix
            rw=abs(sign(RW*rw)); %check if there is primary reward 
        else%if unsuccessful transition 
            s1=max(max(trans));%end of trial
        end
        
    end
    
    
else %if decides to do not engage
    rw=0;
    RW=1;
    opt=chance;
    s1=max(max(trans));
end


end