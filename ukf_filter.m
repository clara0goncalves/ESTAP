function [xest,Pest,xpred,Ppred,innov,innvar] = ukf_filter(obs,utrue,xinit,Pinit,beacons)

% State dimension
n = length(xinit);

% Number of time steps
K = size(obs,2);

% Allocate space for output variables
xest = zeros(n, K);
Pest = zeros(n, n, K);
xpred = zeros(n, K);
Ppred = zeros(n, n, K);
innov = zeros(size(obs));
innvar = zeros(size(obs));

% Initialize state estimate and covariance
xest(:,1) = xinit;
Pest(:,:,1) = Pinit;

% UKF parameters
alpha = 0.001;
beta = 2;
kappa = 0;

% Process and measurement noise covariance matrices
Q = diag([0.1, 0.1, 0.1, 0.1]);
%R = diag([0.1, 0.1]);
sigma_r = 0.05; 
sigma_phi = 0.03; 
sigma_rdot = 0.1; 
sigma_phidot = 0.01;
R = [sigma_r^2, 0, 0, 0;
     0, sigma_phi^2, 0, 0;
     0, 0, sigma_rdot^2, 0;
     0, 0, 0, sigma_phidot^2];


% Run UKF filter
for k = 1:K
    % Predict step
    [xpred(:, k), Ppred(:, :, k)] = ukf_predict2(xest(:, k), Pest(:, :, k), @pred_ukf, Q, utrue(:, k), alpha, beta, kappa);
    
    % Update step
    [xest(:, k+1), Pest(:, :, k+1), innov(:, k), innvar(:, k)] = ukf_update2(xpred(:, k), Ppred(:, :, k), @update_ukf, [], R, [], alpha, beta, kappa, []);
                                  
end

% Remove last estimate since it is not valid
xest = xest(:, 1:end-1);
Pest = Pest(:, :, 1:end-1);
xpred = xpred(:, 1:end-1);
Ppred = Ppred(:, :, 1:end-1);
innov = innov(:, 1:end-1);
innvar = innvar(:, 1:end-1);

end
