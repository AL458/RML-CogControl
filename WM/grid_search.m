%main script gridsearch horan gottlieb individual differences
function res=grid_search(param_set,RW,nrep)


%simulate session with optimal parameters
btemp=.3;

arg = param_build(param_set,RW,btemp,nrep);

res = RML_main_opt_sim(arg);











