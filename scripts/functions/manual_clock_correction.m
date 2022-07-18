function streams = manual_clock_correction(streams)
% This function uses the information stored in the stream struct to
% compute the clock corrected time stamp by adding the newest time stamps
% to each sample. The clock correction is typically collected only every
% few seconds, but needs to be added to every coresponding timestamp
% Correspondence: steffen.dasenbrock@uol.de
%
% Developed in 9.11.0.1837725 (R2021b) Update 2
%-------------------------------------------------------------------------

for j=2:3
stream = streams{j};
% initilize clock correction values
clock_correction_vector = zeros(1,numel(stream.time_stamps));
% set counter to one to read out the very first clock correction 
counter = 1;
% Loop through every time stamp
for i=1:numel(stream.time_stamps)
    % Read out clock correction value and its time stamp
    clock_time = str2double(stream.info.clock_offsets.offset{1,counter}.time);
    clock_value = str2double(stream.info.clock_offsets.offset{1,counter}.value);
    % As long as this holds, no newer time stamp was collected
    if(stream.time_stamps(i)<clock_time)
        % Write this to the vector, later being added to the timestamps
        clock_correction_vector(i) = clock_value;
    elseif(stream.time_stamps(i)>clock_time)
        counter = counter+1;
        next_clock_value = str2double(stream.info.clock_offsets.offset{1,counter}.value);
        clock_correction_vector(i) = next_clock_value;
    end
end

stream.clock_corrections = clock_correction_vector;
streams{j} = stream;
end
end
