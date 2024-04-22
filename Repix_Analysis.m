%% Repix Analysis

%-- This script recreates the figures of Horan et al 2024
% from source data.
% The data can be downloaded from: _______________
% Mattias Horan, UCL, 2024

%% Set the directory to where the downloaded data folder is placed
% and load data

data_dir    = '/Users/mattiashoran/Desktop/Repix/Data/For Sharing';

%----------- mouse census data
data_census        = readtable(fullfile(data_dir,'Overview_implants.csv'));

% clean data (user IV used Neuronexus, so only included in Figure 5)
idx = (strcmp(data_census.User , 'IV'));
data_Neuronexus = data_census(idx,:);
data_census = data_census(~idx,:);

%----------- mouse ephys data
data_ephys        = readtable(fullfile(data_dir,'Data_yield_mice.csv'));
overview_mice    = readtable(fullfile(data_dir,'Overview_mice.txt'));

%----------- rat mPFC ephys data
data_rats_AA        = readtable(fullfile(data_dir,'Data_yield_rats_AA.csv'));

%----------- rat amygdala ephys data
data_rats_CM        = readtable(fullfile(data_dir,'Data_yield_rats_CM.csv'));


%% Figure 2: Repix has been implemented across multiple labs and users

plot_Figure2panels(data_census)


%% Figure 3: Repix can be implanted for up to a year with stable unit yield

SummaryStats = plot_Figure3panels(data_ephys,overview_mice);

%% Figure 4: Repix allows reuse of Neuropixels probes

data = data_census;

% clean data (ie get users who attempted reuse)
idx = contains(data.User , {'SB' 'CM' 'MH' 'TJ' 'AL' 'ZS' 'CB' 'MBa' 'ET'});
data(~idx,:) = [];

%plot
plot_Figure4panels(data, data_ephys,overview_mice,SummaryStats)

%% Figure 5: Repix can be used in many different experimental paradigms

plot_Figure5panels(data_ephys, overview_mice,data_Neuronexus,data_rats_AA,data_rats_CM)

%% Figure 6: Users quickly gain proficiency

plot_Figure6panels(data_dir)

