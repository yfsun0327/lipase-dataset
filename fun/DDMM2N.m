function N = DDMM2N(DDMM)
if ~ismissing(DDMM)
    DDMM = convertStringsToChars(DDMM);
    DD = str2double(DDMM([1,2]));
    MM = str2double(DDMM(3:12));
    N = DD+MM/60;
else
    N = nan;
end