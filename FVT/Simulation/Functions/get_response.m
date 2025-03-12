function [RT,res] = get_response(Vdiff,b,optimization_pars,AccAct,s)
% Function generating a response given the difference in value (Vdiff), the
% boost (b), possible optimization parameters, the current state (s), and
% the stored values of AccAct and AccBoost. Outputs the reaction time (RT)
% and the response (res)

RT = NaN;
nactions = size(AccAct.V,2);
res = action(AccAct,s,[1:nactions],b);

% Perform DDM to generate RT and response

if optimization_pars.use_DDM ==1

[RT,res] = get_RT_DDM(Vdiff,b,optimization_pars,optimization_pars.DDM.RT_timeout);
% The DDM generates a response that is either -1 (down border reached
% first), 1 (upper border reached first), or 0 (no decision made). This has
% to be transformed into the response for foraging or engaging
if res == 0
    % No decision was made in time. As we only implement the cutoff time to
    % run the script in reasonable time, we let the DDM select a random
    % response in this case.
elseif res == 1
    % Foraging action is selected
    res = 2;
else
    % Engage action is selected
    res = 1;
end
end
end