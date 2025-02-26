close all; clear; clc;
format compact; 
addpath(genpath('fun'),genpath('data')); 
rng(14);
warning('off','all'); 

%% Load RD Plots
folderNameRDPlot = 'data/data_RDPlot_210709';
filenameRDPlot = 'data_RDPlot_210709_3_band_2_P_0_L_40_CIT_0.2_time_080_0.1_120.mat';
fullFilenameRDPlot = sprintf('%s/%s',folderNameRDPlot,filenameRDPlot);
cVarLoad = {'arr_time','arr_delay_up','arr_range_up','arr_Dop','CIT','A_TeRD'};
load(fullFilenameRDPlot,cVarLoad{:})

%% Init para
para = initParaDataset(arr_time,arr_delay_up,arr_range_up,arr_Dop,CIT);

%% Plot a sample RD Plot
fig_CFAR = figure('Position',[0001,0041,0400,0400],'Name','CFAR Detection');
for idx_frame = 1
    for idx_sec = 1
        temp = abs(squeeze(A_TeRD(idx_frame,idx_sec,:,:))).^2;
        temp = mag2db(abs(temp));
        temp = temp-max(temp,[],'all');

        h = imagesc(arr_Dop,arr_range_up,temp);
        xlim([arr_Dop(1),arr_Dop(end)])
        ylim([0,arr_range_up(end)])
        clim([-20,0])
        xticks(arr_Dop(1):50:arr_Dop(end))
        yticks(arr_range_up(1):80:arr_range_up(end))
        h.Parent.YDir = 'normal';
        colorbar('Location','east')
    end
end

%% Plot Map
% load GPS data
XYZ_gps = readGPS_v2(para)';
XYZ_gps(3,:) = para.sat.height_UAV-para.sat.height_Rx;
XYZ_gps = KFGPS(para,XYZ_gps);

PVA_gps = XYZ2PVA(para,XYZ_gps);
RraAva_gps = PVA2RraAva_v4(para,PVA_gps);
RrA_gps = RraAva_gps([1,2,4],:);

% Plot Map
fullFileNameSatellite = para.data.sat.fullFileNameSatellite;
xyz_BS1 = para.sat.xyz_BS1;
xyz_Rx = para.sat.xyz_Rx;
R_I2W = para.sat.R_I2W;
map = flip(im2double(imread(fullFileNameSatellite)),1);

fig_map = figure('Name','Map','Position',[0401,0041,0400,0400]);
image(R_I2W.XWorldLimits,R_I2W.YWorldLimits,map,'AlphaData',0.7)
hold on
hTx = scatter(xyz_BS1(1),xyz_BS1(2), ...
    'Marker','s','SizeData',50,'MarkerEdgeColor',[0,0,0],'MarkerFaceColor',[1,1,0],'DisplayName','BS');
hRx = scatter(xyz_Rx(1),xyz_Rx(2), ...
    'Marker','s','SizeData',50,'MarkerEdgeColor',[0,0,0],'MarkerFaceColor',[0,1,0],'DisplayName','Rx');
h1 = plot(XYZ_gps(1,:),XYZ_gps(2,:), ...
    'Color','k', ...
    'DisplayName','GPS');

legend
xlabel('X (m)')
ylabel('Y (m)')
xlim([-80,80])
ylim([-120,60])
set(gca,'YDir','Normal')




