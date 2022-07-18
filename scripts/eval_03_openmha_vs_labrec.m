%% Script to compare clock corrections of openMHA vs. LabRecorder recording
% Authors: Steffen Dasenbrock, University of Oldenburg, Auditory Signal 
% Processing and Hearing Devices, Department of Medical Physics and 
% Acoustics , University of Oldenburg, Oldenburg, Germany
% 
% Correspondence: steffen.dasenbrock@uol.de
%
% Developed in 9.11.0.1837725 (R2021b) Update 2
%-------------------------------------------------------------------------
% Clear everything
clear , clc
% Set path to data
PATH =  './../rawdata/labrecorder_vs_openmha/';
% Set either run-01 or run-02
name = 'run-01';
addpath(genpath('./functions/'))
% Extract data info
measurement_data_info = dir([PATH name '/' '*.xdf']);

% load raw audio, eeg and marker streams
eeg_stream = load_xdf([measurement_data_info(1).folder '/' measurement_data_info(1).name],'HandleClockSynchronization',false ,'HandleJitterRemoval',false ,'CorrectStreamLags',false ,'HandleClockResets',false);
marker_stream = load_xdf([measurement_data_info(2).folder '/' measurement_data_info(2).name],'HandleClockSynchronization',false ,'HandleJitterRemoval',false ,'CorrectStreamLags',false ,'HandleClockResets',false);

% sort each struct by time_series, time_stamps and clock_corrections
marker_stream = sort_stream_entries(marker_stream);
eeg_stream = sort_stream_entries(eeg_stream);

% put streams into one struct and % Sort streams into same order: (1) ac2lsl (2) trigger2lsl (3) EEG
streams{1} = combine_to_struct(marker_stream);
streams{2} = combine_to_struct(eeg_stream);

% Clean marker stream from zero time stamps
marker_indizes = find(streams{1}.time_stamps);
streams{1}.time_stamps = streams{1}.time_stamps(marker_indizes);
streams{1}.clock_corrections = streams{1}.clock_corrections(marker_indizes);

%% LabRecorder

labrec = load_xdf([PATH name '.xdf'],'HandleClockSynchronization',false ,'HandleJitterRemoval',false ,'CorrectStreamLags',false ,'HandleClockResets',false);
% Sort streams into same order: (1) ac2lsl (2) trigger2lsl (3) EEG
labrec = sort_lsl_data(labrec);
% Manual clock correction
labrec = manual_clock_correction(labrec);

%% Comparison of time stamps
% Check if ac2xdf or LabRecorder started earlier recording
if(streams{1,2}.time_stamps(1)<labrec{1,3}.time_stamps(1))
    % Set first index
    [~,min_index] = min(abs(streams{1,2}.time_stamps-labrec{1,3}.time_stamps(1)))
end

% Compute upper limit to which index both streams should be compared
limit = numel(labrec{3}.clock_corrections)-(min_index+1);

% Calculate clock difference
clock_differences = (streams{2}.clock_corrections(min_index:min_index+limit-1)-labrec{3}.clock_corrections(1:limit));

% Calculate clock differences in milliseconds
clock_differences = clock_differences*1000;

% Plot Histogram
figure
hold on
% Set 10 ms as binlimit
binlimit = 10;
[~, index_higher] = find(clock_differences>binlimit);
[~, index_lower] = find(clock_differences<-binlimit);
clock_differences(index_higher) = binlimit;
clock_differences(index_lower) = -binlimit;
histogram(clock_differences,[-binlimit-0.5:0.2:binlimit+0.5],'LineWidth',0.2,'Normalization','probability','EdgeColor',[0.8500 0.3250 0.0980],'linewidth',1.5)

% Set plot parameters
ylim([0 0.25])
grid on
set(gca,'fontsize',14,'FontName','Times New Roman') % Sets the width of the axis lines, font size, font
ylabel('Relative occurrence','fontsize',14,'interpreter','latex','FontName','Times New Roman')
xlabel('Clock difference / ms','fontsize',14,'interpreter','latex','FontName','Times New Roman')
grid on
hold on
box on
ax = gca;
ax.FontSize = 12; 
H=gca;
H.LineWidth=1.5; 

% Save figure
Figurename = 'clock_correction_difference';
%vPosition= [3 3 3.54 2];
%set(gcf,'unit','centimeter')
%set(gcf,'paperposition',[0 0 vPosition([end-1 end])])
set(gcf,'Toolbar','none')
set(gcf,'Menubar','none')
%set(gcf,'outerposition',vPosition)
%set(gcf,'papersize',vPosition([end-1 end]))
print(fullfile(Figurename), '-dpdf')








