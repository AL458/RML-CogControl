function [totaloptimization] = Get_optimization_pars(dat,arg)
% Gets the full preprocessed datafile from the measured dat and arg
% variable

for s = 1:length(dat)
    [~,foroptimization{s}] = extract_behavior(dat{s},arg);
end
totaloptimization = mean_optimization(foroptimization);


end

