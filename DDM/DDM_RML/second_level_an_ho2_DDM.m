function second_level_an_ho2_DDM(dat,savename)
% Function adapted from the RML
% Group analysis. Allows for either input of the simulated data in the
% parameter dat, or if not supplied, attempts loads this variable. Plots
% the analyzed data at the end of the function, and saves the output in the
% filename provided in the savename variable input


BL = 108; % Block length
nstate=36;
try 
    dat = dat;
    fulldat =dat;
    if isempty(dat)
        error('incorrect dat')
    end
catch
    list = dir('DDM_S*');
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

        % Combine into table
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
    % Use devisive normalization on the means
    divnorm(s,1:11,1)=DivNorm(get_mean_difficulty_level(group(s,:,6)));
    divnorm(s,1:11,2)=DivNorm(get_mean_difficulty_level(group(s,:,8)));
    divnorm(s,1:11,3)=divnorm(s,1:11,1)+divnorm(s,1:11,2);
    
end

file = getfulloutputfile(fulloutput_boost,fulloutput_value);

% Get AIC, and save the output
AIC_struct = get_AIC_divnorm(divnorm);
save('AIC_output.mat','AIC_struct')


% Store the calculated surprise data
save('surprisetable','surprisetable')

% Prepare data for plotting
boostmean = mean(divnorm(:,:,1));
booststd = std(divnorm(:,:,1))/sqrt(arg.nsubj);

Vmean = mean(divnorm(:,:,2));
Vstd = std(divnorm(:,:,2))/sqrt(arg.nsubj);

dACCmean = mean(divnorm(:,:,3));
dACCstd = std(divnorm(:,:,3))/sqrt(arg.nsubj);


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
create_fullfigure_AIC_poly(linspace(-5,5,11),fulldata,AIC_struct)
cd(cw)
