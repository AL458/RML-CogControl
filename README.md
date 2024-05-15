# RML-CogControl

This repository contains the code for the generation of the figures present in the paper 'Meta-Reinforcement Learning reconciles surprise, value and control in the anterior cingulate cortex' and its supplementary materials, to allow for reproduction of the results. It contains four different functions, which can be called directly from the matlab command line:
Main_DA_simulate_and_plot.m: a function for running the dual attractor network analysis performed in the supplementary materials
Main_DDM_simulate_and_plot.m: a function for running the DDM analysis performed in the main text and supplementary materials

After either of these functions has been run, the corresponding plot_only functions can be run. These skip the simulation process, and directly create the figures:
Main_DA_plot_only.m: a function for generating the plots for the dual attractor network analysis
Main_DDM_plot_only.m: a function for generating the plots for the drift diffusion network analysis
