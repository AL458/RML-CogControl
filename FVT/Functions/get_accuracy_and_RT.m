function [fullavgs] = get_accuracy_and_RT(totaloptimization)
% Split the RT and accuracy data into 8 bins for plotting    

% For each participant, split the data into 8 bins
subjs = unique(totaloptimization.Subject_ID);
for s = 1:length(subjs)
    currsubj = subjs(s);
    currtable = totaloptimization(totaloptimization.Subject_ID==currsubj,:);
    relforvals = currtable.Relative_forage_value;
    sortedvals = sort(relforvals);
    cutoffs = sortedvals([(1:7)*ceil(length(sortedvals)/8)]);
    binnr = sum(relforvals>cutoffs',2)+1;
    currtable.bin = binnr;
    % Get average per bin
    binnedtable = grpstats(currtable,"bin","mean","DataVars",["Acceptance";"RT";"Relative_forage_value"]);
    binnedtable.GroupCount = [];
    binnedtable.Properties.VariableNames = {'Bin','Acceptance','RT','Relative_FV'};
    if s == 1
        fullbinnedmat = binnedtable{:,:};
    else
        fullbinnedmat = vertcat(fullbinnedmat,binnedtable{:,:});
    end
end
fullbinnedtable = array2table(fullbinnedmat);
fullbinnedtable.Properties.VariableNames = {'Bin','Acceptance','RT','Relative_FV'};
% Calculate the acceptance and RT
fullbinnedtable.zscoredRT = zscore(fullbinnedtable.RT);
fullavgs = grpstats(fullbinnedtable,"Bin",["mean","sem"],"DataVars",["Acceptance";"RT";"Relative_FV"]);


end