function input_answer = check_if_dir_exits(info)
% check_if_dir_exits.m Checks via SSH connection if the directory stored in
% info.directory_plus_folder already exists on the PHL.
% Lets user decide what to do, if data exists in this directory
%   Input:
%     info: a struct containing information for taking measurement
%   Output:
%     input_answer: 1 (Directory exists), 0 (does not exist)
% Correspondence: steffen.dasenbrock@uol.de
%
% Developed in 9.11.0.1837725 (R2021b) Update 2
%-------------------------------------------------------------------------

    % System call to Mahalia via SSH
    exist = ~system(['ssh mha@' info.openmha{1}.host ' "[ -d "' info.directory_plus_folder '" ] "'])
    % Let experimenter choose what to do if directory exists.
    if exist == 1
        fprintf("Folder already exists. Content: \n");
        % Show data contained in directory using ls command
        system(['ssh mha@' info.openmha{1}.host ' "ls ' info.directory_plus_folder '"']);
        % Ask User to choose different measurement/run number or to delete
        % files contained in directory
        prompt = ['Different ' info.measurement_name ' number (Enter 1) or Delete Files (Enter 2)? \n'];
        input_answer = input(prompt);
    else
        % If directory does not exist
        input_answer = 0;
    end

end