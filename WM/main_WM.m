function main_WM()

%function for parallization of param estimation per session


RW=[3,1];

nrep=15;


res=grid_search([1 1 1 .1],RW,nrep);



save results res;

res_plot;

end