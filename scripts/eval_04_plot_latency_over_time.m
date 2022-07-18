%% Plot script for latency-time plots
% Authors: Steffen Dasenbrock, University of Oldenburg, Auditory Signal 
% Processing and Hearing Devices, Department of Medical Physics and 
% Acoustics , University of Oldenburg, Oldenburg, Germany
% 
% Correspondence: steffen.dasenbrock@uol.de
%
% Developed in 9.11.0.1837725 (R2021b) Update 2
%-------------------------------------------------------------------------
% Clear everything
clc, clear

% option to substract median latency (default:false)
substracte_median = false;
fontsize_plot = 9;

% Load data from all three timing test scenarios
files = dir('./../derivates/*.mat');
for i= 1:numel(files)
    load([files(i).folder '/' files(i).name]);
end

% Put data into one struct
all_results{1} = labstreamer_results{1};
all_results{2} = labstreamer_results{2};
all_results{3} =  in_the_loop_results;

% Number of measurements for 15 min and 3 h condition
num_of_measurements = [5 2];

% Define limits for latency-axis (y-axis) in ms and time (x-axis)
% in min oder hours
x_limit{1} = [0 15];
y_limit{1} = [-75 50];
x_limit{2} = [0 3];
y_limit{2} = [-75 50];

% multiplication factor (upper plot in mins, lower plot in hours)
multi_factor = [60 3600];

% Define color values
color_values_15min = [[0 0.4470 0.7410]; [0.8500 0.3250 0.0980]; [0.9290 0.6940 0.1250]; [0.4940 0.1840 0.5560]; [0.4660 0.6740 0.1880]];
color_values_3h = [[0.9290 0.6940 0.1250];[0 0.4470 0.7410]];

% Define 3x2 tiled layout
figure
tiledlayout(3,2,'TileSpacing','compact');

% Loop through all conditions (scenarios and durations)
for i=1:3  

    for index=1:2
        ax=nexttile;

        for j=1:num_of_measurements(index)

            % set index to scale time axis correctly
            time = all_results{1,i}{index, j}{1, 1}.time;
            time = time./multi_factor(index);
            % latency vector
            latency = all_results{1,i}{index, j}{1, 1}.latency; 
            plot(time-time(1), latency,'LineWidth',1.7);
            hold on
            grid on
            xlim(x_limit{index});
            ylim(y_limit{index});
            yticks([y_limit{2}(1):25:y_limit{2}(2)])    ;      
            ylimits=get(gca,'ylim');
            xlimits=get(gca,'xlim');
            ax = gca;
            ax.FontSize = 12; 
            H=gca;
            H.LineWidth=1.5; 

% Set x and y labels and descriptions at correct positions
if i<3
set(gca,'xticklabel',[])
elseif i==3 && index==1
    xlabel('Recording time / min','fontsize',12,'interpreter','latex','FontName','Times New Roman')
elseif i==3 && index==2
    xlabel('Recording time / h','fontsize',12,'interpreter','latex','FontName','Times New Roman')
end

if i==2 && index==1
    ylabel('Latency $\Delta t$ / ms','fontsize',14,'interpreter','latex','FontName','Times New Roman')
end

if i==1 && index==1
    title('Short recordings (15 min)','fontsize',12,'interpreter','latex','FontName','Times New Roman')
elseif i==1 && index==2
    title('Long recordings (3 h)','fontsize',12,'interpreter','latex','FontName','Times New Roman')

end

if index==2
set(gca,'yticklabel',[])
end
set(gca,'TickLabelInterpreter','latex')
        end

% Set color
if index==1
    colororder(ax,color_values_15min)
    elseif index==2
    colororder(ax,color_values_3h)  
end

    end
end

 % Set figure size
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 18, 12], 'PaperUnits', 'centimeters', 'PaperSize', [18, 12])

% save as PDF file
 saveas(gcf,'latency_over_time_raw.pdf')
 
 
 
 
 
 