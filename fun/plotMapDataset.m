function fig_map = plotMapDataset(para,XYZ_gps)
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