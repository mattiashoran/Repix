function plot_FirstUseYieldAmygdala(d)

%% Data from Shanice Bailey, see individual users
% placeholder for reading this in directly
% Mattias Horan, UCL, 2024

color_map = [...
    184 13 72
    242 151 36
    36 106 108
    ]./256;

SurgeryOrder = 1:20;
SurgeryOrder(9) = 10;
SurgeryOrder(10) = 9;

Opacity = linspace(0,1,numel(SurgeryOrder));

ProbeSerial = [20403314152
20403314152
NaN
20403314152
20403314152
20403314152
19122514131
20403314102
20403314982
20403314102
20403314102
20403314982
20403314102
20403314902
20403314902
20403314902
20403314842
20403314842
20403314902
20403314902];

ProbeID = nan(size(ProbeSerial));
u = unique(ProbeSerial);
for i = 1:numel(u)    
    ProbeID(ProbeSerial == u(i)) = i;
end

Uses = [1
2
1
3
4
5
1
1
1
2
3
2
4
2
1
3
1
2
4
5];

YieldGOOD = [74
357
NaN
221
31
66
239
53
198
53
27
310
183
111
124
103
251
47
121
181];

YieldALL = [154
800
NaN
436
267
191
456
129
372
147
98
823
473
236
281
260
512
147
273
404];

uniqueProbeSerial = unique(ProbeSerial);

figure, 
subplot(1,2,1)
hold on
for i = 1:numel(uniqueProbeSerial)
    
    idx = ProbeSerial == uniqueProbeSerial(i);
    x = Uses(idx);
    y = YieldALL(idx);
    alpha = SurgeryOrder(idx);
    plot(x,y,'-','Color',color_map(3,:))
    
    %scatter
    s = scatter(x,y,100,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[1 1 1]); %first make a white dot, so you can see the line underneath the transparent dots
    for j = 1:sum(idx)
        s = scatter(x(j),y(j),100,'o');
        s.MarkerFaceColor = 'flat';
        s.MarkerEdgeColor = 'flat';
        s.CData = color_map(3,:);
        s.MarkerFaceAlpha = Opacity(alpha(j));

    end

end

axis square
xlim([0 5])
ylim([0 1000])
title('All KS units')
xlabel('Probe uses')

subplot(1,2,2)
hold on
for i = 1:numel(uniqueProbeSerial)
    
    idx = ProbeSerial == uniqueProbeSerial(i);
    x = Uses(idx);
    y = YieldGOOD(idx);
    alpha = SurgeryOrder(idx);
    plot(x,y,'Color',color_map(3,:))
    
    %scatter
    s = scatter(x,y,100,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[1 1 1]); %first make a white dot, so you can see the line underneath the transparent dots
    for j = 1:sum(idx)
        s = scatter(x(j),y(j),100,'o');
        s.MarkerFaceColor = 'flat';
        s.MarkerEdgeColor = 'flat';
        s.CData = color_map(3,:);
        s.MarkerFaceAlpha = Opacity(alpha(j));

    end

end

axis square
xlim([0 5])
ylim([0 1000])
title('Good')
xlabel('Probe uses')
legend('Individual probes')

%% anova
Yield = YieldGOOD;
anovan(Yield,{ProbeID,Uses});
