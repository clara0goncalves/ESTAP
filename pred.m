function [xpred, Ppred] = pred(xest, Pest, dt, u)
    % definitions and checks
    globals;

    [XSIZE, temp] = size(xest);
    if temp ~= 1
        error('xest expected to be a column vector');
    end

    [s1, s2] = size(Pest);
    if (s1 ~= XSIZE) || (s2 ~= XSIZE)
        error('Pest not of size XSIZE');
    end

    % set parameters
    B = WHEEL_BASE;
    % SD's to variances
    sigma_q = SIGMA_Q * SIGMA_Q;
    sigma_w = SIGMA_W * SIGMA_W;
    sigma_s = SIGMA_S * SIGMA_S;
    sigma_g = SIGMA_G * SIGMA_G;
    sigma_r = SIGMA_R * SIGMA_R; % wheel radius variance

    % make some space
    %xpred = zeros(XSIZE, 1);
    %Ppred = zeros(XSIZE, XSIZE);

    w(1) = sigma_q;
    w(2) = sigma_w;
    w(3) = sigma_s;
    w(4) = sigma_g;
    w(5) = sigma_r;

    w = w.^2;

    Q = diag([sigma_q, sigma_w, sigma_s, sigma_g, sigma_r]);

    % state transition matrix evaluation
    F = [1, 0, -dt * xest(4) * u(1) * sin(xest(3) + u(2)), dt * u(1) * cos(xest(3) + u(2));
         0, 1, dt * xest(4) * u(1) * cos(xest(3) + u(2)), dt * u(1) * sin(xest(3) + u(2));
         0, 0, 1, dt * u(1) * sin(u(2)) / B;                   
         0, 0, 0, 1];

    % source error covariance
    sigma = [(sigma_q * (xest(4) * u(1))^2) + (sigma_w * (xest(4))^2), 0, 0, 0;
             0, (sigma_s * (xest(4) * u(1) * u(2))^2) + (sigma_g * (xest(4) * u(1))^2), 0, 0;
             0, 0, sigma_r, 0;
             0, 0, 0, 0];

    % stabalistation noise 
    stab = [0.000, 0, 0, 0;
            0, 0.000, 0, 0;
            0, 0, 0, 0;
            0, 0, 0, 0];

    % Now compute prediction covariance
    % Ppred = F * Pest * F' + G * sigma * G' + stab;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % UKF
    param = {w, dt, u, B};
    n = size(xest, 1);
    alpha = 0.5;
    beta = 2;
    kappa = 0;
    [xpred, Ppred] = ukf_predict2(xest, Pest, @func, Q, [param, alpha, beta, kappa]);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%

end