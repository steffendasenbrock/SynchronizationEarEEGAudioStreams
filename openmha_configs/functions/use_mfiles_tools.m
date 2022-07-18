function use_mfiles_tools()
% Import all nessessary files to use openMHA's Matlab tools
% make sure that you have installed openmha
% Correspondence: steffen.dasenbrock@uol.de
%
% Developed in 9.11.0.1837725 (R2021b) Update 2
%-------------------------------------------------------------------------
clear java
setenv('LD_LIBRARY_PATH','')

% add openmha mfiles
if ismac
    % Code to run on Mac platform
    addpath('/usr/local/lib/openmha/mfiles/')
elseif isunix
    % Code to run on Linux platform
    addpath('/usr/lib/openmha/mfiles')
elseif ispc
    % Code to run on Windows platform
    addpath('C:\Program Files\openMHA\mfiles\')
else
    disp('Platform not supported')
end


