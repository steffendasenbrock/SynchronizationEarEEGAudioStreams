function streams = sort_lsl_data(streams)
% This function sorts the streams into a fixed order as
% labrecorder does not store them in the same order all the time
% 
% Correspondence: steffen.dasenbrock@uol.de
%
% Developed in 9.11.0.1837725 (R2021b) Update 2
%-------------------------------------------------------------------------

% Throw error if numel(streams) < 3
if(numel(streams) < 3) 
    error('The number of streams is smaller than 3') 
end

% MHA_AC_MHAREAL is not used in the manuscript
keyword_list = {'MHA_AC_MHAREAL','Markers','EEG'};
% check for keywords
dummy_streams = streams;
% loop through all streams
for i=1:numel(dummy_streams)
    % loop through all keywords
    for j=1:numel(keyword_list)
        if(strcmp(dummy_streams{i}.info.type,keyword_list{j}))
            streams{j} = dummy_streams{i};
        end
    end
end

end