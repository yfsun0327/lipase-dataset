function HHMMSS = N2HHMMSS(N)
HH = sprintf('%02d',floor(N/3600));
MM = sprintf('%02d',mod(floor(N/60),60));
SS = sprintf('%02.2f',mod(N,60));
HHMMSS = sprintf('%s%s%s',HH,MM,SS);
