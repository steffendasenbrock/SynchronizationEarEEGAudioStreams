function [info] = choose_measurement_run(info)
% choose_measurement_run.m Asks user to choose a measurement number as well
% run number, based on this, later a directory is created to store the 
% data
%   input: 
%     info: a struct containing information for taking measurement
%   output:
%     info: updated version of info

% Ask for measurement number and run number and update info struct
prompt = ['Type in ' info.measurement_name ' number \n'];
info.measurement_number = input(prompt);

end