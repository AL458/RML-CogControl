function fulldata = second_level_an_ho2_dual_attractor_full_function(dat)
% Function adapted from the RML
% Group analysis. Allows for either input of the simulated data in the
% parameter dat, or if not supplied, attempts loads this variable. Plots
% the analyzed data at the end of the function. Rather than plotting,
% returns the data in the data structure fulldata

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
arg.nsubj = length(fulldat);
group=zeros(arg.nsubj,nstate,6);
groupz=zeros(arg.nsubj,nstate,6);

% Perform group analysis
for s=1:arg.nsubj
    
    
    dat = fulldat{s};
    

    buff=cell(36,1);
    buffz=cell(36,1);
    
    for state=1:nstate
        
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

        if state>21
            buff{state}(buff{state}(:,10)==2,10)=0;
        else
            buff{state}(buff{state}(:,10)==1,10)=0;
            buff{state}(buff{state}(:,10)==2,10)=1;
        end
        buff{state}(buff{state}(:,10)==3,10)=0;
        
        
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

    end
    % Z-score the boost, value, and dACC values
    groupz(s,:,6)=(group(s,:,6)-mean(group(s,:,6),2))./std(squeeze(group(s,:,6)));
    groupz(s,:,8)=(group(s,:,8)-mean(group(s,:,8),2))./std(squeeze(group(s,:,8)));
    groupz(s,:,11)=groupz(s,:,8)+groupz(s,:,6);
end

% Z-score different parameters for plotting
groupzmean = get_mean_difficulty_level_group(groupz);
boost=[mean(groupzmean(:,:,6),1)];
V=[mean(groupzmean(:,:,8),1)];
dACC=[mean(groupzmean(:,:,11),1)];


% Create datastructure

fulldata = [];
fulldata.Vmean = V(1:11);
fulldata.boostmean = boost(1:11);
fulldata.dACCmean = dACC(1:11);




