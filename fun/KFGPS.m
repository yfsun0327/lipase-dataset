function XYZ_gps = KFGPS(para,XYZ_gps)
n_time = length(XYZ_gps);
T = para.sys.time_step;
motionModel = '3D Constant Velocity';

p0 = XYZ_gps(:,1);
v0 = diff(XYZ_gps(:,1:2),1,2);
a0 = diff(XYZ_gps(:,1:3),2,2);
switch motionModel
    case '3D Constant Velocity'
        initialState = [p0(1),v0(1),p0(2),v0(2),p0(3),v0(3)]';
    case '3D Constant Acceloration'
        initialState = [p0(1),v0(1),a0(1),p0(2),v0(2),a0(2),p0(3),v0(3),a0(3)]';
end
processNoise = 10;
measurementNoise = 1e-1;

KF = trackingKF('MotionModel','3D Constant Velocity', ...
    'State',initialState, ...
    'ProcessNoise',processNoise, ...
    'MeasurementNoise',measurementNoise);

for idx_time = 1:n_time
    pstates(:,idx_time) = predict(KF,T);
    cstates(:,idx_time) = correct(KF,XYZ_gps(:,idx_time));
end

XYZ_gps = cstates([1,3,5],:);
% XYZ_gps = cstates([1,4,7],:);