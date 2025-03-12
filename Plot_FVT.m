% Function for plotting the results of the FVT analysis. Plots the
% simulated dACC acitivty and boost activity for the forage value bins, and
% for the choice difficulty bins, and plots the fit of the RT and accuracy.
% Requires that the function Run_FVT has been run first

% Plot the fit of the RT and accuracy
cd('FVT')
Plot_acc_and_RT();

% Plot the boost and dACC activity
Plot_RML_results();
cd('..')