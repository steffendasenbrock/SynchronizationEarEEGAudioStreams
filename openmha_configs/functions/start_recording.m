function start_recording(info)
% This function sets the record property of all ac2xdf plugins from no to
% yes
% Correspondence: steffen.dasenbrock@uol.de
%
% Developed in 9.11.0.1837725 (R2021b) Update 2
%-------------------------------------------------------------------------
mha_set(info, 'mha.markerlsl.record', 'yes');
mha_set(info, 'mha.audiolsl.record', 'yes');
mha_set(info, 'mha.eeglsl.record', 'yes');
end

