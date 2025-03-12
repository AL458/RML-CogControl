function p = get_AIC_divnorm(divnorm)
% Function for generating the AIC

persubj_diff = [];
persubj_diff.dACC = divnorm(:,:,3);

p = polyfit_completeanalysis_divnorm(persubj_diff);

