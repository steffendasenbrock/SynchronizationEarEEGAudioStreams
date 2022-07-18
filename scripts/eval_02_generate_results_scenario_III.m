%% Processing script for in-the-loop timing test
% Authors: Steffen Dasenbrock, University of Oldenburg, Auditory Signal 
% Processing and Hearing Devices, Department of Medical Physics and 
% Acoustics , University of Oldenburg, Oldenburg, Germany
% 
% Correspondence: steffen.dasenbrock@uol.de
%
% Developed in 9.11.0.1837725 (R2021b) Update 2
%-------------------------------------------------------------------------
% Clear 
clear
% Look for all available data
search_strings = {'900s','3h'};
DIR = './../rawdata/03_in_the_loop_timing/';
for i = 1:2
    rawdata_list{i} = dir([DIR '/*' search_strings{i} '*']);        
end

% loop through all list entries of available data, extract latency_ms, lag,
% jitter and range, save into a struct
for j=1:numel(search_strings)
    for i=1:numel(rawdata_list{j})
    % extract latency_ms as function of measurement time
    [latency_ms, latency_measurement_time] = extract_latency_ac2xdf(DIR, rawdata_list{1,j}(i).name);
    % store time
    in_the_loop_results{j,i}{1,1}.time = latency_measurement_time;
    % store latency
    in_the_loop_results{j,i}{1,1}.latency = latency_ms;
    % calculate and store lag
    in_the_loop_results{j,i}{1,1}.lag_ms = mean(latency_ms);
    % calculate and store jitter
    in_the_loop_results{j,i}{1,1}.jitter = std(latency_ms);
    % calculate and store range
    in_the_loop_results{j,i}{1,1}.range = [min(in_the_loop_results{j,i}{1,1}.latency) max(in_the_loop_results{j,i}{1,1}.latency)];
    end
end

%% Save to results struct
save('./../derivates/in_the_loop_results','in_the_loop_results')
