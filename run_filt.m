globals;
ginit;

disp('Press return to run filter');
pause;

%initial_errors=[5; 5; 0.2; 0.1]
% initialise filter
xinit=xtrue(:,1);
xinit(4,1)=WHEEL_RADIUS;
%xinit=xinit+initial_errors;

Pinit= [0.024 0.0   0.0     0.0;
        0.0   0.024 0.0     0.0;
        0.0   0.0   0.00025 0.0;
        0.0   0.0   0.0     0.0001];
% Check input arguments
%{
assert(ismatrix(obs) && size(obs,1) == 4, 'obs must be a 2-by-N matrix');
assert(isnumeric(u) && ismatrix(u) && size(u,1) == 4, 'u must be a 2-by-N matrix');
assert(isvector(xinit) && length(xinit) == 4, 'xinit must be a 2-element vector');
assert(ismatrix(Pinit) && all(size(Pinit) == [4 4]), 'Pinit must be a 2-by-2 matrix');
assert(isstruct(beacons) && isscalar(beacons), 'beacons must be a scalar structure');
%}

%run filter     
[xest,Pest,xpred,Ppred,innov,innvar] = ukf_filter(obs,utrue,xinit,Pinit,beacons);



disp('Completed Filtering')



        