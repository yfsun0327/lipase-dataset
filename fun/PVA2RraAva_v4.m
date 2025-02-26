function RraAva = PVA2RraAva_v4(para,PVA)
% (X,Y,Z) to (Range, Range rate, Range acceloration, AoA, AoA rate, AoA acceloration)
funPV2RrA = para.filter.funPV2RrA;
time_step = para.sys.time_step;

n_time = length(PVA);

PV = PVA([1,2,4,5,7,8],:);
RrA = funPV2RrA(PV);

RraAva = nan(6,n_time);
RraAva([1,2,4],:) = RrA;
% range acc
RraAva(3,1:end-1) = diff(RraAva(2,:),1,2)/time_step;
RraAva(3,end) = RraAva(3,end-1);
% AoA rate
RraAva(5,1:end-1) = diff(RraAva(4,:),1,2)/time_step;
RraAva(5,end) = RraAva(5,end-1);
% AoA acc
RraAva(6,1:end-1) = diff(RraAva(5,:),1,2)/time_step;
RraAva(6,end) = RraAva(6,end-1);