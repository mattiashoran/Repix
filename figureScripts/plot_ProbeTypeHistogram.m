function plot_ProbeTypeHistogram(d,overview)

%% Plot a histogram of yield by 
% Mattias Horan, UCL, 2024

%%
idx = ~isnan(d.MUA);
MouseID = d.MouseID(idx);
DaysSinceImplant = d.DaysSinceImplant(idx);
MUA = d.MUA(idx);
GOOD = d.GOOD(idx);
GOOD_amp = d.Amplitude(idx);
subplot_count = 0;
maxDaysSinceImplant = 0;

%% plot

h1=figure('Color','w','PaperPositionMode','auto');
hold on

ProbeType = overview.Var2;

%Select cohorts animals
NPX1_animals = find((ProbeType == 1));
NPX2_animals = find((ProbeType == 2));
NPX4_animals = find((ProbeType == 4));

yy = GOOD;

xx = 0:20:max(yy)+20;
text(270,11,'Median unit counts:')

ID = d.MouseID;

%NPX4 animals
idx = ismember(ID, NPX4_animals);

h = histogram(GOOD(idx), xx);
h.FaceColor = [.9 .9 .9];

txt = sprintf('%i',median(GOOD(idx)));
text(270,8,txt,'Color',[.7 .7 .7]);

%NPX1  animals
idx = ismember(ID, NPX1_animals);
h = histogram(yy(idx), xx);
h.FaceColor = 'b';

txt = sprintf('%i',median(yy(idx)));
text(270,10,txt,'Color','b');

%NPX2 MEC animals
idx = ismember(ID, NPX2_animals);
h = histogram(yy(idx), xx);
h.FaceColor = [.1 .1 .1];

txt = sprintf('%i',median(yy(idx)));
text(270,9,txt,'Color',[.1 .1 .1]);


%beautify
ylabel('session count')
xlabel('units')
legend('NPX2: multi','NPX1','NPX2: single')