function behavior_combined = mean_behavior(behavior_out)
% Combines the behavior from the FVT simulations into a single
% behavior_combined file

nsubjs = length(behavior_out);
behavior_combined = [];


varnames  = behavior_out{1}.output.Properties.VariableNames;
total = table2array(behavior_out{1}.output);
for i = 2:nsubjs
    total = total+table2array(behavior_out{i}.output);
end
total = total/nsubjs;
behavior_combined.output = array2table(total);   
behavior_combined.output.Properties.VariableNames = varnames;


end