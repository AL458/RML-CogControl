function varmeaned = get_mean_difficulty_level_group(vartomean)
% Divides the variable vartomean (dimension of 36) into 9 different
% difficulty levels, depending on the value difference
varmeaned = zeros(size(vartomean,1),11,size(vartomean,3));
varmeaned(:,1,:) = mean(vartomean(:,1,:),2);       % -5
varmeaned(:,2,:) = mean(vartomean(:,2:3,:),2);      % -4
varmeaned(:,3,:) = mean(vartomean(:,4:6,:),2);      % -3
varmeaned(:,4,:) = mean(vartomean(:,7:10,:),2);      % -2
varmeaned(:,5,:) = mean(vartomean(:,11:15,:),2);      % -1
varmeaned(:,6,:) = mean(vartomean(:,16:21,:),2);      % 0
varmeaned(:,7,:) = mean(vartomean(:,22:26,:),2);      % 1
varmeaned(:,8,:) = mean(vartomean(:,27:30,:),2);      % 2
varmeaned(:,9,:) = mean(vartomean(:,31:33,:),2);      % 3
varmeaned(:,10,:) = mean(vartomean(:,34:35,:),2);      % 4
varmeaned(:,11,:) = mean(vartomean(:,36,:),2);      % 5


end