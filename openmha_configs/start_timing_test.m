% This script can be used to perform a simple in-the-loop timing test
% Correspondence: steffen.dasenbrock@uol.de
%
% Developed in 9.11.0.1837725 (R2021b) Update 2
%-------------------------------------------------------------------------

% The structure of the script can be divided into 7 parts:
%   1. Set the variables
%       (a) measurement_time: How long should the experiment last?
%       (b) level_dB        : Select volume of the click sounds
%       (c) info.smarting_id: Set the correct ID of the LSL stream, created
%                             by the smarting amplifier when streaming over
%                             LSL, you can use LabRecorder to find this out                          
%   2. Setup IPs and ports
%       In order to establish an SSH connection to the PHL and to use the 
%       network interface of openMHA, the IPs and ports are required
%       The IP depends on whether there is a connection via Wifi (10.0.0.1)
%       or via USB (192.168.7.2) to the PHL. The IPs can be changed inside
%       the function setup_openmha_connections(). 
%       (see functions/take_measurement)
%   3. Choose "Measurement"
%       measurement_no_X/
%       Before starting the measurement, it will be checked if this 
%       directory is already in use. If yes, the user can decide to choose
%       a different measurement number or to delete the files in the
%       directory. If the directory does not exit it will be created
%   4. Set up openMHA scripts
%       Two independent openMHA scripts are used in the setup. One "Sender"
%       instance as well as one "Receiver" instance, each configured by a 
%       different script. The content of the scripts is transferred via 
%       the network interface of openMHA using the corresponding Matlab 
%       functions. The script are set up in:
%           (a) functions/openmha_sender_script()
%           (b) functions/openmha_receiver_script()
%   5. Start both instances ("sender" and "receiver") 
%       - with a slight offset of a few seconds (to prevent any errors)
%   6. Stop measurement after time defined in the variable 
%      "measurement_time"
%   7. Download data recorded during this measurement via SSH and store
%   them into ./data relative to this directory.

% Variables to set
measurement_time = 910; % in seconds
level_dB = 80;
info.smarting_id = 'Android_EEG_010037'; % ID of the smarting amplifier, when
storage_path = './../rawdata/'; % Relative path where to store the raw_data
filename = 'run-'; % Syntax run-01, run-02, ...

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Script %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Import paths to functions 
addpath('./functions/')

% Pre-setup to be able to use mfiles to control openMHA via Matlab
use_mfiles_tools()

% Set Parameters
[info.openmha, info.directory] = setup_openmha_connections();

% Clear up both MHAs to prevent trying to start two openMHA on the same
% port
system(['ssh mha@10.0.0.1 ' '"mha --port=' num2str(info.openmha{2}.port) ' --interface="0.0.0.0" " &']);
pause(1);
mha_set(info.openmha{2}, 'cmd', 'quit' );
mha_set(info.openmha{1}, 'cmd', 'quit' );
% % Choose Subject Number
info.measurement_name = 'run';
info.run_name         = 'run'; 
info = create_directory_phl(info);
pause(4);

% Define sender and receiver configurations
openmha_sender_script(info.openmha{1}, info, level_dB);
% Start receiver openMHA
system(['ssh mha@10.0.0.1 ' '"mha --port=' num2str(info.openmha{2}.port) ' --interface="0.0.0.0" " &']);
pause(2);
openmha_receiver_script(info.openmha{2}, info)
% Start Configurations
mha_set(info.openmha{1}, 'cmd', 'prepare' );
disp('Press Enter to start measurement');
pause;
mha_set(info.openmha{1}, 'cmd', 'start' );
% Commands to start LabRecorder
%pause(1)
%disp('Please Start LabRecorder using: ')
%disp(['./LabRecorderCLI-linux-armhf ' info.directory_plus_folder(1:end-1) '.xdf' '  ''*'' '])
%pause
%disp('Started LabRecorder');
pause(2)
mha_set(info.openmha{2}, 'cmd', 'start' );
start_recording(info.openmha{2});
%system([' ssh mha@10.0.0.1 "./LabRecorderCLI-linux-armhf ' info.directory_plus_folder(1:end-1) '.xdf' '  ''*'' " &' ])
disp('Started acrec plugins (receiver instance)');
% Show end of measurement
format shortg
c = clock;
end_time = duration([c(4) c(5) c(6)])+seconds(measurement_time);
disp('Measurement will be finished at ');
disp(end_time);
% Wait until measurement_time is over
pause(measurement_time)
% % Terminal command to stop labrecorder
% disp('Please stop LabRecorder Recording');
% pause
% pause(2)
mha_set(info.openmha{2}, 'cmd', 'quit' );
disp('Stopped receiver instance');
pause(2)
mha_set(info.openmha{1}, 'cmd', 'quit' );
disp('Stopped sender instance');
disp('Downloading Data...');
pause(5)
% Download data
system(['scp -r mha@10.0.0.1:' info.directory_plus_folder ' ' storage_path]);

