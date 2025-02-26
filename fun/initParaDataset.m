function para = initParaDataset(arr_time,arr_delay_up,arr_range_up,arr_Dop,CIT)
%% meta
para.meta.bolShowPlotToDetermProcessNoise = false;
para.meta.bolPlotAllvsTime = false;
para.meta.bolPlotPVvsTime = true;
para.meta.bolPlotRDAvsTime = true;
para.meta.modePlotDim = '2D';
para.meta.bSingleTargetTracking = true;

%% data
para.data.rdplot.folderNameRDPlot = 'data/data_RDPlot_210709';
para.data.rdplot.filenameRDPlot = 'data_RDPlot_210709_3_band_2_P_0_L_40_CIT_0.2_time_080_0.1_120.mat';
para.data.rdplot.fullFilenameRDPlot = sprintf('%s/%s',para.data.rdplot.folderNameRDPlot,para.data.rdplot.filenameRDPlot);
para.data.rdplot.folderNameRDPlotExampleBeforeCC = 'data/data_RDPlot_example_210709';
para.data.rdplot.filenameRDPlotExampleBeforeCC = 'RDPlotNoCC_46';
para.data.rdplot.fullFilenameRDPlotExampleBeforeCC = sprintf('%s/%s.mat', ...
    para.data.rdplot.folderNameRDPlotExampleBeforeCC,para.data.rdplot.filenameRDPlotExampleBeforeCC);
para.data.sat.folderNameSatellite = 'data/data_satellite/full';
para.data.sat.filenameSatellite = '19_0_0.jpg';
para.data.sat.fullFileNameSatellite = sprintf('%s/%s',para.data.sat.folderNameSatellite,para.data.sat.filenameSatellite);
para.data.gps.folderNameGPS = 'data/data_GPS_210709';
para.data.gps.filenameGPS = 'data_GPS_210709_3_time_080-120.log';
para.data.gps.fullFilenameGPS = sprintf('%s/%s',para.data.gps.folderNameGPS,para.data.gps.filenameGPS);

%% satellite
latlon_BS1 =  [22.604401049739874, 113.99638815831219];
latlon_BS2 =  [22.604390141589214, 113.9965329853361];
latlon_BS3 =  [22.604501394353886, 113.99662510704893];
latlon_Rx =  [22.604379436190428, 113.998893491968];
latlon_map = [22.60864,113.99258; 22.59725,114.00424]; % UL and DR of map
para.sat.height_BS = 0;
para.sat.height_Rx = 0;
para.sat.height_UAV = 0;
para.sat.orient_Rx = deg2rad(0);
para.sat.dxy = [1190,1270]; % map size [m]

mapInfo = imfinfo(para.data.sat.filenameSatellite);
size_map = [mapInfo.Height,mapInfo.Width];

latlim = latlon_map([2,1],1);
lonlim = latlon_map([1,2],2);
xlim_W = [0,para.sat.dxy(1)]-para.sat.dxy(1)*(latlon_Rx(2)-lonlim(1))/diff(lonlim);
ylim_W = [0,para.sat.dxy(2)]-para.sat.dxy(2)*(latlon_Rx(1)-latlim(1))/diff(latlim);
R_G2I = georefcells(latlim,lonlim,size_map);
R_I2W = imref2d(size_map,xlim_W,ylim_W);

[pix_BS1(1),pix_BS1(2)] = geographicToIntrinsic(R_G2I,latlon_BS1(1),latlon_BS1(2));
[pix_BS2(1),pix_BS2(2)] = geographicToIntrinsic(R_G2I,latlon_BS2(1),latlon_BS2(2));
[pix_BS3(1),pix_BS3(2)] = geographicToIntrinsic(R_G2I,latlon_BS3(1),latlon_BS3(2));
[pix_Rx(1),pix_Rx(2)] = geographicToIntrinsic(R_G2I,latlon_Rx(1),latlon_Rx(2));

[xyz_BS1(1),xyz_BS1(2)] = intrinsicToWorld(R_I2W,pix_BS1(1),pix_BS1(2));
[xyz_BS2(1),xyz_BS2(2)] = intrinsicToWorld(R_I2W,pix_BS2(1),pix_BS2(2));
[xyz_BS3(1),xyz_BS3(2)] = intrinsicToWorld(R_I2W,pix_BS3(1),pix_BS3(2));

height_BS_rel = para.sat.height_BS-para.sat.height_Rx;
height_UAV_rel = para.sat.height_UAV-para.sat.height_Rx;
xyz_BS1(3) = height_BS_rel;
xyz_BS2(3) = height_BS_rel;
xyz_BS3(3) = height_BS_rel;
xyz_Rx = [0,0,0];
para.sat.L = norm(xyz_Rx.'-xyz_BS1.');

para.sat.latlon_BS1 = latlon_BS1;
para.sat.latlon_BS2 = latlon_BS2;
para.sat.latlon_BS3 = latlon_BS3;
para.sat.latlon_Rx = latlon_Rx;
para.sat.latlon_map = latlon_map;
para.sat.R_G2I = R_G2I;
para.sat.R_I2W = R_I2W;
para.sat.xyz_BS1 = xyz_BS1;
para.sat.xyz_BS2 = xyz_BS2;
para.sat.xyz_BS3 = xyz_BS3;
para.sat.xyz_Rx = xyz_Rx;

%% system
para.sys.num_chan_ref = 4;
para.sys.num_chan_sur = 8;
para.sys.f_c = (2123+9.5)*1e6;
para.sys.lam = 3e8/para.sys.f_c;

para.sys.arr_time = arr_time;
para.sys.arr_delay_up = arr_delay_up;
para.sys.arr_range_up = arr_range_up;
para.sys.arr_Dop = arr_Dop;
para.sys.CIT = CIT;
para.sys.nRangeUp = length(arr_range_up);
para.sys.nDop = length(arr_Dop);
if isscalar(arr_time)
    para.sys.time_step = 0.1;
else
    para.sys.time_step = arr_time(2)-arr_time(1);
end

para.filter.funRrA2PVr = @(RrA)RrA2PVr_v3(RrA,xyz_BS1',height_BS_rel,height_UAV_rel,para.sat.orient_Rx);
para.filter.funPV2RrA = @(PV)PV2RrA_v3(PV,xyz_BS1',para.sat.orient_Rx);