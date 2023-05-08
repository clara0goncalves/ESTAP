% Generate example data
utrue = rand(4, 1686);
% Save data to a .mat file
save('utrue.mat', 'utrue');
% Generate example data
obs = rand(4, 1686);
beacons = rand(3, 4);

% Save data to .mat files
save('obs.mat', 'obs');
save('beacons.mat', 'beacons');
