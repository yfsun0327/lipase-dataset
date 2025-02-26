function N = DDDMM2N(DDDMM)
if ~ismissing(DDDMM)
    DDDMM = convertStringsToChars(DDDMM);
    DDD = str2double(DDDMM(1:3));
    MM = str2double(DDDMM(4:13));
    N = DDD+MM/60;
else
    N = nan;
end
