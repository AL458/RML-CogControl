function pAIC = compare_AICs(val1,val2)
% Function for comparing the AIC values, calculating the aikake weights for
% both options

AIC_value_1 = val1.AIC_stats.AIC;
AIC_value_2 = val2.AIC_stats.AIC;

% Get dAIC values

dAIC_1_pos = AIC_value_1-min(AIC_value_2,AIC_value_1);
dAIC_2_pos = AIC_value_2-min(AIC_value_2,AIC_value_1);

w_AIC_1_pos = exp(-.5*dAIC_1_pos)/(exp(-.5*dAIC_1_pos)+exp(-.5*dAIC_2_pos));
w_AIC_2_pos = exp(-.5*dAIC_2_pos)/(exp(-.5*dAIC_1_pos)+exp(-.5*dAIC_2_pos));

p_AIC_1 = w_AIC_1_pos/(w_AIC_1_pos+w_AIC_2_pos);
p_AIC_2 = w_AIC_2_pos/(w_AIC_1_pos+w_AIC_2_pos);

pAIC = [p_AIC_1,p_AIC_2];

end