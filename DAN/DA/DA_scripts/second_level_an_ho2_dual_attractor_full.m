function second_level_an_ho2_DDM(dat,savename)
% Function adapted from the RML
% Group analysis. Allows for either input of the simulated data in the
% parameter dat, or if not supplied, attempts loads this variable. Plots
% the analyzed data at the end of the function, and saves the output in the
% filename provided in the savename variable input

try savename;
catch
    savename = 'Output_plots';
end


nstate=36;
try 
    dat = dat;
    fulldat =dat;
    if isempty(dat)
        error('incorrect dat')
    end
catch
    list = dir('DA_S*');
    dat = [];
    for i = 1:length(list)
        currdat = load(fullfile(list(i).folder,list(i).name),'dat');
        dat{i} = currdat.dat;
    end
    fulldat = dat;
end

arg.nsubj = length(dat);
group=zeros(arg.nsubj,nstate,6);
groupz=zeros(arg.nsubj,nstate,6);

fulldata =dat;

fulloutput_boost = nan(arg.nsubj,36,200);
fulloutput_value = nan(arg.nsubj,36,200);

for s=1:arg.nsubj
    % Get data from each participant in a usable format
    
    dat = fulldata{s};
    

    buff=cell(36,1);
    buffz=cell(36,1);
    
    dat.surprise = abs(dat.D)+abs(dat.D2);

    
    
    
    for state=1:nstate % Perform analysis for each state separately
        
        buff{state}(:,1)=dat.optim(dat.s==state)';
        buff{state}(:,2)=dat.Vpre(dat.s==state)';
        buff{state}(:,3)=dat.V2pre(dat.s==state)';
        buff{state}(:,4)=dat.D(dat.s==state)';
        buff{state}(:,5)=dat.D2(dat.s==state)';
        buff{state}(:,6)=dat.b(dat.s==state)';
        buff{state}(:,7)=dat.RT(dat.s==state)';
        buff{state}(:,8)=dat.Vpre(dat.s==state)'+dat.V2pre(dat.s==state)';
        buff{state}(:,9)=dat.D(dat.s==state)'+dat.D2(dat.s==state)';
        buff{state}(:,10)=dat.res(dat.s==state)';
        buff{state}(:,11)=dat.V(dat.s==state)-dat.Vpre(dat.s==state);
        buff{state}(:,12)=dat.V2(dat.s==state)-dat.V2pre(dat.s==state);
        buff{state}(:,13)=dat.V(dat.s==state)';
        buff{state}(:,14)=dat.V2(dat.s==state)';
        buff{state}(:,15)=abs(dat.PE_chosen_V(dat.s==state)+dat.PE_chosen_V2(dat.s==state));
        buff{state}(:,16)=abs(dat.PE_prechosen_V(dat.s==state)+dat.PE_prechosen_V2(dat.s==state));
        buff{state}(:,17)=abs(dat.PE_chosen_V(dat.s==state)');
        buff{state}(:,18)=abs(dat.PE_chosen_V2(dat.s==state)');               
        buff{state}(:,19)=abs(dat.PE_prechosen_V(dat.s==state)');
        buff{state}(:,20)=abs(dat.PE_prechosen_V2(dat.s==state)');       
        
        if state>21
            buff{state}(buff{state}(:,10)==2,10)=0;
        else
            buff{state}(buff{state}(:,10)==1,10)=0;
            buff{state}(buff{state}(:,10)==2,10)=1;
        end

        % Correct = buff{state}==1, incorrect: buff{state} == 0
        

        % Get dacc split by median surprise
        Surprise = dat.surprise(dat.s==state)';
        Accuracy = buff{state}(:,10);
        Subject_ID = ones(length(Accuracy),1)*s;

        % Combine into table, only used for the DDM
        surprisetabletoadd = table(Accuracy,Surprise,Subject_ID);
        
        if (s == 1 & state == 1)
            surprisetable = surprisetabletoadd;
        else
            surprisetable = vertcat(surprisetable,surprisetabletoadd);
        end

        group(s,state,1)=mean(buff{state}(:,1));
        group(s,state,2)=mean(buff{state}(:,2));
        group(s,state,3)=mean(buff{state}(:,3));
        group(s,state,4)=mean(buff{state}(:,4));
        group(s,state,5)=mean(buff{state}(:,5));
        group(s,state,6)=mean(buff{state}(:,6));
        group(s,state,7)=mean(buff{state}(:,7));
        group(s,state,8)=mean(buff{state}(:,8));
        group(s,state,9)=mean(buff{state}(:,9));
        group(s,state,10)=mean(buff{state}(:,10));
        group(s,state,11)=mean(buff{state}(:,11));
        group(s,state,12)=mean(buff{state}(:,12));
        group(s,state,13)=mean(buff{state}(:,13));
        group(s,state,14)=mean(buff{state}(:,14));
        group(s,state,15)=mean(buff{state}(:,15));
        group(s,state,16)=mean(buff{state}(:,16));
        group(s,state,17)=mean(buff{state}(:,17));
        group(s,state,18)=mean(buff{state}(:,18));
        group(s,state,19)=mean(buff{state}(:,19));
        group(s,state,20)=mean(buff{state}(:,20));

        fulloutput_boost(s,state,1:length(buff{state}(:,6))) = buff{state}(:,6);
        fulloutput_value(s,state,1:length(buff{state}(:,8))) = buff{state}(:,8);
        
    end
    % Z-score relevant data
    groupz(s,1:11,6)=get_mean_difficulty_level(group(s,:,6)-mean(group(s,:,6),2))./std(squeeze(group(s,:,6))); % Z-score of the boost
    groupz(s,:,7)=(group(s,:,7)-mean(group(s,:,7),2))./std(squeeze(group(s,:,7))); % Z-score of the RT
    groupz(s,1:11,8)=get_mean_difficulty_level(group(s,:,8)-mean(group(s,:,8),2))./std(squeeze(group(s,:,8))); % Z-score of the value
    groupz(s,:,11)=groupz(s,:,8)+groupz(s,:,6); % Simulated dACC activity
    RT_arr(s,1:11) = get_mean_difficulty_level(group(s,:,7)); % Store the mean RT
    accarr(s,1:11) = get_mean_difficulty_level(group(s,:,10)); % Store the mean accuracy
end

RT = RT_arr;
acc_mean = accarr;
% Save the RT and accuracy values for the plot comparing them to the data
% found by Vassena et al.
save(fullfile('..','RTandACC'),'RT','acc_mean')

cd('..')
file = getfulloutputfile(fulloutput_boost,fulloutput_value);
% Get AIC, and save it in AIC_output for calculating the AIC and fit of the
% best fitting linear, quadratic, and quartic functions
AIC_struct = get_AIC(file);
save('AIC_output.mat','AIC_struct')

% Add z-scores to value and boost zscoring individually over each
% participant
save('surprisetable','surprisetable')

% Prepare data for plotting

dACCmean = mean(groupz(:,1:11,11));
dACCstd = std(groupz(:,1:11,11))/sqrt(arg.nsubj);

boostmean = mean(groupz(:,1:11,6));
booststd = std(groupz(:,1:11,6))/sqrt(arg.nsubj);

Vmean = mean(groupz(:,1:11,8));
Vstd = std(groupz(:,1:11,8))/sqrt(arg.nsubj);

% Generate a structure for plotting

fulldata = [];
fulldata.Vmean = Vmean;
fulldata.Vstd = Vstd;
fulldata.boostmean = boostmean;
fulldata.booststd = booststd;
fulldata.dACCmean = dACCmean;
fulldata.dACCstd = dACCstd;

% Make output_plots directory if it does not exist
if ~isfolder(savename)
    mkdir(savename)
end

% Generate plots

cw = pwd;
addpath(pwd)
cd(savename)
% create_fullfigure(linspace(-5,5,11),fulldata)
%create_fullfigure_2(linspace(-5,5,11),fulldata)
create_fullfigure_AIC_poly(linspace(-5,5,11),fulldata,AIC_struct)
cd(cw)
