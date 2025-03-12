function indifference_point = get_indifference_point(acceptance,relvalofengage)
% Gets the bias value by estimating the value that generates an acceptance
% rate of 50%

datapairs = [acceptance,relvalofengage'];
% datapairs(datapairs(:,1)==1,:) = []; % Remove all completely accepted trials
% Sort datapairs

[~,inds] = sort(datapairs(:,1));
sorteddatapairs = datapairs(inds,:);

% We assume that the data is a sigmoid function, we can fit the data
logistic = fittype("1/(1+exp(-a*(x-b)))",dependent="y",independent="x",coefficients=["a" "b"]);

getoptimalparameters = fit(sorteddatapairs(:,2),sorteddatapairs(:,1),logistic,'start',[1.5,0]);
indifference_point = getoptimalparameters.b;
counter = 1;

while abs(indifference_point)>4
    % Unfortunately, the fit function can have issues with convergence. If
    % the indifference point is exceptionally extreme, retry generating the
    % indifference point. If this happens several times in a row, the
    % extreme indifference point was possibly correct, and will be used.
    getoptimalparameters = fit(sorteddatapairs(:,2),sorteddatapairs(:,1),logistic,'start',[1.5,rand(1)*10-5]);
    indifference_point = getoptimalparameters.b;
    if counter>10
        break
    else
        counter = counter+1;
    end
end



end