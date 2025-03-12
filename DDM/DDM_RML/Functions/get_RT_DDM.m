function [RT,action] = get_RT_DDM(V_diff,b,optimization,RT_cutoff)
% Function for running the DDM as proposed by Bogacz et al. 2006

% Implement the interface between the RML and DDM
a = optimization.DDM.threshold_var/b+optimization.DDM.threshold_fix;
s = optimization.DDM.gaussian_noise;

% Calculate the drift rate
d = V_diff*optimization.DDM.vdiff_mult;

dt = 0.01;
maxtime = ceil((RT_cutoff)/dt);

% Rather than running the DDM in a step-by-step fashion, simulate the DDM
% from the start of the trial until the end of the trial, and check the
% first-pass time. This should speed up computational time for large
% threshold values (a)
randnormnoise = normrnd(0,s,[1,maxtime]);
% Generate a vector of cumulative random noise and cumulative fixed drift
sumrandnormnoise = cumsum(randnormnoise);
driftarray = repmat(d,1,maxtime);
cumulativedrift = cumsum(driftarray);
% Add these together and multiply by dt to get the DDM time evolution,
% unconstrained by the threshold
DDM_evolution = dt*(sumrandnormnoise+cumulativedrift);
% Find the first-pass time, and ignore everything after the first-pass time
RT_d = min(find(abs(DDM_evolution)>a));
if isempty(RT_d) % No decision was made, even 50 ms after the response deadline
    action = 0;
    RT = RT_cutoff+50;
else % If a decision is made, output the made decision and the RT
    action = sign(DDM_evolution(RT_d));
    RT = RT_d*dt;
end


end