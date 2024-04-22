function plot_Figure5panels(data_ephys, overview,data_Neuronexus,data_rats_AA,data_rats_CM)

%% Plot Figure 5 panels, flexibility
% A: Pitch and roll
% B: Probetype
% C: Neuronexus
% D: mPFC rats
% E: Amygdala and dexa in rats
% Mattias Horan, UCL, 2024

%% Colormaps
color_map_rats = [...
    155 155 155
    246 130 16
    ]./256;

%% B: probe types

plot_ProbeTypeHistogram(data_ephys,overview)
sgtitle('Fig 5B: Probetypes')
%% C: Neuronexus



figure, hold on

Procedures = {'Implantation' 'Data' 'Explantation'};

for i = 1:3
    Attempts = sum(data_Neuronexus.([Procedures{i} '_attempts']));
    Success = sum(data_Neuronexus.([Procedures{i} '_success']));

    b = barh(i,[Success Attempts-Success],0.2,'stacked');
    b(1).FaceColor = 'b'; b(2).FaceColor = 'w';

    t = sprintf('%.2g%%', Success/Attempts*100);
    text(Success,i+0.2,t,'HorizontalAlignment','right');
end

%Reuse
    Attempts = sum(data_Neuronexus.Implantation_attempts);
    Reuse = sum(data_Neuronexus.Implantation_reuse);

    b = barh(4,[Reuse Attempts-Reuse],0.2,'stacked');
    b(1).FaceColor = 'b'; b(2).FaceColor = 'w';

    t = sprintf('%.2g%%',Success/Attempts*100);
    text(Success,i+0.2,t,'HorizontalAlignment','right');

yticks(1:4)
yticklabels({'Implantation' 'Data' 'Explantation' 'Reuse'})
sgtitle('Fig 5C: Neuronexus')

%% D: rats mPFC


d = data_rats_AA;

%set up overview of animals
SortBy = [1 1 1 1 1]; 

RatsUnique = {'EM41',...
    'EM56'      ,...
    'EM57'  ,...
    'EM58'  ,...
    'EM71'};

%clean
d.RatID = nan(size(d.DaysFromSurgery    ))          ;
d.RatID(strcmp(d.Subject,'EM41')) = 1;
d.RatID(strcmp(d.Subject,'EM56')) = 2;
d.RatID(strcmp(d.Subject,'EM57')) = 3;
d.RatID(strcmp(d.Subject,'EM58')) = 4;
d.RatID(strcmp(d.Subject,'EM71')) = 5;

d.MouseID = d.RatID;
d.DaysSinceImplant = d.DaysFromSurgery;
d.MUA = d.MUAClusters + d.SortedClusters;
d.GOOD = d.SortedClusters;


%plot
Cohort = 2;
plot_RecordingsOverTime(d,color_map_rats,SortBy)
sgtitle('Fig 5D: Overview')

[SummaryStats,RecArea] = plot_YieldOverTime(d,color_map_rats,SortBy,Cohort);
sgtitle('Fig 5D: Yield')


%% E: rats amygdala

d = data_rats_CM;
DexApp = [1 1 2 2 1 2]; %1= false, 2 = true

RatsUnique = {'A10',...
    'A13'      ,...
    'A14 BLA'  ,...
    'A14 PFC'  ,...
    'A6'       ,...
    'BLA00 BLA'};

d.MouseID = d.RatID;

%plot
Cohort = 3;
plot_RecordingsOverTime(d,color_map_rats,DexApp)
sgtitle('Fig 5E: Overview')

[SummaryStats,RecArea] = plot_YieldOverTime(d,color_map_rats,DexApp,Cohort);
sgtitle('Fig 5E: Yield')

