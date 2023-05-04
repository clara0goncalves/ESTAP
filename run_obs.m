% this is an example run of the vehicle state filter

% initialise global values

globals;
ginit;

% first get all observations 
disp('Beginning observation simulations');
obs=obs_seq(xtrue,beacons);
disp('Completed Simulation');

% if(mode = 2)
state=xtrue;
[temp,SSIZE]=size(state);
figure(PLAN_FIG);
hold on
RMAX=R_MAX_RANGE;
for i= 1:SSIZE
        ind=4;
    for j=1:size(beacons,1)
      if obs(ind+1,i) ~= 0
        P1x=state(1,i)+(RMAX*cos(obs(ind,i)+state(3,i)));
        P1y=state(2,i)+(RMAX*cos(obs(ind,i)+state(3,i)));
        P1y=state(1,i);
        P2y=state(1,i);
        plot([P1x, P2x], [P1y, P2y], 'g');
        ind=ind+2;
      end
    end
end
%end


% place observations in a global coordinate system
[obs_p, state_p]=p_obs(obs,xtrue);
figure(PLAN_FIG);
hold on
plot(obs_p(1,:),obs_p(2,:),'rx');
% plot(state_p(1,:),state_p(2,:),'r+');
hold off
