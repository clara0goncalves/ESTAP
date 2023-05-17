function [zpred] = func_update(xpred,h_param)

    beacons = h_param{1};
    theta = h_param{2};
    index = h_param{3};
    zpred = zeros(2,1);

    dx=beacons(index,1)-xpred(1); 
    dy=beacons(index,2)-xpred(2);
    
    pl = [beacons(index,1);beacons(index,2)];
    xpred_array = [xpred(1);xpred(2)];
    
    zpred(1) = sqrt((pl-xpred_array)'*(pl-xpred_array));
    zpred(2) = atan2(dy,dx)-theta;
  
end

