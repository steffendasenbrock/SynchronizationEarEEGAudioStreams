function lsl_raw_data = import_dat_file(directory)
% function to open binary file containing double values
% Correspondence: steffen.dasenbrock@uol.de
%
% Developed in 9.11.0.1837725 (R2021b) Update 2
%-------------------------------------------------------------------------

    fid = fopen(directory,'r');
    lsl_raw_data = fread(fid,'double');
end