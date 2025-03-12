function outputtable = getfulloutputfile(fullboost,fullvalue)
% Function for generating one table, where each row contains data for one
% state and subject, containing the mean boost and value data

fulltable = [];
for i = 1:size(fullboost,1)
    for state = 1:size(fullboost,2)
        ntrials = sum(~isnan(fullboost(i,state,:)));
        toadd = [squeeze(fullboost(i,state,(~isnan(fullboost(i,state,:))))) squeeze(fullvalue(i,state,~isnan(fullvalue(i,state,:))))];
        Subject_ID = ones(ntrials,1)*i;
        trialtype = ones(ntrials,1)*state;
        toaddtable = [toadd Subject_ID trialtype];
        if state == 1 && i == 1
            fulltable = toaddtable;
        else
            fulltable = vertcat(fulltable,toaddtable);
        end
    end
end

outputtable = array2table(fulltable);
outputtable.Properties.VariableNames = {'Boost','Value','Subject_ID','State'};
% Transform difficutly bins
outputtable.Difficulty_bin = transformstatetodifficulty(outputtable.State);

save('Fulloutput','outputtable')

end