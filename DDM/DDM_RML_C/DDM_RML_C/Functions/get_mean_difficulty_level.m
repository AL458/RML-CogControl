function varmeaned = get_mean_difficulty_level(vartomean)
% Divides the variable vartomean (dimension of 36) into 9 different
% difficulty levels, depending on the value difference
varmeaned = zeros(1,9);
varmeaned(1) = mean(vartomean(1));       % -5
varmeaned(2) = mean(vartomean(2:3));      % -4
varmeaned(3) = mean(vartomean(4:6));      % -3
varmeaned(4) = mean(vartomean(7:10));      % -2
varmeaned(5) = mean(vartomean(11:15));      % -1
varmeaned(6) = mean(vartomean(16:21));      % 0
varmeaned(7) = mean(vartomean(22:26));      % 1
varmeaned(8) = mean(vartomean(27:30));      % 2
varmeaned(9) = mean(vartomean(31:33));      % 3
varmeaned(10) = mean(vartomean(34:35));      % 4
varmeaned(11) = mean(vartomean(36));      % 5


end