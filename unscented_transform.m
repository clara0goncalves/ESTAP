function [x,P] = unscented_transform(SP,W)
% UNSCENTED_TRANSFORM Calculates the mean and covariance of the sigma points
%
%   [x,P] = unscented_transform(SP,W)
%
%   This function calculates the mean and covariance of the sigma points
%   using the Unscented Transform.
%
%   INPUTS:
%   SP  : Sigma points (nxnpts matrix)
%   W   : Vector of weights (1xnpts)
%
%   OUTPUTS:
%   x   : Mean of sigma points (nx1 vector)
%   P   : Covariance of sigma points (nxn matrix)

    n = size(SP,1);
    npts = size(SP,2);
    
    % Calculate the mean of the sigma points
    x = zeros(n,1);
    for i = 1:npts
        x = x + W(i)*SP(:,i);
    end
    
    % Calculate the covariance of the sigma points
    P = zeros(n,n);
    for i = 1:npts
        diff = SP(:,i) - x;
        P = P + W(i)*(diff*diff');
    end
    P = P + eye(n)*eps; % Add a small amount to diagonal to ensure P is positive definite
end
