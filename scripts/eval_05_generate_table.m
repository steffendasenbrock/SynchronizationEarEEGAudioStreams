%% Script generate table 1 containing metrics (lag, jitter, Delta_R)
% Authors: Steffen Dasenbrock, University of Oldenburg, Auditory Signal 
% Processing and Hearing Devices, Department of Medical Physics and 
% Acoustics , University of Oldenburg, Oldenburg, Germany
% 
% Correspondence: steffen.dasenbrock@uol.de
%
% Developed in 9.11.0.1837725 (R2021b) Update 2
%-------------------------------------------------------------------------
% Clear everything
clc, clear

% Load data
files = dir('./../derivates/*.mat');
for i= 1:numel(files)
    load([files(i).folder '/' files(i).name]);
end

% Put data into one struct
all_results{1} = labstreamer_results{1};
all_results{2} = labstreamer_results{2};
all_results{3} =  in_the_loop_results;

%% Create Table

num_measurements_per_experiment_short=5;
num_measurements_per_experiment_long=2;

%% 900 s measurements
for i=1:3
    for j=1:num_measurements_per_experiment_short
       lag_table(j,i) = all_results{1, i}{1, j}{1, 1}.lag_ms;
       jitter_table(j,i) = all_results{1, i}{1, j}{1, 1}.jitter;
       range_table(j,i) = all_results{1, i}{1, j}{1, 1}.range(2)-all_results{1, i}{1, j}{1, 1}.range(1);
    end
end

%% 3h measurements
for i=1:3
    for j=1:num_measurements_per_experiment_long
       lag_table_3h(j,i) = all_results{1, i}{2, j}{1, 1}.lag_ms;
       jitter_table_3h(j,i) = all_results{1, i}{2, j}{1, 1}.jitter;
       range_table_3h(j,i) = all_results{1, i}{2, j}{1, 1}.range(2)-all_results{1, i}{2, j}{1, 1}.range(1);
    end
end

% Create measurement number column
measurement_no = {'1','2','3','4','5','Delta_R','1','2','Delta_R'}';
measurement_no_table = table(measurement_no);

% Round for 900 s measurements
data_array_900s = (round([[lag_table], [jitter_table]].*100)/100);
data_table = array2table(data_array_900s);

% Round for 3 h measurements
data_array_3h = (round([[lag_table_3h], [jitter_table_3h]].*100)/100);
data_table_3h_table = array2table(data_array_3h);

% Calculate across-session ranges
range_row = round((max(data_array_900s)-min(data_array_900s))*100)/100;
range_row_3h = round((max(data_array_3h)-min(data_array_3h))*100)/100;
range_row_table = array2table(string(range_row)');

% Combine all information
combined_data_table = [measurement_no_table,array2table([data_array_900s;range_row;data_array_3h;range_row_3h])];

% Create duration column
table_info = {'15 min','15 min','15 min','15 min','15 min','15 min','3 h','3 h','3 h'}';
table_inf_table = table(table_info);
% Generate final metrics table
metrics_table = [table_inf_table,combined_data_table]

