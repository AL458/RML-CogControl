function p = get_AIC(outputtable)
% Function for getting the AIC value given the output

persubj = grpstats(outputtable,{'Subject_ID','State'},'mean','DataVars',{'Boost','Value','Difficulty_bin'});
persubj.GroupCount = [];
persubj.Properties.VariableNames = {'Subject_ID','State','Boost','Value','Difficulty_bin'};

% Z-scoring
persubj.zscoreboost = persubj.Boost;
persubj.zscorevalue = persubj.Value;

nsubjs = max(persubj.Subject_ID);

for subj = 1:nsubjs
    persubj.zscoreboost(persubj.Subject_ID==subj) = zscore(persubj.zscoreboost(persubj.Subject_ID==subj));
    persubj.zscorevalue(persubj.Subject_ID==subj) = zscore(persubj.zscorevalue(persubj.Subject_ID==subj));
end

persubj_diff = grpstats(persubj,{'Subject_ID','Difficulty_bin'},'mean','DataVars',{'zscoreboost','zscorevalue'});
persubj_diff.GroupCount = [];
persubj_diff.Properties.VariableNames = {'Subject_ID','Difficulty_bin','zscoreboost','zscorevalue'};
persubj_diff.dACC = persubj_diff.zscoreboost+persubj_diff.zscorevalue;

p = polyfit_completeanalysis(persubj_diff);

