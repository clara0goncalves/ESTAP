function [xest,Pest,xpred,Ppred,innov,innvar] = ukf_filter(obs,utrue,xinit,Pinit,beacons,sigma_w,dt,u,kappa)

% UKF_FILTER Runs the Unscented Kalman Filter algorithm
%
%   [xest,Pest,xpred,Ppred,innov,innvar] = ukf_filter(obs,utrue,xinit,Pinit,beacons,sigma_w,dt,u,kappa)
%
%   This function runs the Unscented Kalman Filter algorithm on the input data.
%
%   INPUTS:
%   obs         : Measurement data
%   utrue       : Ground truth data
%   xinit       : Initial state estimate
%   Pinit       : Initial state covariance
%   beacons     : Beacon positions (3xN matrix)
%   sigma_w     : Process noise standard deviation
%   dt          : Sampling interval
%   u           : Control input (not used in this implementation)
%   kappa       : UKF parameter
%
%   OUTPUTS:
%   xest        : State estimate
%   Pest        : State covariance
%   xpred       : State prediction
%   Ppred       : State prediction covariance
%   innov       : Innovation
%   innovar     : Innovation covariance

n = size(xinit,1);
m = size(obs,1);

% Create the sigma points
[SP,W] = sigma_points(xinit,Pinit,kappa);

% Initialize the output variables
xest = zeros(n,length(obs));
Pest = zeros(n,n,length(obs));
xpred = zeros(n,length(obs));
Ppred = zeros(n,n,length(obs));
innov = zeros(m,length(obs));
innvar = zeros(m,m,length(obs));

% Run the UKF filter
for k = 1:length(obs)
    
    % Perform the prediction step
    xpred(:,k) = ukf_predict(xinit,Pinit,sigma_w,dt,u,kappa);
    [SP_pred,W_pred] = sigma_points(xpred(:,k),Ppred(:,:,k),kappa);
    [xpred(:,k),Ppred(:,:,k)] = unscented_transform(SP_pred,W_pred);
    
    % Perform the update step
    [SP_upd,W_upd] = sigma_points(xpred(:,k),Ppred(:,:,k),kappa);
    [xest(:,k),Pest(:,:,k)] = ukf_update(SP_upd,W_upd,obs(:,k),beacons);
    
    % Compute the innovation and innovation covariance
    innov(:,k) = obs(:,k) - beacons_to_range(beacons,xest(:,k));
    innovvar(:,:,k) = cov(innov(:,1:k)');
    
    % Update the sigma points and weights for the next iteration
    xinit = xest(:,k);
    Pinit = Pest(:,:,k);
    SP = SP_upd;
    W = W_upd;
    
end

end
