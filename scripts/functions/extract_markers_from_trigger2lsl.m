function marker_time_stamps = extract_markers_from_trigger2lsl(marker_stream,marker_string)
% This function extracts a vector containing the time stamps of the marker
% events contained in 'stream' specified in the functions' input
% Correspondence: steffen.dasenbrock@uol.de
%
% Developed in 9.11.0.1837725 (R2021b) Update 2
%-------------------------------------------------------------------------

n=1;
for i=1:numel(marker_stream.time_series)
    % Check every event
        % Filter out every row which contains the event and put it into one
        % struct per event
        if strcmp(marker_stream.time_series{i},marker_string)
            marker_time_stamps(n) = marker_stream.time_stamps(i);
            n=n+1;
        end      
end


end