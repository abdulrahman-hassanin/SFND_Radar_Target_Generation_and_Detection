
% TODO : Find the Bsweep of chirp for 1 m resolution
c = 3*10^8;     % speed of light
delta_r = 1;    % range resoluution in meter
Bsweep = (c*delta_r)/2;

% TODO : Calculate the chirp time based on the Radar's Max Range
maxRange = 300;
Ts = (5.5*2*maxRange) /c;

% TODO : define the frequency shifts 
beat_freq = [0, 1.1, 13, 24] .* 1e6;
calculated_range = (c*Ts*beat_freq) / (2*Bsweep);

% Display the calculated range
disp(calculated_range);
