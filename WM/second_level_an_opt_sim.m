%group analysis for WM results

function [perf_res]=second_level_an_opt_sim(S,arg)

nstate=size(arg.trans,1);

group=zeros(arg.nsubj,nstate,9);

groupnpr=zeros(arg.nsubj,nstate);
groupnpr4=zeros(arg.nsubj,nstate);

dat=S{1};


grouptr=zeros(arg.nsubj,nstate,length(dat.respside(1,:))-arg.nexcltri);

for s=1:arg.nsubj
    
    
    dat=S{s};
    
    
    buff_npr=cell(8,1);
    
    buff_npr3=cell(8,1);
    buff=cell(8,1);
    buff_LA=cell(8,1);
    
    
    dat.rw(:,1:arg.nexcltri)=[];
    dat.optim(:,1:arg.nexcltri)=[];
    dat.k(:,1:arg.nexcltri)=[];
    dat.F(:,1:arg.nexcltri)=[];
    dat.D(:,1:arg.nexcltri)=[];
    dat.D2(:,1:arg.nexcltri)=[];
    dat.respside(:,1:arg.nexcltri)=[];
    dat.b(:,1:arg.nexcltri)=[];
    dat.VTA(:,1:arg.nexcltri)=[];
    dat.VTA2(:,1:arg.nexcltri)=[];
    dat.V(:,1:arg.nexcltri)=[];
    dat.V2(:,1:arg.nexcltri)=[];
    
    
    
    for state=1:nstate%1st to 3rd order
        
        buff{state}(:,1)=dat.rw(state,dat.k(state,:)>0)';
        buff{state}(:,2)=dat.optim(state,dat.k(state,:)>0)';
        buff{state}(:,3)=dat.k(state,dat.k(state,:)>0)';
        buff_LA{state}(:,4)=dat.F(state,dat.b(state,:)>0)';
        buff{state}(:,5)=dat.respside(state,dat.k(state,:)>0)';
        
        buff{state}(:,6)=dat.V(state,dat.k(state,:)>0)'+dat.V2(state,dat.k(state,:)>0)';
        buff{state}(:,7)=dat.b(state,dat.b(state,:)>0)';
        buff{state}(:,8)=dat.D(state,dat.k(state,:)>0)'+dat.D2(state,dat.k(state,:)>0)';
        buff{state}(:,9)=dat.D2(state,dat.k(state,:)>0)';
        
        ntri=length(buff{state});%number of trials
        
        buff_npr{state}=(dat.VTA(state,dat.VTA(state,:)>0));
        buff_npr3{state}=(dat.VTA2(state,dat.VTA2(state,:)>0));
        
        
        group(s,state,1)=mean(buff{state}(:,1));
        group(s,state,2)=mean(buff{state}(buff{state}(:,5)~=3,2));%exclude "stay" trials
        group(s,state,3)=mean(buff{state}(:,3));
        
        bufft=nan(ntri,1);
        
        for tri=1:ntri
            if buff{state}(tri,5)==3
                bufft(tri)=1;
            else
                bufft(tri)=0;
            end
        end
        
        group(s,state,5)=mean(bufft,'omitnan');%record all resp
        group(s,state,4)=mean(buff_LA{state}(:,4));
        group(s,state,7)=mean(buff{state}(:,7));
        group(s,state,6)=mean(buff{state}(buff{state}(:,5)~=3,6));
        group(s,state,8)=mean(buff{state}(:,8));
        group(s,state,9)=mean(buff{state}(:,9));
        
        if sum(arg.trans(1,:))>4 || sum(arg.trans(1,:))>6%if Gersch et al. 2015 task
           grouptr(s,state,:)=dat.optim(state,:);
        end
        
        groupnpr(s,state)=mean(buff_npr{state});
        groupnpr4(s,state)=mean(buff_npr3{state});
        
    end
    
   
    
end



    boost=squeeze(group(:,:,7));
    F=squeeze(group(:,:,4));
    D_tot=squeeze(group(:,:,8));
    D_boost=squeeze(group(:,:,9));
    V=squeeze(group(:,:,6));%expected value for selected saccade

compl=1-squeeze(group(:,:,5));

opt=squeeze(group(:,:,2));

perf_res=[boost F D_tot D_boost V compl opt];



