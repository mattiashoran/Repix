function [SummaryStats,RecArea] = plot_YieldOverTime(d,cmap,SplitBy, Cohort)

%% plots the yield over time for each implanted animal
%Mattias Horan, UCL, 2024

%Remove NaN from MUA/Good columns
idx = ~isnan(d.MUA);
MouseID = d.MouseID(idx);
DaysSinceImplant = d.DaysSinceImplant(idx);
MUA = d.MUA(idx);
GOOD = d.GOOD(idx);
GOOD_amp = d.Amplitude(idx);
subplot_count = 0;
maxDaysSinceImplant = 0;

uniqueMouseID = unique(MouseID);
uniqueMouseID = uniqueMouseID(~isnan(uniqueMouseID));
nMice = length(uniqueMouseID);

%clean
if Cohort == 1
    bins = [-0.1 5 10 20 30 40 50 75 100 max(DaysSinceImplant)];
elseif Cohort == 2
    bins = [-0.1 4 8  max(DaysSinceImplant)];
elseif Cohort == 3
    bins = [-0.1 5 10  20  30 40 50  100  max(DaysSinceImplant)];
end

%preassign
firstData = nan(4,nMice);
maxData = nan(4,nMice);
maxDay = nan(4,nMice);
meanData = nan(4,nMice);
RecArea = nan(4,nMice);
fitData = nan(3,nMice,2);

%figure
h1=figure('Color','w','PaperPositionMode','auto');

%first, loop over the SplitByConditions (e.g. brain areas, k)
%then loop over the measures (total units, good, amplitude)
for k = 1:numel(unique(SplitBy))

    for kk = 1:3

        subplot_count = subplot_count+1;
        if kk == 1
            yy_dat = MUA;
        elseif kk == 2
            yy_dat = GOOD;
        elseif kk == 3
            yy_dat = GOOD_amp;
        end

        xx_all = []; %to be used for estimating the population fit
        yy_all = []; %to be used for estimating the population fit

        subplot(4,3,subplot_count)
        hold on

        %loop over and plot each animal with implants of the condition (e.g. brain area) 
        for i = 1:nMice
            curID = uniqueMouseID(i);
            curArea = SplitBy(curID);

            if curArea ~= k
                continue
            end

            idx = MouseID == curID;

            xx = DaysSinceImplant(idx);
            yy = yy_dat(idx);

            xx_all = [xx_all xx'];
            yy_all = [yy_all yy'];

            %plot fit exponential (see Luo et al)
            f2 = [];
            f2.a = nan;
            f2.b = nan;

            try
                f2 = fit(xx,yy,'exp1');
                x1 = linspace(min(xx), max(xx),40);
                y1 = f2.a*exp(f2.b*x1);
                %y1 = f2.a*exp(f2.b*x1) + f2.c*exp(f2.d*x1);

                p = plot(x1,y1);
                p.Color = cmap(curArea,:);
                p.LineWidth = 1;

                EnoughPointsToFit = 1;
            catch

                EnoughPointsToFit = 0;
            end

            if EnoughPointsToFit
                %save for plotting
                firstData(kk,i) = yy(find(xx == min(xx),1,'first'));
                [maxData(kk,i), idx] = max(yy,[],'omitnan');
                maxDay(kk,i) = xx(idx);
                meanData(kk,i) = nanmean(yy);
                fitData(kk,i,1) = f2.a;
                fitData(kk,i,2) = f2.b;
                RecArea(kk,i) = k;
            end
        end

        %fit exponential to all recordings for a population estimate
        binned_xx = nan(size(xx_all'));
        for jj = 1:numel(bins)-1
            binned_xx(xx_all > bins(jj) & xx_all <= bins(jj+1)) = jj;
        end
        binned_xx(xx_all<4) = 1;
        level_spacing = 7;
        Alt = xx_all'; %vector of the altitudes of each data point
        GSTAS = yy_all'; %vector of the GS-TAS for each data point
        altbins = binned_xx;%1 + floor(Alt(:) ./ level_spacing);   %convert altitude to relative level number
        mean_gstas = accumarray(altbins, GSTAS(:), [], @mean, NaN);  %all the real work
        altlevels = mean( [bins(2:end); bins(1:end-1)]);
        hasdata = ~isnan(mean_gstas);
        %scatter(altlevels(hasdata), mean_gstas(hasdata), 50, 'o','MarkerFaceColor',cmap(k,:),'MarkerEdgeColor','k');

        xx= altlevels(hasdata)';
        yy = mean_gstas(hasdata);
        f2 = fit(xx,yy,'exp1');
        x1 = linspace(min(xx), max(xx),40);
        y1 = f2.a*exp(f2.b*x1);

        %plot the population mean
        p = plot(x1,y1);
        p.Color = cmap(k,:);
        p.LineWidth = 3;

        %Beautify
        maxDaysSinceImplant = max([maxDaysSinceImplant max(DaysSinceImplant)]);

        if kk == 1
            yl = [0 1000];
            ylim(yl)
            y_str = sprintf('COUNT\nunits/channel');
            ylabel(y_str)
            title('ALL UNITS')

        elseif kk == 2
            yl = [0 400];
            ylim(yl)
            title('GOOD UNITS')
        elseif kk == 3
            y_str = sprintf('AMPLITUDE\n(A.U)');
            title('AMPLITUDE')
            ylabel(y_str)
            xlabel('Days since implant')
            yl = [0 3500];
            if k == 4
                yl = [0 350];
            end
            ylim(yl)

        else

        end

        %summary text
        y = meanData(kk,RecArea(kk,:) == k);
        m = round(nanmean(y));
        s = round(nanstd(y)./sqrt(numel(y)));
        t1 = sprintf('mean: %i (%i)',m,s);

        y = maxData(kk,RecArea(kk,:) == k);
        m = round(nanmean(y));
        s = round(nanstd(y)./sqrt(numel(y)));
        t2 = sprintf('max: %i (%i)',m,s);
        text(200,yl(2),sprintf('%s\n%s',t1,t2))

        %fix axes
        h = gca;
        set(h,'xscale','log')
        xlim(h,[2 365])
        set(h,'XTick',[0 10 100 365])
        
        set(h,'TickDir','out')
        axis square

        legend off

    end
end

%% SummaryStats

SummaryStats = {...
    meanData...
    maxData...
    meanData./firstData...
    meanData./maxData...
 fitData(:,:,2)...
 };

