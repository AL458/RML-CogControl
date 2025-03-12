function stats = polynomialfit(persubj_dACC,degree)
% Generates the best fitting function, with degree equal to the input
% variable degree

% As the matlab function polyfit is unable to handle data where multiple
% points have the same x-value, perturb the x-values of all points by an
% extremely small amount. The amount perturbed is randomly drawn from a
% normal distribution with mean 0 and standard deviation 1, multiplied by
% epsilon.
epsilon = 10^-200; 

[nparts,nbins] = size(persubj_dACC);

diffinds = repmat([1:nbins],nparts,1);
% Reshape the dataset into a vector
persubj_dACC_reshaped = reshape(persubj_dACC,[],1);
diffinds_reshaped = reshape(diffinds,[],1);
diffinds_reshaped = diffinds_reshaped+randn(size(diffinds_reshaped))*epsilon; % Add small random noise for fitting with matlab

% Run polyfit to get the best fitting polynomial

[poly,stats_poly] = polyfit(diffinds_reshaped,persubj_dACC_reshaped,degree);

% Calculate the R squared value of the polynomial: the variance explained

R_squared = 1 - (stats_poly.normr/norm(persubj_dACC_reshaped - mean(persubj_dACC_reshaped)))^2;

% Estimate polynomial values
ys = zeros(1,nbins);
for i = 0:degree
    ys = ys+poly(end-i)*([1:nbins].^i);
end

R_corr = corrcoef(ys(diffinds_reshaped),persubj_dACC_reshaped);
R2_corr = R_corr(1,2)^2;

meandACC = mean(persubj_dACC);
semdACC = std(persubj_dACC)./sqrt(nparts);

% Get Rsquared values for the mean
R_corr_mean = corrcoef(ys,meandACC);
R2_corr_mean = R_corr_mean(1,2)^2;

% Calculate the AIC stats

AIC_stats = calculate_AIC(ys,meandACC,semdACC,degree);

% Store the output in a strucutre 'stats'

stats.poly = poly;
stats.estimate = ys;
stats.stats = stats_poly;
stats.AIC_stats = AIC_stats;
stats.R2_individual_subjectmean = [R_squared,R2_corr];
stats.R2_data_mean = R2_corr_mean;

end