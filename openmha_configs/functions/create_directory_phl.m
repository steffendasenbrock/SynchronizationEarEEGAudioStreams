function info = create_directory_phl(info)
% create_directory_phl.m Creates directory via SSH connection by
% 1. User chooses measurement and run number
% 2. Checks if directory exists (e.g. measurement_2/run_1)
% 3. Creates directory using mkdir command
%   input: 
%     info: a struct containing information for taking measurement
%   output:
%     info: updated version of info
% Correspondence: steffen.dasenbrock@uol.de
%
% Developed in 9.11.0.1837725 (R2021b) Update 2
%-------------------------------------------------------------------------

    % Chose Measurement number and run number
    info = choose_measurement_run(info);

    % Create directory+folder struct to create directory on PHL
    info.directory_plus_folder = [info.directory 'timing_test/'  info.measurement_name '-' num2str(info.measurement_number,'%02d') ...
    '/'];

    % Check if directory exits
    input_answer = check_if_dir_exits(info);
    % 0: directory does not exits, thus can be created
    % 1: directory exits, user wants a different subject
    % 2: directory exits, user wants to delete existing files
    
    % Create Directory
    % Do only continue if directory is clear
    while(input_answer==1 | input_answer==2)
        if(input_answer==1)
            % Let user choose new measurement/run number
            info = choose_measurement_run(info);
            % Check again if directory exits
            input_answer = check_if_dir_exits(info);
        elseif(input_answer==2)
            % delete directory using rm -r command
            system(['ssh mha@' info.openmha{1}.host ' "rm -r ' info.directory_plus_folder '"']);
            input_answer=0;
        end
    end
    
    % input_answer==0 -> directory does not exist, create it using mkdir -p
    system(['ssh mha@' info.openmha{1}.host ' "mkdir -p ' info.directory_plus_folder '"']);
    
end