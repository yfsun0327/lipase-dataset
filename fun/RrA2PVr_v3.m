function PVr = RrA2PVr_v3(RrA,F1,height_BS_rel,height_UAV_rel,orient_Rx)
n = numel(RrA)/3;
PVr = nan(6,n);
m2RotMtx = [...
    cos(orient_Rx),-sin(orient_Rx),0;
    sin(orient_Rx), cos(orient_Rx),0;
    0,              0,             1];
% orient_Rx conpensation is tbd

if n>0
    phi = atan(F1(2)/-F1(1));

    R = RrA(1,:);
    RR = RrA(2,:);
    AoA = RrA(3,:);

    P = nan(3,n);
    Vr = nan(3,n);
    F1(3) = height_BS_rel;

    L = norm(F1);
    a = (R+L)/2;
    c = L/2;
    ee = c./a;
    r = (a.*(1-ee.^2))./(1+ee.*cos(AoA-phi));
    P(1,:) = r.*cos(AoA);
    % P(2,:) = r.*sin(AoA);
    P(2,:) = sign(AoA).*sqrt(r.^2.*sin(AoA).^2-height_UAV_rel^2);
    P(3,:) = height_UAV_rel;
    
    unitVec_rad = P./vecnorm(P,2,1) + (P-F1)./vecnorm(P-F1,2,1);
    unitVec_rad = unitVec_rad./vecnorm(unitVec_rad,2,1);
    Vr = RR.*unitVec_rad;
    Vr(3,:) = 0;
    
    PVr([1,3,5],:) = P;
    PVr([2,4,6],:) = Vr;
end

temp = size(RrA);
temp(1) = 6;
PVr = reshape(PVr,temp);

if any(isnan(PVr))
    fprintf('error.\n')
end