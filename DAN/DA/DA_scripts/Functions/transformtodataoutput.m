function persubj_dACC = transformtodataoutput(persubj_diff)
% Transforms persubj_diff into a nparts * nbins structure, to be more in
% line with the data output from the DDM and DAN fitting

partlist = unique(persubj_diff.Subject_ID);
nparts = length(partlist);
binlist = unique(persubj_diff.Difficulty_bin);
nbins = length(binlist);

persubj_dACC = zeros(nparts,nbins);

for partind = 1:nparts
    currpart = partlist(partind);
    for binind = 1:nbins
        currbin = binlist(binind);
        persubj_dACC(partind,binind) = persubj_diff.dACC(persubj_diff.Subject_ID==currpart&persubj_diff.Difficulty_bin==currbin);
    end
end
