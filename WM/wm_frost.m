%WM dynamics based on FROST model (Ashby et al., 2005)

function [F,P]=wm_frost(F,P,U,p,f,LC,Att)

    LC_att=Att;
    
 
    %parietal neurons
        P=P+p.alpha*U.*(1-P)+p.beta*F.*(1-P)-p.gamma*P;

    %frontal neurons
        F=F+(f.alpha*LC_att+f.beta*P).*(1-F)-(f.delta/LC).*sum(F).*(F)-f.gamma*F;
    
    
%     F=F*LC;

end