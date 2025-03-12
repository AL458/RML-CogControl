function mean_acc = get_mean_acc(responses,state,RT_correct)
% Function that generates the accuracy; the probabilty the option with the
% highest value is selected

try 
    RT_correct; 
catch
    RT_correct = []; 
end

responses(RT_correct)=0; % Indicate late responses
if state<16
    % Select option 2
    mean_acc = mean(responses==2);
elseif state<22
    % Select any option
    mean_acc = mean(responses==2);
else
    % Select option 1
    mean_acc = mean(responses==1);
end

end