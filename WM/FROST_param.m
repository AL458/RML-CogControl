%script to build and plot FROST modulation by LC activity

function [f,p]=FROST_param(stim)

f.max_time=4200;%1400;%4200;

f.ncouple=length(stim)*2;


%parameters
p.alpha=0.4;
p.beta=.01;
p.gamma=0.01;

f.alpha=.001;
f.beta=.01;
f.gamma0=.02;
f.delta=3;
f.delta2=f.delta*ones(1,f.ncouple);

%stimuli onsets
p.phase_delay=1050;%1050;%3050;%for choice units
p.phase_delay2=50;%for cue unit
p.vstimd=30;%visual stimulus duration (for WM)

f.wmthr1=.15;%0.22;%1.2;%.22;
f.wmthr2=.02;%0.12;%0.4;%.12;


f.alphaF=1;


    
    
    
    