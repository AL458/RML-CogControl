function difficulty_bins = transformstatetodifficulty(state_values)
%TRANSFORMSTATETODIFFICULTY Summary of this function goes here
%   Detailed explanation goes here
cutoffs = [1,3,6,10,15,21,26,30,33,35,36]; % Cutoff values for the difficulty levels
cutoffs = cutoffs;

difficulty_bins = sum(state_values>cutoffs,2);


end

