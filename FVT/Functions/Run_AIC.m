function p = Run_AIC(dataset)
% Function for getting a structure detailing the AIC statistics and the
% best fitting polynomial

% Get AIC for the dACC activity foraging value bin analysis

datasettouse = dataset.fulltable_FV;
datasettouse.bintouse = datasettouse.bin_FV;

nparts = length(unique(datasettouse.Subject_ID));
nbins = length(unique(datasettouse.bintouse));

partarr = unique(datasettouse.Subject_ID);
binarr = unique(datasettouse.bintouse);

divnorm = zeros(nparts,nbins,3);

for partind = 1:nparts
    currpart = partarr(partind);
    for binind = 1:nbins
        currbin = binarr(binind);
        divnorm(currpart,currbin,3) = datasettouse.dACC(datasettouse.bintouse==currbin&datasettouse.Subject_ID==currpart);
    end
end

p_FV = get_AIC_divnorm(divnorm);

% Get AIC for the dACC activity difficulty bin analysis

datasettouse = dataset.fulltable_diff;
datasettouse.bintouse = datasettouse.bin_diff;

nparts = length(unique(datasettouse.Subject_ID));
nbins = length(unique(datasettouse.bintouse));

partarr = unique(datasettouse.Subject_ID);
binarr = unique(datasettouse.bintouse);

divnorm = zeros(nparts,nbins,3);

for partind = 1:nparts
    currpart = partarr(partind);
    for binind = 1:nbins
        currbin = binarr(binind);
        divnorm(currpart,currbin,3) = datasettouse.dACC(datasettouse.bintouse==currbin&datasettouse.Subject_ID==currpart);
    end
end

p_diff = get_AIC_divnorm(divnorm);

p.dACC_FV = p_FV;
p.dACC_diff = p_diff;

% Get AIC for the boost activity foraging value bin analysis

datasettouse = dataset.fulltable_FV;
datasettouse.bintouse = datasettouse.bin_FV;

nparts = length(unique(datasettouse.Subject_ID));
nbins = length(unique(datasettouse.bintouse));

partarr = unique(datasettouse.Subject_ID);
binarr = unique(datasettouse.bintouse);

divnorm = zeros(nparts,nbins,3);

for partind = 1:nparts
    currpart = partarr(partind);
    for binind = 1:nbins
        currbin = binarr(binind);
        divnorm(currpart,currbin,3) = datasettouse.Boost(datasettouse.bintouse==currbin&datasettouse.Subject_ID==currpart);
    end
end

p_FV = get_AIC_divnorm(divnorm);


% Get AIC for the boost activity difficulty bin analysis

datasettouse = dataset.fulltable_diff;
datasettouse.bintouse = datasettouse.bin_diff;

nparts = length(unique(datasettouse.Subject_ID));
nbins = length(unique(datasettouse.bintouse));

partarr = unique(datasettouse.Subject_ID);
binarr = unique(datasettouse.bintouse);

divnorm = zeros(nparts,nbins,3);

for partind = 1:nparts
    currpart = partarr(partind);
    for binind = 1:nbins
        currbin = binarr(binind);
        divnorm(currpart,currbin,3) = datasettouse.Boost(datasettouse.bintouse==currbin&datasettouse.Subject_ID==currpart);
    end
end

p_diff = get_AIC_divnorm(divnorm);

p.boost_FV = p_FV;
p.boost_diff = p_diff;

end