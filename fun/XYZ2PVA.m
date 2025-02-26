function PVA = XYZ2PVA(para,XYZ)
time_step = para.sys.time_step;

n_time = length(XYZ);

PVA = nan(9,n_time);
% pos
PVA([1,4,7],:) = XYZ;

% vel
PVA([2,5,8],1:end-1) = diff(XYZ,1,2)/time_step;
PVA([2,5,8],end) = PVA([2,4,6],end-1);

% acc
PVA([3,6,9],1:end-2) = diff(XYZ,2,2)/time_step^2;
PVA([3,6,9],end-1) = PVA([2,4,6],end-2);
PVA([3,6,9],end) = PVA([2,4,6],end-2);