function [X,Y] = load_amen(tname)

fpath = mfilename('fullpath');
load([fpath(1:end-31), 'Data/Preprocessed/amen'])

%% parse tname

if strfind(tname,'READINGS')
    X=READINGS;
elseif strfind(tname,'COGNITIVE')
    X=COGNITIVE;
elseif strfind(tname,'ACTIVATION')
    X=ACTIVATION;
elseif strfind(tname,'SPECT')
    X=SPECT;
elseif strfind(tname,'BASELINE')
    X=BASELINE;
elseif strfind(tname,'CONCENTRATION')
    X=CONCENTRATION;
elseif strfind(tname,'CR') % CR=[COGNITIVE, READINGS];
    X=CR;
end

if strfind(tname,'PTSD vs Healthy')
    ind0=find(PTSD);
    ind1=find(Healthy);
elseif strfind(tname,'TBI vs Healthy')
    ind0=find(TBI);
    ind1=find(Healthy);
elseif strfind(tname,'NC PTSD vs TBI')
    % (Diagnosed_Brain_Trauma=1 and MoodDisorder =0 and AnxietyDisorder = 0 and ChildHoodDisorder =0 and dementia = 0 and SchizoPsycho =0) or (Diagnosed_Brain_Trauma =0 and MoodDisorder =0 and PTSD = 1 and ChildHoodDisorder =0 and dementia = 0 and SchizoPsycho =0)
    
    temp0 = [TBI, ~Mood_Disorder, ~AnxietyDisorder, ~ChildHoodDisorder, ~Dementia, ~SchizoPsycho];
    ind0 = find(all(temp0'));
    
    temp1 = [PTSD, ~TBI, ~Mood_Disorder, ~ChildHoodDisorder, ~Dementia, ~SchizoPsycho];
    ind1 = find(all(temp1'));
    
end

Y=nan(size(PTSD));
Y(ind0)=0;
Y(ind1)=1;
ind_nan=isnan(Y);
Y(ind_nan)=[];
X(ind_nan,:)=[];


