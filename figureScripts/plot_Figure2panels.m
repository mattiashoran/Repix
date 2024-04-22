function plot_Figure2panels(data)

%% Plot Figure 2 panels
% A: Overview
% B: By user
% Mattias Horan, UCL, 2024

%% A
figure, hold on

Procedures = {'Implantation' 'Data' 'Explantation'};

for i = 1:3
    Attempts = sum(data.([Procedures{i} '_attempts']));
    Success = sum(data.([Procedures{i} '_success']));

    b = barh(i,[Success Attempts-Success],0.2,'stacked');
    b(1).FaceColor = 'b'; b(2).FaceColor = 'w';

    t = sprintf('%.2g%%',Success/Attempts*100);
    text(Success,i+0.2,t,'HorizontalAlignment','right');
end

yticks(1:3)
yticklabels(Procedures)
sgtitle('Fig 2A: Overview')


%% B
figure, hold on

nUsers = numel(data.User);
stats = nan(3,nUsers);

for k = 1:nUsers

    subplot(4,4,k), hold on

    for i = 1:3
        Attempts = data.([Procedures{i} '_attempts'])(k);
        Success = data.([Procedures{i} '_success'])(k);

        b = barh(i,[Success Attempts-Success],'stacked');
        b(1).FaceColor = 'b'; b(2).FaceColor = 'w';
        
        stats(i,k) = Success/Attempts;
    end

    yticks([])
    xlim([0 30])
    title(data.User(k))
end


sgtitle('Fig 2B: Users')


%---- stats
RepixShared = [1 2 2 2 1 1 1 1 1 1 1 2 1 1 2 1]; %was DirectTraining (1) or Shared (2)

p1 = ranksum(stats(1,RepixShared == 1),stats(1,RepixShared == 2));
p2 = ranksum(stats(2,RepixShared == 1),stats(2,RepixShared == 2));
p3 = ranksum(stats(3,RepixShared == 1),stats(3,RepixShared == 2));
pvalues = [p1 ; p2 ; p3];
t = table(pvalues,'RowNames',Procedures);
disp(t)

%---- summary table
