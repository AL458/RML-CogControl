function fulldata = secondlevel_function(dat)
% Function adapted from the RML
% Group analysis. Allows for either input of the simulated data in the
% parameter dat, or if not supplied, attempts loads this variable. Plots
% the analyzed data at the end of the function. Rather than plotting,
% returns the data in the data structure fulldata

nstate=36;

try 
    dat = dat;
    fulldata =dat;
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
    fulldata = dat;
end

arg.nsubj = length(dat);
group=zeros(arg.nsubj,nstate,6);
groupz=zeros(arg.nsubj,nstate,6);

% Perform group analysis
for s=1:arg.nsubj
    
    
    dat = fulldata{s};
    

    buff=cell(36,1);
    buffz=cell(36,1);
    
    
    for state=1:nstate%1st to 3rd order
        
        buff{state}(:,1)=dat.optim(dat.s==state)';
        buff{state}(:,2)=dat.Vpre(dat.s==state)';
        buff{state}(:,3)=dat.V2pre(dat.s==state)';
        buff{state}(:,4)=dat.D(dat.s==state)';
        buff{state}(:,5)=dat.D2(dat.s==state)';
        buff{state}(:,6)=dat.b(dat.s==state)';
        buff{state}(:,7)=dat.RT(dat.s==state)';
        buff{state}(:,8)=dat.Vpre(dat.s==state)'+dat.V2pre(dat.s==state)';%+dat.D(dat.s==state)'+dat.D2(dat.s==state)';
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
    % Z-score the boost, value, and dACC values
    divnorm(s,1:11,1)=DivNorm(get_mean_difficulty_level(group(s,:,6)));
    divnorm(s,1:11,2)=DivNorm(get_mean_difficulty_level(group(s,:,8)));
    divnorm(s,1:11,3)=divnorm(s,1:11,1)+divnorm(s,1:11,2);
    
end

boostmean = mean(divnorm(:,:,1));
booststd = std(divnorm(:,:,1))/sqrt(arg.nsubj);

Vmean = mean(divnorm(:,:,2));
Vstd = std(divnorm(:,:,2))/sqrt(arg.nsubj);

dACCmean = mean(divnorm(:,:,3));
dACCstd = std(divnorm(:,:,3))/sqrt(arg.nsubj);



% Create datastructure

fulldata = [];
fulldata.Vmean = Vmean;
fulldata.Vstd = Vstd;
fulldata.boostmean = boostmean;
fulldata.booststd = booststd;
fulldata.dACCmean = dACCmean;
fulldata.dACCstd = dACCstd;
