function plot_RecordingsOverTime(d,cmap,AreaRecorded)

%plots the recorings made over time for each implanted animals
%Mattias Horan, UCL, 2024

h1=figure('Color','w','PaperPositionMode','auto');

hold on

%remove nan for this plot
idx = ~isnan(d.DaysSinceImplant);
ID = d.MouseID(idx);
Days = d.DaysSinceImplant(idx);

uniqueMouseID = unique(ID);
nMice = length(uniqueMouseID);

%order by max recording length
Duration = [];
for i = 1:nMice
    curID = uniqueMouseID(i);
    idx = ID == curID;

    xx = Days(idx);

    Duration(i) = max(xx)-min(xx);

end

[~,Duration_idx] = sort(Duration);

%now, plot
for i = 1:nMice

    curID = uniqueMouseID(i);
    idx = ID == curID;

    curArea = AreaRecorded(curID);

    xx = Days(idx);
    yy = find(i==Duration_idx);

    plot([min(xx) max(xx)],yy*ones(2,1),'-','Color',[.7 .7 .7])

    s = scatter(xx,yy*ones(size(xx)),20,'o');
    s.MarkerFaceColor = cmap(curArea,:);
    s.MarkerEdgeColor = cmap(curArea,:);
end

ylabel('MouseID')
xlabel('Days since implant')
xl = xlim;
set(gca,'TickDir','out')

xlim([0 xl(2)])
set(gca,'YTick',1:nMice)
ylim([0 nMice+1])