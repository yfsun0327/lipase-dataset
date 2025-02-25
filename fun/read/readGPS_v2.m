function m2PosGPS = readGPS_v2(para)
fullFilenameGPS = para.data.gps.fullFilenameGPS;
R_G2I = para.sat.R_G2I;
R_I2W = para.sat.R_I2W;

m2rDataGPS = readmatrix(fullFilenameGPS, ...
    'FileType','delimitedtext', ...
    'Delimiter',',', ...
    'Range',[1,1], ...
    'OutputType','string');
m2rDataGPS = m2rDataGPS(:,[2,3,5,10]);

[nFrame,~] = size(m2rDataGPS);
m2DataGPS = nan(nFrame,4);
for i = 1:nFrame
    m2DataGPS(i,1) = HHMMSS2N(m2rDataGPS(i,1));
    m2DataGPS(i,2) = DDMM2N(m2rDataGPS(i,2));
    m2DataGPS(i,3) = DDDMM2N(m2rDataGPS(i,3));
    m2DataGPS(i,4) = str2double(m2rDataGPS(i,4));
end

m2PosGPS = nan(nFrame,3);
[m2PosGPS(:,1),m2PosGPS(:,2)] = geographicToIntrinsic(R_G2I,m2DataGPS(:,2),m2DataGPS(:,3));
[m2PosGPS(:,1),m2PosGPS(:,2)] = intrinsicToWorld(R_I2W,m2PosGPS(:,1),m2PosGPS(:,2));
end

% GPGGA格式
% 例：$GPGGA,092204.999,4250.5589,S,14718.5084,E,1,04,24.4,19.7,M,,,,0000*1F
% 字段1：UTC 时间，hhmmss.sss，时分秒格式 
% 字段2：纬度ddmm.mmmm，度分格式（前导位数不足则补0） 
% 字段4：经度dddmm.mmmm，度分格式（前导位数不足则补0）
% 字段9：海拔高度（-9999.9 - 99999.9） 