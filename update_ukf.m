%{
function [y, H] = update_ukf(x, beacons)
nb = size(beacons, 2);
y = zeros(2*nb, 1);
H = zeros(2*nb, 4);
for i = 1:nb
    dx = x(1) - beacons(1,i);
    dy = x(2) - beacons(2,i);
    r = sqrt(dx^2 + dy^2);
    y(2*i-1:2*i) = [r; atan2(dy, dx) - x(4)];
    H(2*i-1:2*i,:) = [-dx/r -dy/r 0 0; dy/r^2 -dx/r^2 0 -1];
end
%}
function [zpred] = update_ukf(xpred,h_param)

    beacons = h_param{1};
    theta = h_param{2};
    index = h_param{3};
    sigma_gyro = h_param{4};

    zpred = zeros(2,1);
    
    dx=beacons(index,1)-xpred(1); 
    dy=beacons(index,2)-xpred(2);
    
    pl = [beacons(index,1);beacons(index,2)];
    xpred_array = [xpred(1);xpred(2)];
    
    zpred(1) = sqrt((pl-xpred_array)'*(pl-xpred_array));
    zpred(2) = atan2(dy,dx)-theta;
    
    xpred(3) = xpred(3)+xpred(5)+sigma_gyro;
   
end

