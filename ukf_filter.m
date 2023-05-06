function [xest, Pest, xpred, Ppred, innov, innvar] = ukf_filter(obs,u,xinit,Pinit,beacons)
% Input validation

% More input validation code if necessary
%UKF_FILTER - Apply unscented Kalman filter to the input data
%
% Syntax:
%   [xest,Pest,xpred,Ppred,innov,innvar] = ukf_filter(obs,u,xinit,Pinit,beacons)
%
% In:
%   obs     - Observations, D x N matrix
%   u       - Control input, M x N matrix
%   xinit   - Initial state mean, Dx1 column vector
%   Pinit   - Initial state covariance, DxD matrix
%   beacons - Beacon locations, DxL matrix
%
% Out:
%   xest    - State estimate, DxN matrix
%   Pest    - State covariance, DxDxN matrix
%   xpred   - Predicted state estimate, DxN matrix
%   Ppred   - Predicted state covariance, DxDxN matrix
%   innov   - Innovations, D x N matrix
%   innvar  - Innovation variances, 1 x N vector
%
% Description:
%   Applies an unscented Kalman filter to the input data, using the given
%   initial state mean and covariance. The filter uses the provided control
%   inputs to propagate the state estimate forward in time.
%
%   The observations are assumed to consist of the noisy positions of a set of
%   beacons in a D-dimensional space, which are measured by a moving sensor
%   over time. The sensor's motion is captured by the control inputs.
%
%   The function returns the state estimate, the state covariance, the predicted
%   state estimate, the predicted state covariance, the innovations, and the
%   innovation variances.
%
%   This implementation of the UKF follows the formulation presented in:
%
%   S. Julier and J. Uhlmann, "A New Extension of the Kalman Filter to
%   Nonlinear Systems," in Proc. AeroSense: The 11th International
%   Symposium on Aerospace/Defense Sensing, Simulation and Controls,
%   vol. 3065, Orlando, FL, April 1997.
%
% See also UKF_PREDICT2 UKF_UPDATE2
globals;
N = size(obs, 2);

% Dimensionality of the state space
D = length(xinit);

% Process noise covariance matrix
sigma_w = 0.01;

% Unscented transform parameters
alpha = 0.1;
beta = 2;
kappa = 0;

% Allocate arrays for output variables
xest = zeros(D, N);
Pest = zeros(D, D, N);
xpred = zeros(D, N);
Ppred = zeros(D, D, N);
innov = zeros(4, N);
innvar = zeros(1, N);

% Initialize state estimate and covariance
x = xinit;
P = Pinit;

% Define prediction function
f = @pred_func

% Process noise covariance matrix
Q = diag([sigma_w, sigma_w, sigma_w/10]);

% Loop over time steps
for k = 1:N
    
    % Predict step
    [xpred(:, k), Ppred(:, :, k)] = ukf_predict2(x, P, f, Q, u(:, k), alpha, beta, kappa);

    % Update step
    [x, P, innov(:, k), innvar(k)] = ukf_update2(obs(:, k), xpred(:, k), Ppred(:, :, k), beacons, alpha, beta, kappa);
    
    % Save estimates
    xest(:, k) = x;
    Pest(:, :, k) = P;

end


end
