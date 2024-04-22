function plot_Figure6panels(data_dir)

%% Plot the heatmap of learning
% Mattias Horan, UCL, 2024

%% Load data
DataFolder = [data_dir '/Individual Users'];

dat.SB = readtable(fullfile(DataFolder,'RepixImplants_Bailey.xlsx'),'VariableNamingRule','preserve');
dat.HD = readtable(fullfile(DataFolder,'RepixImplants_Dalgleish.xlsx'),'VariableNamingRule','preserve');
dat.MH = readtable(fullfile(DataFolder,'RepixImplants_Horan.xlsx'),'VariableNamingRule','preserve');
dat.CM = readtable(fullfile(DataFolder,'RepixImplants_Mazuski.xlsx'),'VariableNamingRule','preserve');
dat.VP = readtable(fullfile(DataFolder,'RepixImplants_Plattner.xlsx'),'VariableNamingRule','preserve');
dat.DR = readtable(fullfile(DataFolder,'RepixImplants_Regester.xlsx'),'VariableNamingRule','preserve');
dat.ZS = readtable(fullfile(DataFolder,'RepixImplants_Slonina.xlsx'),'VariableNamingRule','preserve');
dat.ET = readtable(fullfile(DataFolder,'RepixImplants_Thompson.xlsx'),'VariableNamingRule','preserve');
dat.TJ = readtable(fullfile(DataFolder,'RepixImplants_TJP.xlsx'),'VariableNamingRule','preserve');

ID_str = ["SB" "HD" "MH" "CM" "VP" "DR" "ZS" "ET" "TJ"];

%% extract data frame from 
[Outcomes,ID_str] = get_RepixOutcomes(dat,ID_str);


%% Top: plot heatmap of experience
cmap = greens(4);
cmap = cmap(end:-1:1,:);
cmap(2:5,:) = cmap;
cmap(1,:) = [0.7 0.7 0.7];
cmap(2,:) = [0.7 0.5 0.5];

figure
cdata = Outcomes';
xvalues = 1:length(cdata);
yvalues = ID_str;
h = heatmap(xvalues,yvalues,cdata);

%beautify
h.MissingDataColor = 'w';
h.Colormap = cmap;
h.CellLabelColor = 'none';
h.ColorLimits = [0 5];
h.NodeChildren(3).YDir='normal';
warning('off','all')
hHeatmap = struct(h).Heatmap;
hGrid = struct(hHeatmap).Grid;
hGrid.ColorData = uint8([255;255;255;125]);
warning('on','all')

sgtitle('Fig 6: Procedure outcomes')


%% Bottom: plot number of procedures to proficiency
y = [14 11 5 2 3 9 5 2 3];

rect_width = .1;
offset = 0;
colorpalette = cmap(end,:);

h1 = figure('Color','w','PaperPositionMode','auto');
hold on

x = 1;

%plot Pre
me = [...
    (median(y)),...
    ];

sem = [...
    (prctile(y,[25 75]));...
    ];

for i = x
    rectangle('Position', [i-rect_width-offset, sem(1,1), rect_width*2, sem(1,2)-sem(1,1)], ...
        'Curvature', 0.2, ...
        'FaceColor', [cmap(end,:), 0.4], ...
        'EdgeColor', [cmap(end,:) 1]);
end
plot(x-offset,me,'o','MarkerFaceColor',cmap(end,:),'MarkerEdgeColor','w','LineWidth',1,'MarkerSize',10)

%beautify
box off
ylabel('Procedures (count)')
xlabel('')
title('Fig 6: Number of procedures to proficiency')
xlim([0 2])
ylim([0 28])


set(gca,'XTick',1)


