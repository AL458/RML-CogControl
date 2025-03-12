function Generate_fullfile()

load('Output.mat')

nparts = length(dat);
state1 = [17:(16+16*8)]; % State 1 trials

for i = 1:nparts
    statearr = unique(dat{i}.state(~isnan(dat{i}.state)));
    nstates = length(statearr);
    currdat = dat{i};
    for stateind = 1:nstates
        state = statearr(stateind);
        indicestouse = dat{i}.state==state;
        boostcurr = dat{i}.boost(indicestouse);
        valuecurr = dat{i}.V(indicestouse)+dat{i}.V2(indicestouse);
        subj_ID = ones(size(boostcurr))*i;
        engage_value = nan(size(boostcurr));
        forage_value = nan(size(boostcurr));
        if state<17
            forage_value(:) = arg.foragevalue(state*16);
        elseif sum(state1==state)==1
            forage_value(:) = max(arg.foragevalue(state,:));
        end
        if sum(state1==state)==1
            engage_value(:) = max(arg.RWM(state+16*8,:));
        end
        statearr_toadd = ones(size(boostcurr))*state;
        acceptance = 2-dat{i}.action(indicestouse);
        toadd = [boostcurr,valuecurr,acceptance,subj_ID,statearr_toadd,engage_value,forage_value];
        if stateind == 1
            fullparttable = toadd;
        else
            fullparttable = vertcat(fullparttable,toadd);
        end
    end
    fullparttable = array2table(fullparttable);
    fullparttable.Properties.VariableNames = {'Boost','Value','accept','Subject_ID','state','engage_value','forage_value'};
    fullparttable.trialid = (1:height(fullparttable))';
    % Determine bias
    state1s = fullparttable((fullparttable.state>(state1(1)-1))&(fullparttable.state<(state1(end)+1)),:);
    relforagevalue = state1s.forage_value-state1s.engage_value;
    bias = get_indifference_point(state1s.accept,relforagevalue');
    state1s.relative_forage_value = state1s.forage_value-state1s.engage_value-bias;
    state1s.decisiondifficulty = max(abs(state1s.relative_forage_value))-abs(state1s.relative_forage_value);
    state1sordered = sortrows(state1s,'forage_value');
    fullbinmat = repmat(1:8,1,ceil(height(state1sordered)/8))';
    state1sordered.bin_FV = sort(fullbinmat(1:height(state1s)));

    state1sordered = sortrows(state1sordered,'decisiondifficulty');
    fullbinmat = repmat(1:8,1,ceil(height(state1sordered)/8))';
    state1sordered.bin_diff = sort(fullbinmat(1:height(state1s)));

    state1s = sortrows(state1sordered,'trialid');
    
    % Add the state1s back to the full dataframe
    fullparttable.relative_forage_value(:) = nan;
    fullparttable.decisiondifficulty(:) = nan;
    fullparttable.bin_FV(:) = nan;
    fullparttable.bin_diff(:) = nan;

    trialidstouse = state1s.trialid;
    fullparttable.relative_forage_value(trialidstouse) = state1s.relative_forage_value;
    fullparttable.decisiondifficulty(trialidstouse) = state1s.decisiondifficulty;
    fullparttable.bin_FV(trialidstouse) = state1s.bin_FV;
    fullparttable.bin_diff(trialidstouse) = state1s.bin_diff;
    
    if i == 1
        fulltable = fullparttable;
    else
        fulltable = vertcat(fulltable,fullparttable);
    end


end

save('Fulloutput.mat','fulltable')

end