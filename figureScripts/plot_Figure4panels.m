function plot_Figure4panels(data, data_ephys,overview,SummaryStats)

%% Plot Figure 4 panels, reuse
% A: Overview
% B: By user
% Mattias Horan, UCL, 2024

%% A: collective reuse
figure, hold on

Procedures = {'Implantation' 'Data' 'Explantation'};

Attempts = sum(data.Implantation_attempts);
Reuse = nansum(data.Implantation_reuse);

b = barh(1,[Reuse Attempts-Reuse],0.2,'stacked');
b(1).FaceColor = 'b'; b(2).FaceColor = 'w';

t = sprintf('%.2g%%',Reuse/Attempts*100);
text(Reuse,1+0.2,t,'HorizontalAlignment','right');


sgtitle('Fig 4A: Reuse overview')


%% B: individual reuse
figure, hold on

nUsers = numel(data.User);
stats = nan(nUsers);

for k = 1:nUsers

    subplot(4,4,k), hold on

        Attempts = data.Implantation_attempts(k);
        Reuse = data.Implantation_reuse(k);

        b = barh(1,[Reuse Attempts-Reuse],'stacked');
        b(1).FaceColor = 'b'; b(2).FaceColor = 'w';

        stats(1,k) = Reuse/Attempts;

    yticks([])
    xlim([0 30])
    title(data.User(k))
end


sgtitle('Fig 4B: Reuse in individual users')


%---- stats
RepixShared = [1 2 1 1 1 1 1 2 1]; %was DirectTraining (1) or Shared (2)

p1 = ranksum(stats(1,RepixShared == 1),stats(1,RepixShared == 2));
sprintf('p-reuse(Direct v Shared) = %.2g', p1)

%% C: yield at first use, amygdala

plot_FirstUseYieldAmygdala([])
sgtitle('Fig 4C: First Reuse Yield, Amygdala')

%% D: reuse yield and stability in the MEC

plot_ReuseMEC(data_ephys,overview,SummaryStats)
sgtitle('Fig 4D: Reuse yield and stability, MEC')

