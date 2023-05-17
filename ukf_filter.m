function [xest,Pest,xpred,Ppred,innov,innvar] = ukf_filter(obs,utrue,xinit,Pinit,beacons)

globals;

[temp,N_OBS]=size(obs);
if temp ~= 4
  error('observation dimension of 4 expected')
end

[temp,N_U]=size(u);
if temp ~= 3
  error('control input vector of dimension 3 expected')
end
if N_U ~= N_OBS
  error('control and observation sequences of different length')
end

[XSIZE,temp]=size(xinit);
if temp ~= 1
  error('xinit expected to be a column vector')
end

[s1,s2]=size(Pinit);
disp(XSIZE)
if((s1 ~= XSIZE)|(s2 ~=XSIZE))
  error('Pinit not of size XSIZE')
end

% make some space
xpred=zeros(XSIZE,N_U);
xest=zeros(XSIZE,N_U);
innov=zeros(2,N_U);
innvar=zeros(2,2,N_U);
Ppred=zeros(XSIZE,XSIZE,N_U);
Pest=zeros(XSIZE,XSIZE,N_U);
% returns from pred and update are in the form of column vectors

xe=xinit;
Pe=Pinit;
time=0;

param = {w,dt,u,B};
n = size(xest,1);
alpha = 0.5;
beta = 2;
kappa = 3-n;
f = @func;


% Run UKF filter
for i=1:N_OBS
    % Predict step
    [xpred,Ppred] = ukf_predict2(xest,Pest,f,[],[param,alpha,beta,kappa]);
    
    % Update step
    [xest(:, k+1), Pest(:, :, k+1), innov(:, k), innvar(:, k)] = ukf_update2(xpred,Ppred, obs,@update_ukf,R,h_param,alpha,beta,kappa,mat);
    %[xest(:, k+1), Pest(:, :, k+1), innov(:, k), innvar(:, k)] = ukf_update2(xpred(:, k), Ppred(:, :, k), obs, @update_ukf, R, h_param, alpha, beta, kappa, mat);                                                                                                
end

for i=1:N_OBS
   dt=u(3,i)-time;
   time=u(3,i);
   [xp Pp]=pred(xe,Pe,dt,u(:,i));
   [xe, Pe, in, ins]=kupdate(xp,Pp,obs(:,i),beacons);
   xpred(:,i)=xp;
   xest(:,i)=xe;
   innov(:,i)=in;
   Ppred(:,:,i)=Pp;
   Pest(:,:,i)=Pe;
   innvar(:,:,i)=ins;
end
