function [SP,W] = sigma_points(x,P,kappa)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

n = numel(x);
SP = zeros(n,2*n+1);
W = zeros(1,2*n+1);

mat1 = sqrt(n+kappa)*chol(P)';
mat2 = -mat1;

SP(:,1) = x;
SP(:,2:n+1) = [mat1, mat2];
W(1) = kappa/(n+kappa);
W(2:2*n+1) = 1/(2*(n+kappa));

end
