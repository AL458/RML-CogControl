function p = get_AIC_divnorm(divnorm)
% Function for generating the AIC, optimal polynomials and the comparisons
% for the DDM

% Get the dACC values
persubj_diff = [];
persubj_diff.dACC = divnorm(:,:,3);

% Perform the analysis
p = polyfit_completeanalysis_divnorm(persubj_diff);

