% this is an example run of the vehicle state filter

% initialise global values

globals;
ginit;

% first get all observations 
disp('Beginning observation simulations');
obs=obs_seq(xtrue,beacons);
disp('Completed Simulation');
% if(mode = 2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Codigo dde validação da simulação
state=xtrue;
[temp,SSIZE]=size(state);
figure(PLAN_FIG);
hold on
RMAX=R_MAX_RANGE;
for i = 1:SSIZE
    ind = 3;
    for j = 1:size(beacons, 1)
        if ind+1 <= size(obs, 1) && obs(ind+1, i) ~= 0 % check if ind+1 is within the bounds of obs and is not zero
            P1x = state(1, i) + (RMAX*cos(obs(ind, i) + state(3, i)));
            P1y = state(2, i) + (RMAX*sin(obs(ind, i) + state(3, i))); % fix typo: change cos to sin
            P2x = state(1, i) + (RMAX*cos(obs(ind+1, i) + state(3, i))); % fix typo: change P2y to P2x
            P2y = state(2, i) + (RMAX*sin(obs(ind+1, i) + state(3, i))); % fix typo: change cos to sin
            plot([P1x, P2x], [P1y, P2y], 'g');
            ind = ind + 2;

        else
            ind = ind + 1;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
%end


% place observations in a global coordinate system
[obs_p, state_p]=p_obs(obs,xtrue);
figure(PLAN_FIG);
hold on
%plot(obs_p(1,:),obs_p(2,:),'rx');
plot(state_p(1,:),state_p(2,:),'r+');
hold off


