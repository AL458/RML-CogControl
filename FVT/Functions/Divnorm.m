function out = Divnorm(in,subjarr)

subjs = unique(subjarr);
out = nan(size(in));
for i = 1:length(subjs)
    c = subjs(i);
    inds = subjarr==c;
    out(inds) = in(inds)./sum(abs(in(inds))); % divisive normalization
end
    

end