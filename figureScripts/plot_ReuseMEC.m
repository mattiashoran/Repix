function plot_ReuseMEC(d,overview,SummaryStats)

%% Plot the reuse summary for the implantations done with new versus reused probes in the MEC
% Mattias Horan, UCL, 2024

%%
d(isnan(d.MouseID),:) = []; %remove unnamed entries

AreaRecorded = nan(size(overview.Var3));
AreaRecorded(strcmpi(overview.Var3,'HPC')) = 1; %HPC
AreaRecorded(strcmpi(overview.Var3,'MEC')) = 2; %MEC
AreaRecorded(strcmpi(overview.Var3,'BLA')) = 3; %BLA
AreaRecorded(strcmpi(overview.Var3,'V1')) = 4; %V1

%%
idx = ~isnan(d.MUA);
MouseID = d.MouseID(idx);
DaysSinceImplant = d.DaysSinceImplant(idx);
MUA = d.MUA(idx);
GOOD = d.GOOD(idx);
GOOD_amp = d.Amplitude(idx);
subplot_count = 0;
maxDaysSinceImplant = 0;

cmap = [0.7 0.7 0.7;0.5 0.6 1];


%%
figure
hold on

%Select cohorts animals
REUSE = [15 16 17 18];
REUSE = find(ismember(1:length(GOOD),REUSE));
USE = find(~ismember(1:length(GOOD),REUSE));

subplot(1,2,1)
hold on
xx = 0:20:max(GOOD)+20;
text(300,11,'Median unit counts:')

ID = MouseID;

%NPX1  animals
idx = ismember(ID, USE);
h = histogram(GOOD(idx), xx);
h.FaceColor = [.7 .7 .7];

txt = sprintf('%i',median(GOOD(idx)));
text(300,10,txt,'Color',[.7 .7 .7]);


%NPX2 MEC animals
idx = ismember(ID, REUSE);
h = histogram(GOOD(idx), xx);
h.FaceColor = cmap(2,:);

txt = sprintf('%i',round(median(GOOD(idx))));
text(300,9,txt,'Color',cmap(2,:));


%beautify
title('KS good cluster count, all sessions')
ylabel('session count')
xlabel('units')
legend('1st use','Reuse')
axis square
box off

%% reused probes 

REUSE = [15 16 17 18];
REUSE = find(ismember(1:length(AreaRecorded),REUSE));
ReuseAreas = unique(AreaRecorded(REUSE));
Population = ismember(AreaRecorded,ReuseAreas);
Population(REUSE) = 0;

ReusedPopulation = double(Population);
ReusedPopulation(REUSE) = 2;

h1=figure('Color','w','PaperPositionMode','auto');
hold on
Area_selected = ReusedPopulation;
offset = [-.15 .15];

%------- mean
subplot(1,3,1)
hold on

yy = SummaryStats{1};

for kk = 1:3

    axis square
    hold on
    y = yy(kk,:);
    if kk == 3
        yyaxis right
    else
        yyaxis left
        ylim([0 1000])

    end
    for k = 1:2
        x = kk + offset(k);
        y1 = y(:,Area_selected == k);
        me = nanmean(y1);
        sem = nanstd(y1)./sqrt(numel(y1));
        
        scatter(x,y1, ...
            '.','MarkerFaceColor',cmap(k,:),'MarkerEdgeColor',cmap(k,:))
        rectangle('Position', [x-.1, me-sem, .2, sem*2], ...
                'Curvature', 0.2, ...
                'FaceColor', [0, 0, 0, 0.1], ...
                'EdgeColor', [0, 0, 0, 0.1]);
        plot(x,me,'o','MarkerFaceColor',cmap(k,:),'MarkerEdgeColor','w','LineWidth',1,'MarkerSize',6)

        %errorbar(x,m,s,'Color',colormap(k,:))
        %plot(x,m,'o','MarkerFaceColor',colormap(k,:),'MarkerEdgeColor',colormap(k,:))

        test_y{k} = y1;
    end

    [p,r] = ttest2(test_y{1},test_y{2});

    y_p = 1000;
    if kk == 3
        y_p = 2000;
    end
    if p
        t = sprintf('%.2g',r);
        text(kk,y_p,t, 'FontSize',8,'Color',[.7 .7 .7])
    else
        t = 'ns';
        text(kk,y_p,t, 'FontSize',8,'Color',[.7 .7 .7])
    end
end

xlim([0.5 3.5])

set(gca,'Xtick',1:3)
set(gca,'XtickLabel',{'MUA','Good','Amplitude'})
axis square
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = [.7 .7 .7];
                                
%ylim([0 2])
title('Mean Yield')

%------- max yield
subplot(1,3,2)
hold on

yy = SummaryStats{2};

for kk = 1:3

    axis square
    hold on
    y = yy(kk,:);
    if kk == 3
        yyaxis right
    else
        yyaxis left
        ylim([0 1000])

    end
    for k = 1:2
        x = kk + offset(k);
        y1 = y(:,Area_selected == k);
        me = nanmean(y1);
        sem = nanstd(y1)./sqrt(numel(y1));
        
        scatter(x,y1, ...
            '.','MarkerFaceColor',cmap(k,:),'MarkerEdgeColor',cmap(k,:))
        rectangle('Position', [x-.1, me-sem, .2, sem*2], ...
                'Curvature', 0.2, ...
                'FaceColor', [0, 0, 0, 0.1], ...
                'EdgeColor', [0, 0, 0, 0.1]);
        plot(x,me,'o','MarkerFaceColor',cmap(k,:),'MarkerEdgeColor','w','LineWidth',1,'MarkerSize',6)

        %errorbar(x,m,s,'Color',colormap(k,:))
        %plot(x,m,'o','MarkerFaceColor',colormap(k,:),'MarkerEdgeColor',colormap(k,:))

        test_y{k} = y1;
    end

    [p,r] = ttest2(test_y{1},test_y{2});
    y_p = 1000;
    if kk == 3
        y_p = 2500;
    end
    if p
        t = sprintf('%.2g',r);
        text(kk,y_p,t, 'FontSize',8,'Color',[.7 .7 .7])
    else
        t = 'ns';
        text(kk,y_p,t, 'FontSize',8,'Color',[.7 .7 .7])
    end
end

xlim([0.5 3.5])
set(gca,'Xtick',1:3)
set(gca,'XtickLabel',{'MUA','Good','Amplitude'})
axis square
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = [.7 .7 .7];
                                
%ylim([0 2])
title('Max Yield')

%------- exponential decay
subplot(1,3,3)
hold on

yy = SummaryStats{5};

for kk = 1:3

    axis square
    hold on
    y = yy(kk,:);
   
    test_y = cell(2,1);

    for k = 1:2
        x = kk + offset(k);
        y1 = y(:,Area_selected == k);
        me = nanmean(y1);
        sem = nanstd(y1)./sqrt(numel(y1));
        
        scatter(x,y1, ...
            '.','MarkerFaceColor',cmap(k,:),'MarkerEdgeColor',cmap(k,:))
        rectangle('Position', [x-.1, me-sem, .2, sem*2], ...
                'Curvature', 0.2, ...
                'FaceColor', [0, 0, 0, 0.1], ...
                'EdgeColor', [0, 0, 0, 0.1]);
        plot(x,me,'o','MarkerFaceColor',cmap(k,:),'MarkerEdgeColor','w','LineWidth',1,'MarkerSize',6)

        %errorbar(x,m,s,'Color',colormap(k,:))
        %plot(x,m,'o','MarkerFaceColor',colormap(k,:),'MarkerEdgeColor',colormap(k,:))
        
        test_y{k} = y1; 

    end

    [p,r] = ttest2(test_y{1},test_y{2});

    if p
        t = sprintf('%.2g',r);
        text(kk,0.02,t, 'FontSize',8,'Color',[.7 .7 .7])
    else
        t = 'ns';
        text(kk,0.02,t, 'FontSize',8,'Color',[.7 .7 .7])
    end
end

xlim([0.5 3.5])
set(gca,'Xtick',1:3)
set(gca,'XtickLabel',{'MUA','Good','Amplitude'})
axis square
ax = gca;
ax.YAxis(1).Color = 'k';
                                
title('Exponential decay')

tit_str = 'Mouse_Reuse';




