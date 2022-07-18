function [] = openmha_sender_script(mha_info, info, level_dB)
% openmha_sender_script.m This function contains all commands to set up
% the "sender" openMHA instance in the setup, using openMHA's Matlab tools
% (e.g. mha_set()).
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
% The configuration is embedded in the transducers plugin
mha_set(mha_info, 'mhalib', 'transducers');
% To to real time processing, the MHAIOJACKdb library is used
mha_set(mha_info, 'iolib', 'MHAIOJackdb');

% Set up calibration values
mha_set(mha_info, 'mha.calib_in.peaklevel', '[117]');
mha_set(mha_info, 'mha.calib_out.peaklevel', '[108]');
% Inside the transducers plugin, a new "plugin chain" will be embedded
% using the "mhachain" plugin
mha_set(mha_info, 'mha.plugin_name', 'mhachain');
% Define plugins in chain:
% 1. addsndfile: Load stimulus
% 2. trigger2lsl: Send trigger marker if rising edge is detected
% 3. save_wave: create copy of audio stream and convert into AC variable
% 4. ac2lsl: Create an LSL stream out of AC variable
mha_set(mha_info, 'mha.mhachain.algos', '[addsndfile trigger2lsl save_wave:openMHA ac2lsl]');

% Set up trigger2lsl stream name
mha_set(mha_info, 'mha.mhachain.trigger2lsl.stream_name', 'Marker_stream');
% Set up trigger2lsl channels to look for rising edges
mha_set(mha_info, 'mha.mhachain.trigger2lsl.threshold', '0.001');
% Set up trigger2lsl marker names to be send when crossing the threshold
mha_set(mha_info, 'mha.mhachain.trigger2lsl.rising_edge ', 'CHANNEL0');
% Set up trigger2lsl marker names to be send when crossing the threshold
% from above
mha_set(mha_info, 'mha.mhachain.trigger2lsl.falling_edge ', 'STOP');
% Set up trigger2lsl if it should use latency correction
mha_set(mha_info, 'mha.mhachain.trigger2lsl.use_edge_position', 'yes');
% Import audio.wav file
mha_set(mha_info, 'mha.mhachain.addsndfile.filename',[info.directory 'rect_comb_16kHz_1s_0_jitter_1ch.wav']);
% file loaded with addsndfile should replace the existing input completly
mha_set(mha_info, 'mha.mhachain.addsndfile.mode', 'replace');
% Set the levelmode to "peak"
mha_set(mha_info, 'mha.mhachain.addsndfile.levelmode', 'peak');
% Set the volume of the stimulus
mha_set(mha_info, 'mha.mhachain.addsndfile.level', num2str(level_dB));
% The audio file should be looped
mha_set(mha_info, 'mha.mhachain.addsndfile.loop', 'yes');
mha_set(mha_info, 'mha.mhachain.ac2lsl.source_id', 'mha');
mha_set(mha_info, 'mha.mhachain.ac2lsl.rt_strict', 'no');
mha_set(mha_info, 'mha.mhachain.ac2lsl.nominal_srate', num2str(16000));
% This input channel will be overwritten by addsndfile
% Use playback 3 and 7 for Line/AUX output
mha_set(mha_info, 'io.con_out', '[system:playback_3 system:playback_2]');
%Use playback 1 and 2 for BTE Hearing Aid output
%mha_set(mha_info, 'io.con_out', '[system:playback_1 system:playback_2]');

% Put openMHA into "prepare" mode, the configuration can not be changed
% anymore
mha_set(info.openmha{1}, 'cmd', 'prepare' );

end
