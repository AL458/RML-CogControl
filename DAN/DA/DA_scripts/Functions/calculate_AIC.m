function AIC_stats = calculate_AIC(ys,meandACC,semdACC,degree)
% Calculates the likelihood that the estimated mean values of the dACC
% (contained in ys) given a polynomial of degree 'degree' are true, given
% the true data meandACC and semdACC

AIC_stats = [];
AIC_stats.penalty = 2*degree+2; % # Free parameters *2

% Log likelihood calculation for each of the points in ys
AIC_stats.z_value_array = (ys-meandACC)./semdACC;
AIC_stats.p_value_array = normpdf(AIC_stats.z_value_array); % Probability of finding this value
AIC_stats.logp = log(AIC_stats.p_value_array);
AIC_stats.sumloglik = sum(AIC_stats.logp);

AIC_stats.AIC = AIC_stats.penalty - 2*AIC_stats.sumloglik;




