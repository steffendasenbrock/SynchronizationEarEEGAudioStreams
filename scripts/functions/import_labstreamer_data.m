function labstream = import_labstreamer_data(data_name_string,varargin)
% This function imports data from .txt data generated by the LabStreamer
% Correspondence: steffen.dasenbrock@uol.de
%
% Developed in 9.11.0.1837725 (R2021b) Update 2
%-------------------------------------------------------------------------

% load input variables 
opts = cell2struct(varargin(2:2:end),varargin(1:2:end),2);

% for timing test scenario I
if ~isfield(opts,'External')
    opts.External = false; end
% for timing test scneario II
if ~isfield(opts,'EEG_isolated')
    opts.EEG_isolated = false; end

% Input: data_name_string: Name of input .txt file
% Import raw data
T = readtable(data_name_string);
name = data_name_string;
% Import event array
events = table2array(T(:,2));
% Time in seconds
time_s =  table2array(T(:,1));

% Change index to look for data, as the table has a slightly different 
% format depending on the timing test scneario
if opts.External | opts.EEG_isolated
    data_index = [4 5];
else
    data_index = [6 7];
end   
% Measured Latency in milliseconds
latency_ms =   table2array(T(:,data_index(1)));
% Network Induced Uncertainty in milliseconds
network_unc_ms =   table2array(T(:,data_index(2)));


% Find different strings
if opts.EEG_isolated
    idx = find(contains( convertCharsToStrings(events), 'trigger_string":"255"' ));
    events = repelem({'trigger_string":"255"'}, numel(idx));
    time_s = time_s(idx);
    latency_ms  = latency_ms(idx);
    network_unc_ms = network_unc_ms(idx);
    event_name_list = unique(events);
else
event_name_list = unique(events);
end

% Counter index
n = ones(1,numel(event_name_list));

for i=1:numel(events)
    % Check every event
    for j=1:numel(event_name_list)
        % Filter out every row which contains the event and put it into one
        % struct per event
        if strcmp(events{i},event_name_list{j})
           labstream{j}.event = events{i};
           labstream{j}.time(n(j)) = time_s(i); 
           labstream{j}.latency(n(j)) = latency_ms(i);
           labstream{j}.network_unc_ms(n(j)) = network_unc_ms(i);
           n(j) = n(j)+1;
        end      
    end
end


end


