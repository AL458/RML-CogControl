function opttable = mean_optimization(foroptimization)
% Generates a single table from the provided input which contains the full
% data ordered as one subject per cell

for s = 1:length(foroptimization)
    if s == 1
        opttable = foroptimization{s};
        subjID = ones(height(foroptimization{s}),1);
    else
        opttable = vertcat(opttable,foroptimization{s});
        subjID = vertcat(subjID,ones(height(foroptimization{s}),1)*s);
    end
end
opttable.subjID = subjID;
opttable.Properties.VariableNames = {'Acceptance','RT','FV','Accept_Value','Relative_forage_value','Boost','Experienced_relative_FV','Subject_ID'};

