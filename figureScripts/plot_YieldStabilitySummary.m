function plot_YieldStabilitySummary(SummaryStats,Title,RecArea,cmap)

%% Summary of ephys yield and stability
% Mattias Horan, UCL, 2024

h1=figure('Color','w','PaperPositionMode','auto');
hold on
Area_selected = RecArea(1,:);
offset = [-.3 -.1 .1 .3];
subplot_idx = [1 2 4 5 6];
ymax_list = [1000 2000 4 4 .1];
ymin_list = [0 0 -.5 -.5 -.3];
table_means = [];
table_var = [];
%loop over each of the summary stats
for j = 1:5
    subplot(2,3,subplot_idx(j))
    hold on

    % mark the null line
    if ismember(j,3:4)
        plot([0 4],[1 1],'-','Color',[.7 .7 .7])
    else
        plot([0 4],[0 0],'-','Color',[.7 .7 .7])
    end

    yy = SummaryStats{j};

    %loop over each of the measures
    for k = 1:3

        axis square
        hold on
        y = yy(k,:);

        if ismember(j, 1:2)

            if k == 3
                yyaxis right

            else
                yyaxis left
                ylim([ymin_list(j) ymax_list(j)])

            end
            ax = gca;
            ax.YAxis(1).Color = 'k';
            ax.YAxis(2).Color = [.7 .7 .7];
        else
            ylim([ymin_list(j) ymax_list(j)])
        end

        %loop over each of the brain areas
        for i = 1:4
            x = k + offset(i);
            y1 = y(:,Area_selected == i);

            me = nanmean(y1);
            sem = nanstd(y1)./sqrt(numel(y1));

            scatter(x,y1, ...
                '.','MarkerFaceColor',cmap(i,:),'MarkerEdgeColor',cmap(i,:))
            rectangle('Position', [x-.1, me-sem, .2, sem*2], ...
                'Curvature', 0.2, ...
                'FaceColor', [0, 0, 0, 0.1], ...
                'EdgeColor', [0, 0, 0, 0.1]);
            plot(x,me,'o','MarkerFaceColor',cmap(i,:),'MarkerEdgeColor','w','LineWidth',1,'MarkerSize',6)

            %save for table
            if j == 5 %exponential fit
                if k == 2 %Good unit stability
                    table_means = [table_means me];
                    table_var = [table_var sem];
                end
            end
        end



    end

    xlim([0.5 3.5])

    set(gca,'Xtick',1:3)
    set(gca,'XtickLabel',{'MUA','Good','Amplitude'})
    axis square

    title(Title{j})
end

%------- save
tit_str = 'Mouse_YieldSummary';
Save = 1;
if Save

    save_str = tit_str;

    set(h1, 'papersize', [24 24]);
    set(h1, 'paperposition', [0 0 24 24]);
    saveFolder = '/Users/mattiashoran/Desktop/RepixPlots';

    print(h1,fullfile(saveFolder,save_str),'-dpdf')

end
%%
%-- summary table
ExpFitMean = table_means';
ExpFitSem = table_var';

t = table(ExpFitMean, ExpFitSem,'RowNames',{'HPC','MEC','BLA','V1'});
disp(t)