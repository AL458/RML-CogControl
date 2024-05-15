function [unit_TC,RT,res] = get_RT_dual_attractor_improved(difficulty,Ne,optimization_pars,rt_cutoff)%,s,arg)
% Function running the dual attractor network, yielding the reaction time,
% and response for the DAN given the difficulty, NE level, a structure of
% parameters to potentially optimize over, and the cutoff reaction time.
% Value difference determines initial bias
% NE (boost) determines the reciprocal inhibition


arg.cong_effect=optimization_pars.dualattractor.congruency_parameter;%.01;

cong = arg.cong_effect*difficulty/10; % Calculate the congruency as function of the congruency parameter and difficulty

ncycl=100;
input=[0.5+cong 0.5-cong];
unit=input;
%w = [Ne Ne]/10;
w=[Ne Ne]/10;

arg.info=optimization_pars.dualattractor.information_parameter; %.0015;
arg.ths=optimization_pars.dualattractor.threshold_parameter;%10;
arg.randstd = optimization_pars.dualattractor.randstd;
unit_TC=zeros(ncycl,2);
dt = 0.1;

count=2;

unit_TC(1,:)=input;

RT=1;
kappa = optimization_pars.dualattractor.kappa;
while max(unit)<arg.ths
  
    
    unit_temp=unit(1)+(input(1)-kappa*unit(1)-arg.info*w(1)*(unit(2)))*dt+randn(1)*arg.randstd*sqrt(dt);%
    unit(2)=unit(2)+(input(2)-kappa*unit(2)-arg.info*w(2)*(unit(1)))*dt+randn(1)*arg.randstd*sqrt(dt);%
    unit(1)=unit_temp;
    unit_TC(count,:)=unit(:);

    
    
    RT=RT+dt;
    count=count+1;
    if RT>rt_cutoff
        break
    end
    
end
% Determine response: if late, output 0. If the first unit was maximal,
% output 1, if the second unit was maximal, output 2.
if RT>rt_cutoff
    res = 0;
else
    res = 1+(max(unit_TC(:,1))<max(unit_TC(:,2)));
end

end


function a = sigm(x)

    a = exp(x)./(1+exp(x));

end