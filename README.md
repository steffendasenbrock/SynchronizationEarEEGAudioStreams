# Overview

This repository contains all scripts to reproduce the plots in the manuscript: 
Synchronization of ear-EEG and audio streams in a portable research hearing device
Steffen Dasenbrock, Sarah Blum, Paul Maanen, Stefan Debener, Volker Hohmann, and Hendrik Kayser

We also included the openMHA configurations used to control the Portable Hearing Laboratory in Timing Test Scenario III. 
Further information on the technical details of the timing tests can also be found in the supplemental materials of the manuscript. 

This repository consists of the following folders:

- scripts
- derivates
- openmha_configs

## scripts
This folder contains all Matlab scripts and functions to reproduce the plots of the manuscript.

Do the following to reproduce the plots:

a. Download the xdf-Matlab module (https://github.com/xdf-modules/xdf-Matlab) and add it to your Matlab path. 
b. Download rawdata.zip from https://zenodo.org/record/6857372#.ZFJr7y8RrZN and unpack it.
c. Paste the rawdata folder into the Github repository, i.e., on the same directory level as the folders 'derivatives', 'openmha_configs', and 'scripts'. 
b. Run eval_00_main.m in the scripts folder (this may take a while)
c. You should expect the following:
    - 3x2 panel of latency-time plots 
    - Histogram of Clock correction differences
    - Metrics table, shown in the Matlab console

## derivatives  

This folder is used for storing pre-processed data. 

## openmha_configs

This folder contains the openMHA configurations and other functions used to operate the PHL during Timing Test Scenario III. 
Note: Using the script and functions requires a Portable Hearing Laboratory device. (See manuscript for further details). 

The PHL was controlled via a wireless connection using the SSH protocol and specialized Matlab functions. 
Further information can be found in start_timing_test.m
