%run n subjects and launch data analysis scripts

function res=RML_main_opt_sim(arg)

S=cell(arg.nsubj,1);


for s=1:arg.nsubj
    S{s}=kenntask_gottl(arg);
end


[res]=second_level_an_opt_sim(S,arg);


