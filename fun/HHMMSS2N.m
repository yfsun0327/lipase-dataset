function N = HHMMSS2N(HHMMSS)
HHMMSS = convertStringsToChars(HHMMSS);
HH = str2double(HHMMSS([1,2]));
MM = str2double(HHMMSS([3,4]));
SS = str2double(HHMMSS(5:9));
N = HH*3600+MM*60+SS;
