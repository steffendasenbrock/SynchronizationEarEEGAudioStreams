function [epoch, epoch_time_stamps, epoch_time_vector] = extract_eeg(stream,marker_time_stamps,varargin)
% this function epochs lsl data based on a vector of event time
% stamps
% Correspondence: steffen.dasenbrock@uol.de
%
% Developed in 9.11.0.1837725 (R2021b) Update 2
%-------------------------------------------------------------------------

% check input arguments
opts = cell2struct(varargin(2:2:end),varargin(1:2:end),2);
if ~isfield(opts,'interpolate')
    opts.interpolate = false; end
if ~isfield(opts,'baseline_removal')
    opts.baseline_removal = false; end

% Extract signal EEG channel to check timing
EEG.data = stream.time_series(2,:);
EEG.time_stamps = stream.time_stamps;

% Baseline boundaries in milliseconds
baseline_ms = [-100 -50];

sampling_rate = 250;
if(opts.interpolate)
    new_sampling_rate = 16000;
    interp_ratio = new_sampling_rate/sampling_rate;
    L=numel(EEG.data);
    % Interpolate both time stamps and time series of channel to 8 kHz
    EEG.data = interp1(1:L,EEG.data,linspace(1,L,L*interp_ratio));
    EEG.time_stamps = interp1(1:L,EEG.time_stamps,linspace(1,L,L*interp_ratio));
    sampling_rate=new_sampling_rate;
end


% upper and lower bound relative to markers
lower_bound_sek = -0.1;
upper_bound_sek = 0.150;

upper_bound_samples = round(upper_bound_sek*sampling_rate);
lower_bound_samples = round(lower_bound_sek*sampling_rate);
epoch_time_vector = [lower_bound_samples:1:upper_bound_samples]/sampling_rate;
baseline_samples = round(baseline_ms/1000*sampling_rate);

% Block size of how many time stamps are calculated at once
ntc = 1;
% Choose if this is a long or a short measurement
if (899<numel(marker_time_stamps)&& numel(marker_time_stamps)<1500)
    ne = 900;
elseif(10799<numel(marker_time_stamps) && numel(marker_time_stamps)<13000)
    ne = 10800;
else
    error('Check number of marker time stamps')
end
nc = ne/ntc;

repeated_time_stamps = repmat(EEG.time_stamps',1,ntc);
onset_sample = zeros(1,ne);
last_onset_sample = 1;
% choose "distance" to look in the future (e.g. 2 seconds), to avoid 
% going through the whole vector of time stamps to find the closest to
% the market time stamp
distance_to_look = ntc+1; %in seconds
distance_to_look_samples = new_sampling_rate*distance_to_look;

%find first time stamps
for j=0:nc-1   
    
    if j==0
        [difference_ts(j*ntc+1:(j+1)*ntc), onset_sample(j*ntc+1:(j+1)*ntc)] = min(abs(repeated_time_stamps(last_onset_sample:end,:)-marker_time_stamps(j*ntc+1:(j+1)*ntc)));
        onset_sample(j*ntc+1:(j+1)*ntc)=onset_sample(j*ntc+1:(j+1)*ntc)+last_onset_sample-1;
        last_onset_sample=onset_sample((j+1)*ntc);
    else
        [difference_ts(j*ntc+1:(j+1)*ntc), onset_sample(j*ntc+1:(j+1)*ntc)] = min(abs(repeated_time_stamps(last_onset_sample:last_onset_sample+distance_to_look_samples,:)-marker_time_stamps(j*ntc+1:(j+1)*ntc)));
        onset_sample(j*ntc+1:(j+1)*ntc)=onset_sample(j*ntc+1:(j+1)*ntc)+last_onset_sample-1;
        last_onset_sample=onset_sample((j+1)*ntc);
    end

end

% allocate epoch
epoch=zeros(numel(onset_sample),upper_bound_samples-lower_bound_samples+1);

for i=1:numel(onset_sample)
    epoch(i,:) = EEG.data(onset_sample(i)+lower_bound_samples:onset_sample(i)+upper_bound_samples);
    if(opts.baseline_removal)
        epoch(i,:) = epoch(i,:) - mean(epoch(i,abs(lower_bound_samples)+baseline_samples(1)+1:abs(lower_bound_samples)+baseline_samples(2)));
    end
    epoch_time_stamps(i) = EEG.time_stamps(onset_sample(i))-marker_time_stamps(1);
end


end
