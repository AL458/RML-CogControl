# RML-CogControl

This repository contains the code for the generation of the figures present in the paper 'Meta-Reinforcement Learning reconciles surprise, value and control in the anterior cingulate cortex' and its supplementary materials, to allow for reproduction of the results. It contains ten different functions (five for running simulations, and five for plotting the simulated data), which can be called directly from the matlab command line.


When replicating the analysis, first run one of the following scripts, which performs the simulation of the data.

- Run_DAN.m: a function for running the dual attractor network simulations performed in the supplementary materials
- Run_DDM.m: a function for running the drift diffusion model simulations performed in the main text and supplementary materials
- Run_FVT.m: a function for running the foraging value simulations performed in the main text and supplementary materials
- Run_Vrt.m: a function for running the analysis changing the vrt parameter performed in the supplementary materials (note: this analysis takes significantly longer than the other analyses)
- Run_RML_C.m: a function for running the drift diffusion model with the RML-C rather than the RML simulations performed in the supplementary materials


When the simulation finishes, run one of the following scripts, to plot the results

- Plot_DAN.m: a function for plotting the results from Run_DAN.m
- Plot_DDM.m: a function for plotting the results from Run_DDM.m
- Plot_FVT.m: a function for plotting the results from Run_DAN.m
- Plot_RML_C.m: a function for plotting the results from Run_DAN.m
- Plot_Vrt.m: a function for plotting the results from Run_DAN.m
