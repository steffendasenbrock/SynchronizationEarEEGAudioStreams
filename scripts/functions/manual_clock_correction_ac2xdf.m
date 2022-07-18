function streams = manual_clock_correction_ac2xdf(streams)
% This function adds the most recent clock correction offset value
% to the time stamp value
% 
% Correspondence: steffen.dasenbrock@uol.de
%
% Developed in 9.11.0.1837725 (R2021b) Update 2
%-------------------------------------------------------------------------


for i=1:numel(streams)
    % correct time stamps by adding clock correction values
    streams{1,i}.time_stamps = streams{1,i}.time_stamps+streams{1,i}.clock_corrections;
end

end