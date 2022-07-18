%% Processing script for Sender instance timing and EEG system timing
% Authors: Steffen Dasenbrock, University of Oldenburg, Auditory Signal 
% Processing and Hearing Devices, Department of Medical Physics and 
% Acoustics , University of Oldenburg, Oldenburg, Germany
% 
% Correspondence: steffen.dasenbrock@uol.de
%
% Developed in 9.11.0.1837725 (R2021b) Update 2
%-------------------------------------------------------------------------

% Search for all data which has 900s at the end
DIR = './../rawdata/';
experiments = {'01_stimulus_presentation_timing','02_eeg_system_timing'};
search_strings = {'900s','3h'};
measurement_ranges = {[1:900], [1:10700]};

%% Loop through all experiments

for exp=1:2 % loop through all experimentsx
    labstream = {};
    for j=1:numel(search_strings)
        rawdata_list = dir([DIR experiments{exp} '/*' search_strings{j} '*.txt']);        
            for i=1:numel(rawdata_list)
                % load into one struct
                if exp==1
                   labstream{j,i} = import_labstreamer_data([rawdata_list(i).folder '/' rawdata_list(i).name]);
                end
                if exp==2
                   labstream{j,i} = import_labstreamer_data([rawdata_list(i).folder '/' rawdata_list(i).name],'EEG_isolated',true);
                end
            end        
    end
    all_data{exp} = labstream;
end

% remove NaNs
for exp=1:2 % loop through all experiments
    for j=1:size(all_data{1, exp},1)
            for i=1:size(all_data{1, exp},2)
                if(~isempty(all_data{1, exp}{j, i}))
                nan_indices = ~isnan(all_data{1, exp}{j,i}{1,1}.latency);
                all_data{1, exp}{j,i}{1,1}.latency = all_data{1, exp}{j,i}{1,1}.latency(nan_indices);
                all_data{1, exp}{j,i}{1,1}.network_unc_ms  = all_data{1, exp}{j,i}{1,1}.network_unc_ms(nan_indices); 
                all_data{1, exp}{j,i}{1,1}.time = all_data{1, exp}{j,i}{1,1}.time(nan_indices);   
                %labstream = remove_NAN_latencies(labstream)
                end
            end
    end
end

% calculate lag, jitter and range for every measurement
for exp=1:2 % loop through all experiments    
        for j=1:size(all_data{1, exp},1)
            for i=1:size(all_data{1, exp},2)
                if(~isempty(all_data{1, exp}{j, i}))
                    all_data{1, exp}{j,i}{1,1}.lag_ms = mean(all_data{1, exp}{j,i}{1,1}.latency(measurement_ranges{j}));
                    all_data{1, exp}{j,i}{1,1}.jitter = std(all_data{1, exp}{j,i}{1,1}.latency(measurement_ranges{j}));
                    all_data{1, exp}{j,i}{1,1}.range = [min(all_data{1, exp}{j,i}{1,1}.latency(measurement_ranges{j})) max(all_data{1, exp}{j,i}{1,1}.latency(measurement_ranges{j}))];
                end
            end
                
       end
end

%% Save to results struct
labstreamer_results = all_data;
save('./../derivates/labstreamer_results','labstreamer_results')

