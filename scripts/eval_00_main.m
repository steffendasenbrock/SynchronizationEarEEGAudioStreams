%% Main script
% Main script for calculation of timing test metrics described in:
% Synchronization of Ear-EEG and Audio Streams in a Portable Research 
% Hearing Device
% Steffen Dasenbrock, Sarah Blum, Paul Maanen, Stefan Debener, Volker
% Hohmann, Hendrik Kayser
%
% dependencies:
%                   - xdf-Matlab module
%                     (https://github.com/xdf-modules/xdf-Matlab)
%
% Authors: Steffen Dasenbrock, University of Oldenburg, Auditory Signal 
% Processing and Hearing Devices, Department of Medical Physics and 
% Acoustics , University of Oldenburg, Oldenburg, Germany
% 
% Correspondence: steffen.dasenbrock@uol.de
%
% Developed in 9.11.0.1837725 (R2021b) Update 2
%-------------------------------------------------------------------------

%% Clear everything
clc, clear , close all

%% Add own functions 
addpath('./functions/')

%% Script
% generate results structs for Timing Test Scenario I and II
eval_01_generate_results_scenario_I_II()
% generate results structs for Timing Test Scenario III
eval_02_generate_results_scenario_III()
% generate results struct for openMHA vs. LabRecorder comparison
eval_03_openmha_vs_labrec()
% plot latency over time plot
eval_04_plot_latency_over_time()
% generate table with calculated metrics
eval_05_generate_table()


