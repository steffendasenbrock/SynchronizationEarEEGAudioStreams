function stream = combine_to_struct(input_stream)
% Combine all stream information into the standard form of LSL stream
% structs
% Correspondence: steffen.dasenbrock@uol.de
%
% Developed in 9.11.0.1837725 (R2021b) Update 2
%-------------------------------------------------------------------------

    % name
    stream.name = input_stream{1,1}.info.name;
    % rawdata
    stream.time_series = input_stream{1,1}.time_series;
    % time stamps
    stream.time_stamps = input_stream{1,2}.time_series;
    % clock corrections
    stream.clock_corrections = input_stream{1,3}.time_series;

end