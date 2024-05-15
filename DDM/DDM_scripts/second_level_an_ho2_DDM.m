function second_level_an_ho2_DDM(dat,savename)
% Function adapted from the RML
% Group analysis. Allows for either input of the simulated data in the
% parameter dat, or if not supplied, attempts loads this variable. Plots
% the analyzed data at the end of the function, and saves the output in the
% filename provided in the savename variable input



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
arg.nexcltri = 50;
group=zeros(arg.nsubj,nstate,6);
groupz=zeros(arg.nsubj,nstate,6);
options=3;
boptions=10;

fulldata =dat;

for s=1:arg.nsubj
    % Get data from each participant in a usable format
    
    dat = fulldata{s};
    

    buff=cell(36,1);
    buffz=cell(36,1);
    
    dat.RT(1:arg.nexcltri)=[];
    dat.optim(1:arg.nexcltri)=[];
    dat.D(1:arg.nexcltri)=[];
    dat.D2(1:arg.nexcltri)=[];
    dat.b(dat.b==0)=[];
    dat.b(1:arg.nexcltri)=[];
    dat.V(1:arg.nexcltri)=[];
    dat.V2(1:arg.nexcltri)=[];
    dat.Vpre(1:arg.nexcltri)=[];
    dat.V2pre(1:arg.nexcltri)=[];
    dat.s(1:arg.nexcltri)=[];
    dat.res(1:arg.nexcltri)=[];
    dat.meanV(1:arg.nexcltri)=[];
    dat.meanV2(1:arg.nexcltri)=[];
    dat.PE_chosen_V(1:arg.nexcltri)=[];
    dat.PE_prechosen_V(1:arg.nexcltri)=[];
    dat.PE_chosen_V2(1:arg.nexcltri)=[];
    dat.PE_prechosen_V2(1:arg.nexcltri)=[];
    
    
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
        
    end
    % Z-score relevant data
    groupz(s,:,6)=(group(s,:,6)-mean(group(s,:,6),2))./std(squeeze(group(s,:,6))); % Z-score of the boost
    groupz(s,:,8)=(group(s,:,8)-mean(group(s,:,8),2))./std(squeeze(group(s,:,8))); % Z-score of the value
    groupz(s,:,11)=groupz(s,:,8)+groupz(s,:,6); % Simulated dACC activity
end

% Prepare data for plotting
boosttrue = [mean(group(:,:,6),1),std(group(:,:,6),1)./sqrt(arg.nsubj)];
boost=[mean(groupz(:,:,6),1),std(groupz(:,:,6),1)./sqrt(arg.nsubj)];
V=[mean(groupz(:,:,8),1),std(groupz(:,:,8),1)./sqrt(arg.nsubj)];
Vact=[mean(group(:,:,2),1),std(group(:,:,2),1)./sqrt(arg.nsubj)];
Vboost=[mean(group(:,:,3),1),std(group(:,:,3),1)./sqrt(arg.nsubj)];
Vdiffact=[mean(group(:,:,11),1),std(group(:,:,11),1)./sqrt(arg.nsubj)];
Vdiffboost=[mean(group(:,:,12),1),std(group(:,:,12),1)./sqrt(arg.nsubj)];
Dact=[mean(group(:,:,4),1),std(group(:,:,4),1)./sqrt(arg.nsubj)];
D2act=[mean(group(:,:,5),1),std(group(:,:,5),1)./sqrt(arg.nsubj)];
Full_D = [mean(group(:,:,9),1),std(group(:,:,9),1)./sqrt(arg.nsubj)];
dACC=[mean(groupz(:,:,11),1),std(groupz(:,:,11),1)./sqrt(arg.nsubj)];
RT=[mean(group(:,:,7),1),std(group(:,:,7),1)./sqrt(arg.nsubj)];
accuracy = [mean(group(:,:,10),1),std(group(:,:,10),1)./sqrt(arg.nsubj)];

PE_chosen = [mean(group(:,:,15),1),std(group(:,:,15),1)./sqrt(arg.nsubj)];
PE_chosenmean = get_mean_difficulty_level(PE_chosen(1:36));
PE_chosenstd = get_mean_difficulty_level(PE_chosen(37:end));

PE_chosenonedataset = [mean(mean(group(:,:,15),1)),std(mean(group(:,:,15),2),1)./sqrt(arg.nsubj)];

PE_prechoice = [mean(group(:,:,16),1),std(group(:,:,16),1)./sqrt(arg.nsubj)];
PE_prechoicemean = get_mean_difficulty_level(PE_prechoice(1:36));
PE_prechoicestd = get_mean_difficulty_level(PE_prechoice(37:end));
PE_prechoiceonedataset = [mean(mean(group(:,:,16),1)),std(mean(group(:,:,16),2),1)./sqrt(arg.nsubj)];

PE_chosen_V = [mean(group(:,:,17),1),std(group(:,:,17),1)./sqrt(arg.nsubj)];
PE_chosen_Vmean = get_mean_difficulty_level(PE_chosen_V(1:36));
PE_chosen_Vstd = get_mean_difficulty_level(PE_chosen_V(37:end));

PE_chosen_V2 = [mean(group(:,:,18),1),std(group(:,:,18),1)./sqrt(arg.nsubj)];
PE_chosen_V2mean = get_mean_difficulty_level(PE_chosen_V2(1:36));
PE_chosen_V2std = get_mean_difficulty_level(PE_chosen_V2(37:end));

PE_prechoice_V = [mean(group(:,:,19),1),std(group(:,:,19),1)./sqrt(arg.nsubj)];
PE_prechoice_Vmean = get_mean_difficulty_level(PE_prechoice_V(1:36));
PE_prechoice_Vstd = get_mean_difficulty_level(PE_prechoice_V(37:end));

PE_prechoice_V2 = [mean(group(:,:,20),1),std(group(:,:,20),1)./sqrt(arg.nsubj)];
PE_prechoice_V2mean = get_mean_difficulty_level(PE_prechoice_V2(1:36));
PE_prechoice_V2std = get_mean_difficulty_level(PE_prechoice_V2(37:end));



boostmean = get_mean_difficulty_level(boost(1:36));
booststd = get_mean_difficulty_level(boost(37:end));
boosttruemean = get_mean_difficulty_level(boosttrue(1:36));
boosttruestd = get_mean_difficulty_level(boosttrue(37:end));
accuracymean = get_mean_difficulty_level(accuracy(1:36));
accuracysd = get_mean_difficulty_level(accuracy(37:end));

Vmean = get_mean_difficulty_level(V(1:36));
Vstd = get_mean_difficulty_level(V(37:end));

Vactmean = get_mean_difficulty_level(Vact(1:36));
Vactstd = get_mean_difficulty_level(Vact(37:end));

Vboostmean = get_mean_difficulty_level(Vboost(1:36));
Vbooststd = get_mean_difficulty_level(Vboost(37:end));

Vdiffactmean = get_mean_difficulty_level(Vdiffact(1:36));
Vdiffactstd = get_mean_difficulty_level(Vdiffact(37:end));

Vdiffboostmean = get_mean_difficulty_level(Vdiffboost(1:36));
Vdiffbooststd = get_mean_difficulty_level(Vdiffboost(37:end));


Dactmean = get_mean_difficulty_level(Dact(1:36));
Dactstd = get_mean_difficulty_level(Dact(37:end));

D2actmean = get_mean_difficulty_level(D2act(1:36));
D2actstd = get_mean_difficulty_level(D2act(37:end));

dACCmean = get_mean_difficulty_level(dACC(1:36));
dACCstd = get_mean_difficulty_level(dACC(37:end));

RTmean = get_mean_difficulty_level(RT(1:36));
RTstd = get_mean_difficulty_level(RT(37:end));

fulldata = [];
fulldata.Vmean = Vmean;
fulldata.Vstd = Vstd;
fulldata.boostmean = boostmean;
fulldata.booststd = booststd;
fulldata.boosttruemean = boosttruemean;
fulldata.boosttruestd = boosttruestd;
fulldata.accuracymean = accuracymean;
fulldata.accuracystd = accuracysd;
fulldata.dACCmean = dACCmean;
fulldata.dACCstd = dACCstd;
fulldata.RTmean = RTmean;
fulldata.RTstd = RTstd;
fulldata.Vdiffactmean = Vdiffactmean;
fulldata.Vdiffactstd = Vdiffactstd;
fulldata.Vdiffboostmean = Vdiffboostmean;
fulldata.Vdiffbooststd = Vdiffbooststd;
fulldata.Vactmean = Vactmean;
fulldata.Vactstd = Vactstd;
fulldata.Vboostmean = Vboostmean;
fulldata.Vbooststd = Vbooststd;

% Make output_plots directory if it does not exist
if ~isfolder(savename)
    mkdir(savename)
end

% Generate plots

cw = pwd;
addpath(pwd)
cd(savename)
%create_fullfigure(linspace(-5,5,11),fulldata)
create_fullfigure_2(linspace(-5,5,11),fulldata)
cd(cw)
