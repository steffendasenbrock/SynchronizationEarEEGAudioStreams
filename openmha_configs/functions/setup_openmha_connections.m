function [openmha, directory] = setup_openmha_connections()
% setup_openmha_connections.m Defines the IPs and ports to connect to the 
% PHL via SSH and the openMHA network interface
% Use: 10.0.0.1 for WiFi, and 192.168.7.2 for USB connections
% Correspondence: steffen.dasenbrock@uol.de
%
% Developed in 9.11.0.1837725 (R2021b) Update 2
%-------------------------------------------------------------------------

% openMHA ports and host names
openmha{1}.host = '10.0.0.1';
openmha{1}.port = 33337;
openmha{2}.host = '10.0.0.1';
openmha{2}.port = 33338;

% Path directory of configurations on PHL
directory = '/home/mha/';

end

