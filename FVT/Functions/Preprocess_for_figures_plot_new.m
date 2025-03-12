function output = Preprocess_for_figures_plot_new()

% Load simulated data
load("Fulloutput.mat")

% Acceptance
subjbased = grpstats(fulltable,{'Subject_ID';'relative_forage_value'});
acc = grpstats(subjbased,'relative_forage_value','mean','DataVars','mean_accept');
accsort = sortrows(acc,"mean_mean_accept");
accsort.accept = accsort.mean_mean_accept;

% Attempt several different normalization strategies
original_table = fulltable;

% Run divisive normalization

fulltable(isnan(fulltable.bin_diff),:) = []; % Get rid of all non-stage 1 trials
normtable = fulltable;
normtable.Boost = Divnorm(normtable.Boost,normtable.Subject_ID);
normtable.Value = Divnorm(normtable.Value,normtable.Subject_ID);
normtable.dACC = normtable.Boost+normtable.Value;

varnames = normtable.Properties.VariableNames;
varnames(strcmp(varnames,'Subject_ID'))=[];
varnames(strcmp(varnames,'bin_FV'))=[];

% Average over bins
normtable_FVavg = grpstats(normtable,{'Subject_ID','bin_FV'});
normtable_FVavg.GroupCount = [];
normtable_FVavg.Properties.VariableNames(3:end) = varnames;

varnames = normtable_FVavg.Properties.VariableNames;
varnames(strcmp(varnames,'bin_FV'))=[];
data.fulltable_FV = normtable_FVavg;

normtable_FVavg.Subject_ID = [];
% Average over subjs
normtable_FVsubj = grpstats(normtable_FVavg,{'bin_FV'},{'mean','sem'});
normtable_FVsubj.GroupCount = [];

data.normtable_FVsubj = normtable_FVsubj;


normtable = fulltable;
normtable.Boost = Divnorm(normtable.Boost,normtable.Subject_ID);
normtable.Value = Divnorm(normtable.Value,normtable.Subject_ID);
normtable.dACC = normtable.Boost+normtable.Value;

varnames = normtable.Properties.VariableNames;
varnames(strcmp(varnames,'Subject_ID'))=[];
varnames(strcmp(varnames,'bin_diff'))=[];

% Average over bins
normtable_diffavg = grpstats(normtable,{'Subject_ID','bin_diff'});
normtable_diffavg.GroupCount = [];
normtable_diffavg.Properties.VariableNames(3:end) = varnames;

varnames = normtable.Properties.VariableNames;
varnames(strcmp(varnames,'bin_diff'))=[];
data.fulltable_diff = normtable_diffavg;

normtable_diffavg.Subject_ID = [];
% Average over subjs
normtable_diffsubj = grpstats(normtable_diffavg,{'bin_diff'},{'mean','sem'});
normtable_diffsubj.GroupCount = [];

data.normtable_diffsubj = normtable_diffsubj;
output = data;

end