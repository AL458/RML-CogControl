function p = polyfit_completeanalysis(persubj_diff)
% Performs optimal fitting of the polynomial based on the full dataset,
% estimates a statistic for the fit for both a linear, quadratic, and
% quartic funciton, and calculates the AIC

% First, persubj_diff needs to be transformed into a nparts * nbins
% structure, to be more in line with the data output from the DDM and DAN
% fitting

persubj_dACC = transformtodataoutput(persubj_diff);

% Fit the optimal linear function
stats_linear = polynomialfit(persubj_dACC,1);
% Fit the optimal quadratic function
stats_quadratic = polynomialfit(persubj_dACC,2);
% Fit the optimal quartic function
stats_quartic = polynomialfit(persubj_dACC,4);

% Compare the fits for the three fitted functions
AIC_comparison_linear_quadratic = compare_AICs(stats_linear,stats_quadratic);
AIC_comparison_linear_quartic = compare_AICs(stats_linear,stats_quartic);
AIC_comparison_quadratic_quartic = compare_AICs(stats_quadratic,stats_quartic);

p = [];
p.stats_linear = stats_linear;
p.stats_quadratic = stats_quadratic;
p.stats_quartic = stats_quartic;

p.AIC_comparison_linear_quadratic = AIC_comparison_linear_quadratic;
p.AIC_comparison_linear_quartic = AIC_comparison_linear_quartic;
p.AIC_comparison_quadratic_quartic = AIC_comparison_quadratic_quartic;


