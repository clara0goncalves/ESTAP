% this is an example run of the vehicle state filter

% initialise global values

globals;
ginit;

% first get all observations 
disp('Beginning observation simulations');
obs=obs_seq(xtrue,beacons);
disp('Completed Simulation');

% place observations in a global coordinate system
[obs_p, state_p]=p_obs(obs,xtrue);
figure(PLAN_FIG);
hold on
plot(obs_p(1,:),obs_p(2,:),'rx');
% plot(state_p(1,:),state_p(2,:),'r+');
hold off

%% Gyrocompass
[rows, columns_t] = size(xtrue);
gyro = size(2, columns_t);
t=0;

for i=1:columns_t
    if t==3
        gyro(1,i) = xtrue(3,i) + GSIGMA_HEADING*randn(size((xtrue(3,i)+OFFSET_GYRO))) + OFFSET_GYRO;
        gyro(2,i) = xtrue(4,i);
        t=0;
    end
    t=t+1;
end
