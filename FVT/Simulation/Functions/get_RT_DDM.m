function [RT,action] = get_RT_DDM(V_diff,b,optimization,RT_cutoff)
% Run the DDM as proposed by Bogacz et al. 2006
a = optimization.DDM.threshold_var/b+optimization.DDM.threshold_fix;
s = optimization.DDM.gaussian_noise;
%x_init = optimization.DDM.starting_bias;

d = V_diff*optimization.DDM.vdiff_mult;

dt = 1;
maxtime = ceil((RT_cutoff)/dt);

% Start DDM, simplified to run faster for larger a
randnormnoise = normrnd(0,s,[1,maxtime]);
sumrandnormnoise = cumsum(randnormnoise);
driftarray = repmat(d,1,maxtime);
cumulativedrift = cumsum(driftarray);
DDM_evolution = -optimization.DDM.bias_modifiable/b+dt*(sumrandnormnoise+cumulativedrift);
RT_d = min(find(abs(DDM_evolution)>a));
if isempty(RT_d) % No decision was made, even 50 ms after the response deadline
    action = 0;
    RT = RT_cutoff;
else
    action = sign(DDM_evolution(RT_d));
    RT = RT_d*dt;
end

end