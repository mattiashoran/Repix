function SummaryStats = plot_Figure3panels(data,overview)

%% Plot Figure 3 panels
% A: Overview of implantations done over time
% B: Yield over time, split by area
% Supp: Summary plots of B
% Mattias Horan, UCL, 2024

%% clean
d = data;

d(isnan(d.MouseID),:) = []; %remove unnamed entries

AreaRecorded = nan(size(overview.Var3));
AreaRecorded(strcmpi(overview.Var3,'HPC')) = 1; %HPC
AreaRecorded(strcmpi(overview.Var3,'MEC')) = 2; %MEC
AreaRecorded(strcmpi(overview.Var3,'BLA')) = 3; %BLA
AreaRecorded(strcmpi(overview.Var3,'V1')) = 4; %V1

%% color map
cmap = [...
    184 13 72
    242 151 36
    36 106 108
    77 86 153
    ]./256;

%% A: Plot overview of recording days over time

plot_RecordingsOverTime(d,cmap,AreaRecorded)
sgtitle('Fig 3A: Overview')


%% B: Plot number of cells over time
Cohort = 1;
[SummaryStats,RecArea] = plot_YieldOverTime(d,cmap,AreaRecorded,Cohort);
sgtitle('Fig 3B: Yield')


%% Supp: Summary of yield and stability

Title = {'Mean yield' 'Max yield' 'Mean/first' 'Mean/Max' 'Exponential fit'};
plot_YieldStabilitySummary(SummaryStats,Title,RecArea,cmap)
sgtitle('Fig 3 Supp: Yield Summary')










