function [] = openmha_receiver_script_new(mha_info, info)
% openmha_receiver_script.m This function contains all commands to set up
% the "receiver" openMHA instance in the setup, using openMHA's Matlab tools
% (e.g. mha_set()). 
% To better understand the structure of an openMHA configuration 
% see the openMHA Starting Guide and the Application Manual:
% - http://www.openmha.org/docs/openMHA_starting_guide.pdf
% - http://www.openmha.org/docs/openMHA_application_manual.pdf
% Correspondence: steffen.dasenbrock@uol.de
%
% Developed in 9.11.0.1837725 (R2021b) Update 2
%-------------------------------------------------------------------------

% The number of channels to be processed
mha_set(mha_info, 'nchannels_in', '1');
% Sampling rate. Has to be the same as the input file
mha_set(mha_info, 'srate', '16000');
% Number of frames to be processed in each block
mha_set(mha_info, 'fragsize', '512');
% The configuration is embedded in the mhachain plugin
mha_set(mha_info, 'mhalib', 'mhachain');

% Define plugin chain
% 1. lsl2ac: (3x the same plugin)
% Convert an LSL stream into an AC variable
%       (a) receive_eeg
%       (b) receive_raw_audio
%       (c) receive_markers
% 2. ac2xdf: (3x the same plugin)
%       (a) markerlsl
%       (b) audiolsl
%       (c) eeglsl

mha_set(mha_info, 'mha.algos', '[lsl2ac:receive_eeg lsl2ac:receive_raw_audio lsl2ac:receive_markers ac2xdf:markerlsl ac2xdf:audiolsl ac2xdf:eeglsl]');

% Set up streams, lsl2ac will look for 
mha_set(mha_info, 'mha.receive_eeg.streams', ['[' info.smarting_id ']']);
mha_set(mha_info, 'mha.receive_raw_audio.streams', '[openMHA]');
mha_set(mha_info, 'mha.receive_eeg.chunksize', '10');
mha_set(mha_info, 'mha.receive_raw_audio.chunksize', '1024');
mha_set(mha_info, 'mha.receive_markers.streams', '[Marker_stream]');
mha_set(mha_info, 'mha.receive_markers.nsamples', '32');

% Since all data should be recorded an no data should be thrown away,
% "overruns" will be ignored
mha_set(mha_info, 'mha.receive_eeg.overrun_behavior', 'ignore');
mha_set(mha_info, 'mha.receive_markers.overrun_behavior', 'ignore');
mha_set(mha_info, 'mha.receive_raw_audio.overrun_behavior', 'ignore');

% Define variable names for ac2xdf

mha_set(mha_info, 'mha.markerlsl.varnames', '[Marker_stream Marker_stream_ts Marker_stream_tc]');
mha_set(mha_info, 'mha.markerlsl.prefix', [info.directory_plus_folder 'markerlsl']);

mha_set(mha_info, 'mha.audiolsl.varnames', '[openMHA openMHA_ts openMHA_tc ]');
mha_set(mha_info, 'mha.audiolsl.prefix', [info.directory_plus_folder 'audiolsl']);

mha_set(mha_info, 'mha.eeglsl.varnames', [ '[' info.smarting_id ' ' info.smarting_id '_ts' ' ' info.smarting_id '_tc' ']' ]);
mha_set(mha_info, 'mha.eeglsl.prefix', [info.directory_plus_folder 'eeglsl']);

% Use MHAIOJACKdb, since this is a live configuration
mha_set(mha_info, 'iolib', 'MHAIOJackdb');
mha_set(mha_info, 'io.name', 'MHA2');
% This input is not used
mha_set(mha_info, 'io.con_out', '[system:playback_1]');
% Put openMHA into "prepare" mode, the configuration can not be changed
% anymore
mha_set(info.openmha{2}, 'cmd', 'prepare' );

end