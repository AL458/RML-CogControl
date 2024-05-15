function Plot_varied_parameters()
% Script for performing the analysis stated in the supplementary material,
% where the parameter changing the effect of the runtime of the DAN and the
% reward received in the RML is varied by a certain percentage, to
% investigate the effect of a change in this parameter visually. 

addpath(fullfile('..','DA_scripts','Scripts'))
addpath(fullfile('..','DA_scripts','Scripts','All_scripts'))
addpath(fullfile('..','DA_scripts','Input'))

variablename = 'Value conversion';
variable = 'RT_to_value_Conversion'; % Name of the variable to plot

foldertoplot = fullfile('Changing_parameters',variable);
filestoplot = dir(fullfile(foldertoplot,'*','Output.mat'));

clear fulldata;
legendvalues = [];

% Load the data for each change made
for filenr = 1:length(filestoplot)
    fileloc = fullfile(filestoplot(filenr).folder,filestoplot(filenr).name);
    % There are four positive, four negative and one original plot. In
    % order to plot them in ascending order, we need to change the order
    % they are loaded. The original plot is loaded as ninth value, and the
    % negative are loaded after the positive changes
    if filenr >4
        filenr = filenr;
    end
    % Negative values are loaded from small to large, so the order is
    % inverted
    if filenr<5
        filenr = 5-filenr;
    end
    load(fileloc)
    % Perform group analysis
    fulldata{filenr}=second_level_an_ho2_dual_attractor_full_function(dat);
    % Evaluate where the %_change is located in the filename, and store the
    % location in the variable loc. By default, all but the Original
    % simulation have this expression in their string. By storing the loc
    % variable, the location of the Original simulation can also be
    % accessed. These accessed values are stored in the legend variable.
    fullnamearray = split(fileloc,'/');
    if ~(size(fullnamearray,1)>1) % If fileseperator is not /, Windows os
        fullnamearray = split(fileloc,'\'); % Split by windows file separator
    end
    for i = 1:length(fullnamearray)
        % Check if the name contains %_change
        if contains(fullnamearray{i},'%_change')
            loc = i;
        end
    end
    
    legendvalues{filenr} = strrep(fullnamearray{loc},'_',' ');
end

% Plot dACC activity for different variable values
f = figure;
hold on
title(['dACC activity for different ' variablename])
for i = 1:length(filestoplot)
    plot(linspace(-5,5,11),fulldata{i}.dACCmean,'LineWidth',2,'Color',repmat([(i-1)/length(filestoplot)],1,3));
end
legend(legendvalues);
xlim([-5.5,5.5]);
xlabel(variablename);
ylabel('Simulated dACC activity')
saveas(f,fullfile('Plot_output',strcat(variablename,'.png')))

rmpath(fullfile('..','DA_scripts','Scripts'))
rmpath(fullfile('..','DA_scripts','Scripts','All_scripts'))
rmpath(fullfile('..','DA_scripts','Input'))

end