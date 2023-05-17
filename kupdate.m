function [xest, Pest, innov, S]=kupdate(xpred,Ppred,obs,beacons)
%
% function [xest, Pest, innov, S]=update(xpred,Ppred,obs,beacons)
%
% HDW 3/1/95 Modified 31/05/00
% function to update vehicle location 

globals;

[temp,N_OBS]=size(obs);
if temp ~= 4
  error('observation dimension of 4 expected')
end

[XSIZE,temp]=size(xpred);
if temp ~= 1
  error('xpred expected to be a column vector')
end

[s1,s2]=size(Ppred);
if((s1 ~= XSIZE)|(s2 ~=XSIZE))
  error('Ppred not of size XSIZE')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sigma_range=SIGMA_RANGE*SIGMA_RANGE;
sigma_bearing=SIGMA_BEARING*SIGMA_BEARING;

% first put observation in cartesian vehicle-centred coords
zv=[R_OFFSET+(obs(1)*cos(obs(2))); 
    obs(1)*sin(obs(2))];
T=[cos(obs(2)) -sin(obs(2)); 
   sin(obs(2)) cos(obs(2))];
sigma_o=[sigma_range 0; 
         0 sigma_bearing];
sigma_z=T*sigma_o*T';

index=obs(3);

h = @func_update;
h_param = {beacons,xpred(3),index};

n = size(xpred,1);
alpha = 0.5;
beta = 2;
kappa = 3-n;
mat = 0; 

w(1) =  sigma_range;
w(2) =  sigma_bearing*(obs(1)^2);

y(1) = obs(1);
y(2) = obs(2);
if (index)
    [xest,Pest,innov,~,S,~] = ukf_update1(xpred,Ppred,y',h,sigma_o,h_param,alpha,beta,kappa,mat);
    innov=zeros(2,1); 
else
    xest=xpred;
    Pest=Ppred;
    S=zeros(2,2);
    innov=zeros(2,1);
end

