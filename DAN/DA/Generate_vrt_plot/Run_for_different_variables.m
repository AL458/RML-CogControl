function Run_for_different_variables()
% Perform the simulation for different values of the vrt parameter

Centered_optimum = [0.01748,0.7271,0.2836,0.4082,99.63]; % Optimized value of the parameters as determined by the gradient descent algorithm.
% Note that the fifth value (for the vrt parameter) is inversed here. 
nsubj = 200; % Number of subjects per simulation

names = {'RT_to_value_Conversion'};
locs = [5]; % Location of the parameter to change. Location 5 is the location of the vrt parameter
values = [-75,-50,-25,-10,0,10,25,50,75];% Difference to centered optimum to be considered in percentage
currfolder = pwd;
addpath(currfolder)
addpath(fullfile('..','DA_scripts','Functions'))
addpath(fullfile('Functions'))


% Loop over the locations and values indicated
for par = 1:length(locs)
    for valuenr = 1:length(values)
        % For each element in the 'values' vector, get the corresponding
        % percentage, and make the title 
        value = values(valuenr);
        currname = names{par};
        fname = fullfile('Changing_parameters',currname,strcat(num2str(value),'%_change'));
        if isfolder(fname)==0
            mkdir(fname)
            mkdir(fullfile(fname,'Output'))
        end
        % Check for flag. This allows for parallel processing of the script
        if isfile(fullfile(fname,'flag.mat')) || isfile(fullfile(fname,'Output.mat'))
            continue
        else
            cd(fname)
            flag = '';
            save('flag.mat','flag')
        end
        % Generate the parameter set to simulate
        Changed_optimum = Centered_optimum;
        Changed_optimum(locs(par))=Changed_optimum(locs(par))*(100+values(valuenr))/100;
        % Perform the simulation of a single parameter set
        [dat,output,optimization_pars] = RML_main_opt_dual_attractor(Changed_optimum,nsubj);
        % Save the output for later plotting
        save('Output.mat','dat','output','optimization_pars');
        delete('flag.mat');
        cd(currfolder)
    end
end
rmpath .
rmpath(fullfile('..','DA_scripts','Functions'))

end