function RrA = PV2RrA_v3(PV,F1,orient_Rx)
m2RotMtx = [...
    cos(orient_Rx),-sin(orient_Rx),0;
    sin(orient_Rx), cos(orient_Rx),0;
    0,              0,             1];

n = numel(PV)/6;
RrA = nan(3,n);
if n~=0
    P = PV([1,3,5],:);
    V = PV([2,4,6],:);

    L = norm(F1);
    
    RrA(1,:) = vecnorm(P,2,1)+vecnorm(P-F1,2,1)-L;
    vec_rad = P./vecnorm(P,2,1) + (P-F1)./vecnorm(P-F1,2,1);
    RrA(2,:) = dot(vec_rad,V,1);
    % RrA(3,:) = atan2(-vecnorm(P([2,3],:),2,1),P(1,:));
    PP = m2RotMtx*P;
    RrA(3,:) = 2*pi-atan2(vecnorm(PP([2,3],:),2,1),PP(1,:));
    RrA(3,:) = RrA(3,:)-orient_Rx;
    RrA(3,:) = wrapToPi(RrA(3,:));
end

temp = size(PV);
temp(1) = 3;
RrA = reshape(RrA,temp);