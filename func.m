function X = func(Xaug, f_param)
    globals;
    B = WHEEL_BASE;
    xest = Xaug(1:4);
    r = Xaug(3:end);
    % Making sure that are numbers for the calculations
    u = cell2mat(f_param(1:2));
    dt = cell2mat(f_param(6));

    % State prediction
    xpred(1) = xest(1) + dt * xest(4) * u(1) * (1 + r(1) + r(2)) * cos(xest(3) + u(2));
    xpred(2) = xest(2) + dt * xest(4) * u(1) * (1 + r(1) + r(2)) * sin(xest(3) + u(2));
    xpred(3) = xest(3) + dt * xest(4) * u(1) * (1 + r(1) + r(2)) * sin(u(2)) / B; 
    xpred(4) = xest(4);

    X = xpred';
end
