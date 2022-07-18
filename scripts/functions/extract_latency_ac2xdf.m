function [latency_ms, latency_measurement_time] = extract_latency_ac2xdf(PATH, name)
% Script to calculate latencies from openMHA's ac2xdf data
% Correspondence: steffen.dasenbrock@uol.de
%
% Developed in 9.11.0.1837725 (R2021b) Update 2
%-------------------------------------------------------------------------

% Search for file name
measurement_data_info = dir([PATH name '/' '*.xdf']);

% load raw audio, eeg and marker streams
eeg_stream = load_xdf([measurement_data_info(1).folder '/' measurement_data_info(1).name],'HandleClockSynchronization',false ,'HandleJitterRemoval',false ,'CorrectStreamLags',false ,'HandleClockResets',false);
marker_stream = load_xdf([measurement_data_info(2).folder '/' measurement_data_info(2).name],'HandleClockSynchronization',false ,'HandleJitterRemoval',false ,'CorrectStreamLags',false ,'HandleClockResets',false);

% sort each struct by time_series, time_stamps and clock_corrections
eeg_stream = sort_stream_entries(eeg_stream);
marker_stream = sort_stream_entries(marker_stream);

% put streams into one struct and % Sort streams into same order: (1) ac2lsl (2) trigger2lsl (3) EEG
streams{2} = combine_to_struct(eeg_stream);
streams{1} = combine_to_struct(marker_stream);

% Clean marker stream from zero time stamps
marker_indizes = find(streams{1}.time_stamps);
streams{1}.time_stamps = streams{1}.time_stamps(marker_indizes);
streams{1}.clock_corrections = streams{1}.clock_corrections(marker_indizes);

% Manual clock correction
streams = manual_clock_correction_ac2xdf(streams);
% marker from trigger2lsl need to be extracted
marker_time_stamps = extract_markers_from_trigger2lsl(streams{1},'CHANNEL0');

% reduce data to 3 hours+1min (10860 seconds)
range = 10860;
cut_point = streams{1}.time_stamps(1)+range;

for i=1:2
[~, min_index(i)] = min(abs(streams{i}.time_stamps- cut_point));
end

for i=1:2
    streams{i}.time_series = streams{i}.time_series(:,1:min_index(i));
    streams{i}.time_stamps = streams{i}.time_stamps(1:min_index(i));
    streams{i}.clock_corrections = streams{i}.clock_corrections(1:min_index(i));    
end

% extract epochs based on marker time stamps
[eeg_epochs, eeg_time_stamps, epoch_time_vector] = extract_eeg(streams{2},marker_time_stamps,'interpolate',true,'baseline_removal',true);

% Find rising edges in epochs
[rising_edges,maximum_height] = find_epoch_half_maximum(eeg_epochs',epoch_time_vector,false);
% calculate latency in ms
latency_ms = rising_edges*1000;
% store time stamp when this latency was measured
latency_measurement_time = eeg_time_stamps;
end