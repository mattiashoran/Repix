function [Outcomes,ID_str] = get_RepixOutcomes(dat,ID_str)
% takes tables from Beta User responses and turns them into a outcome
% matrix that's padded with NaN to easily plot a heatmap.

IDs = fieldnames(dat);

tmp = cell(4,numel(IDs));
for i = 1:numel(IDs)
    tmp{1,i} = [strcmpi(dat.(IDs{i}).("Implant outcome"),'Y')]; %implantations
    tmp{2,i} = [strcmpi(dat.(IDs{i}).("Experimental outcome"),'Y')]; %experiments
    tmp{3,i} = [strcmpi(dat.(IDs{i}).("Explant outcome"),'Y')]; %explantation
    tmp{4,i} = [contains(dat.(IDs{i}).("Implant type(s)"),'d','IgnoreCase',true)]; %dummy
end

ImplantOutcome = padcat(tmp{1,:}); 
ExperimentalOutcome = padcat(tmp{2,:});
ExplantOutcome = padcat(tmp{3,:});
DummyProbe = padcat(tmp{4,:});



%% Hierachically assing outcomes
Outcomes = ImplantOutcome;

Outcomes(ImplantOutcome == 0)       = 1;
Outcomes(ImplantOutcome == 1)       = 2;
Outcomes(ExperimentalOutcome == 1)  = 3;
Outcomes(ExplantOutcome == 1)       = 4;
Outcomes(DummyProbe == 1)           = 0; %dummy probes are 1


%rehape
user_implants = sum(~isnan(Outcomes),1); %number of sessions done by each user
[sorted_sessions, idx] = sort(user_implants); %sort by the number of sessions

Outcomes = Outcomes(:,idx);

ID_str = {ID_str{idx}};

end


%%
% %experimental
% SBe  = strcmpi(SB.ExperimentalOutcome,'Y');
% HDe  = strcmpi(HD.ExperimentalOutcome,'Y');
% MHe  = strcmpi(MH.ExperimentalOutcome,'Y');
% CMe  = strcmpi(CM.ExperimentalOutcome,'Y');
% VPe  = strcmpi(VP.ExperimentalOutcome,'Y');
% DRe  = strcmpi(DR.ExperimentalOutcome,'Y');
% ZSe  = strcmpi(ZS.ExperimentalOutcome,'Y');
% ETe  = strcmpi(ET.ExperimentalOutcome,'Y');
% TJe  = strcmpi(TJ.ExperimentalOutcome,'Y');
% SPe  = strcmpi(SP.ExperimentalOutcome,'Y');
% 
% ExperimentalOutcome = padcat(SBe ,HDe ,MHe , CMe, VPe, DRe, ZSe, ETe, TJe, SPe);


%Dummy Probe
% SBd  = contains(SB.ImplantType_s_,'d','IgnoreCase',true);
% HDd  = contains(HD.ImplantType_s_,'d','IgnoreCase',true);
% MHd  = contains(MH.ImplantType_s_,'d','IgnoreCase',true);
% CMd  = contains(CM.ImplantType_s_,'d','IgnoreCase',true);
% VPd  = contains(VP.ImplantType_s_,'d','IgnoreCase',true);
% DRd  = contains(DR.ImplantType_s_,'d','IgnoreCase',true);
% ZSd  = contains(ZS.ImplantType_s_,'d','IgnoreCase',true);
% ETd  = contains(ET.ImplantType_s_,'d','IgnoreCase',true);
% TJd  = contains(TJ.ImplantType_s_,'d','IgnoreCase',true);
% SPd  = contains(SP.ImplantType_s_,'d','IgnoreCase',true);
% 
% DummyProbe = padcat(SBd ,HDd ,MHd , CMd, VPd, DRd, ZSd, ETd, TJd,SPd);