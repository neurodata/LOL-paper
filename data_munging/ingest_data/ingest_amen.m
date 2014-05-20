% Important initial analyses:
%  
% PTSD vs Healthy
%  
% TBI vs Healthy
%  
% Non-comorbid PTSD vs TBI
%  
% Here is the select statement I used.
%  
% (Diagnosed_Brain_Trauma=1 and MoodDisorder =0 and AnxietyDisorder = 0 and ChildHoodDisorder =0 and dementia = 0 and SchizoPsycho =0) or (Diagnosed_Brain_Trauma =0 and MoodDisorder =0 and PTSD = 1 and ChildHoodDisorder =0 and dementia = 0 and SchizoPsycho =0)
%%

clearvars,clf, clc

load('~/Research/working/A/amen/data/adult_data_no_missing.mat')
names=fieldnames(adult_data);
n=length(adult_data.(names{1}));
D=length(names);

%%
for i=1:length(names)
    if strfind(names{i},'Depressed')==1
        j=i;
    end
end

Depressed=adult_data.(names{j});

%%
for i=1:length(names)
    if strfind(names{i},'PTSD')==1
        j=i;
    end
end

PTSD=adult_data.(names{j});


%%
for i=1:length(names)
    if strfind(names{i},'Diagnosed_Brain_Trauma')==1
        j=i;
    end
end

TBI=adult_data.(names{j});

%%
for i=1:length(names)
    if strfind(names{i},'Bipolar')==1
        j=i;
    end
end
Bipolar=adult_data.(names{j});

%%
for i=1:length(names)
    if strfind(names{i},'Mood')==1
        j=i;
    end
end
Mood_Disorder=adult_data.(names{j});


%%
for i=1:length(names)
    if strfind(names{i},'Adjustment_Disorder')==1
        j=i;
    end
end
Adjustment_Disorder=adult_data.(names{j});

%%
Gender=adult_data.(names{8});
idx=find(Gender>2);
Gender(idx)=NaN;

%%
for i=1:length(names)
    if strfind(names{i},'ADHD')==1
        j=i;
    end
end

temp=adult_data.(names{j});
ADHD=nan(size(temp));
for i=1:length(ADHD)
    if strcmp(temp{i},'Non-ADHD')
        ADHD(i)=0;
    else
        ADHD(i)=1;
    end
end


%%
for i=1:length(names)
    if strfind(names{i},'AnxietyDisorder')==1
        j=i;
    end
end
AnxietyDisorder=adult_data.(names{j});

%%
for i=1:length(names)
    if strfind(names{i},'Age_Group')==1
        j=i;
    end
end
temp=adult_data.(names{j});
Age_Group=nan(size(temp));
for i=1:length(Age_Group)
    if strcmp(temp{i},'Adult')
        Age_Group(i)=0;
    else
        Age_Group(i)=1;
    end
end


%%
for i=1:length(names)
    if strfind(names{i},'dementia')==1
        j=i;
    end
end
Dementia=adult_data.(names{j});

%%
k=0;
for i=1:length(names)
    if strfind(names{i},'Baseline')==1
        k=k+1;
    end
end
D=k;

%%
Baseline=nan(n,D);
k=0;
for i=1:length(names)
    if strfind(names{i},'Baseline')==1
%         display(names{i})
        k=k+1;
        Baseline(:,k)=adult_data.(names{i});
    end
end
Baseline=Baseline(:,3:end);



%%

X=nan(n,799);
k=0;
for i=80:length(names)
    if isempty(strfind(names{i},'_id'))
        k=k+1;
        X(:,k)=adult_data.(names{i});
    end
end



%%
Xa=X(:,1:299);
Xa=Xa-mean(Xa(:));
Xa=Xa/mean(std(Xa));

Xb=X(:,300:555);
Xb=Xb-mean(Xb(:));
Xb=Xb/mean(std(Xb));

Xc=X(:,556:556+128);
Xc=Xc-mean(Xc(:));
Xc=Xc/mean(std(Xc));

Xd=X(:,684:end);
Xd=Xd-mean(Xd(:));
Xd=Xd/mean(std(Xd));

X=[Xa, Xb, Xd];
COGNITIVE=Xa;
SPECT=Xb;
ACTIVATION=Xc;
READINGS=Xd;
BASELINE=Xb(:,1:128);
CONCENTRATION=Xb(:,129:end);
CR=[COGNITIVE, READINGS];


%%

% raw=nan(D,n);
% for i=1:D
%     if isnumeric(adult_data.(names{i})(i))
%         if ~strfind(adult_data.(names{i}),'_id')
%             raw(:,i)=adult_data.(names{i});
%         end
%     end
% end

%%
% [u,d,v]=svd(X);
% 
% X0=X(Depressed==0,:);
% X1=X(Depressed==1,:);
% 
%%
% 
% figure(1), imagesc(X), colorbar
% figure(2), plot(diag(d)), grid on
% 
% 
% figure(3),
% subplot(211), imagesc(X0), colorbar
% subplot(212), imagesc(X1), colorbar
% 
% figure(4), clf, plot(mean(X0,1)), hold all, plot(mean(X1,1))
%%

clear B0 B1 D X0 X1 Xa Xb Xc Xd adult_data d i j k n names temp u v Baseline
save('../../data/base/amen')

%%
[u,d,v]=svd(BASELINE);
%%

B0=BASELINE(Gender==2,:);
B1=BASELINE(Gender==1,:);

figure(1), imagesc(BASELINE), colorbar
figure(2), plot(diag(d))


figure(3),
subplot(211), imagesc(B0), colorbar
subplot(212), imagesc(B1), colorbar

figure(4), 
subplot(211), cla, plot(mean(B0,1),'k'), hold all, plot(mean(B1,1),'r'), title('Baseline Gender mean')
subplot(212), cla, plot(std(B0),'k'), hold all, plot(std(B1),'r'), title('Baseline Gender Std')
legend('2','1')

%%

A0=ACTIVATION(Gender==2,:);
A1=ACTIVATION(Gender==1,:);

figure(11), imagesc(ACTIVATION), colorbar
figure(12), plot(diag(d))


figure(13),
subplot(211), imagesc(A0), colorbar
subplot(212), imagesc(A1), colorbar

figure(14), 
subplot(211), cla, plot(mean(A0,1),'k'), hold all, plot(mean(A1,1),'r'), title('Activation Gender mean')
subplot(212), cla, plot(std(A0),'k'), hold all, plot(std(A1),'r'), title('Activation Gender Std')


