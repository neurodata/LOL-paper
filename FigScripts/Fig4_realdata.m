% generalizations figure
clearvars, clc,
fpath = mfilename('fullpath');
findex=strfind(fpath,'/');
p = genpath(fpath(1:findex(end-2)));
addpath(p);

%% task properties consistent across all tasks
clear task
task.algs={'LOL';'GLM';'RF';'ROAD';'SVM'}; %add svm
task.simulation=0;
task.percent_unlabeled=0;
task.types={'DENL'};
task.ntrials=40;
task.savestuff=1;

%% prostate

j=1;
task1=task;
task1.name=['Prostate'];
task1.ks=1:50;
task1.ks=unique(round(logspace(0,log10(67),50)));
[T{j},S{j},P{j}] = run_task(task1);

%% prostate

j=2;
task1=task;
task1.name=['Colon'];
task1.ks=unique(round(logspace(0,log10(40),50)));
[T{j},S{j},P{j}] = run_task(task1);


%% mnist

j=3;
task1=task;
task1.name=['MNIST'];
task1.ntrain=100;
task1.ntest=500;
task1.algs={'LOL';'GLM';'RF';'SVM'}; 
task1.ks=unique(round(logspace(0,log10(task1.ntrain-1),50)));
[T{j},S{j},P{j}] = run_task(task1);


%% CIFAR-10
j=4;
task1=task;
task1.name=['CIFAR-10'];
task1.ntrain=300;
task1.ntest=500;
task1.algs={'LOL';'GLM';'RF';'SVM'}; 
task1.ks=unique(round(logspace(0,log10(task1.ntrain-1),50)));
[T{j},S{j},P{j}] = run_task(task1);



%% save stuff

if task.savestuff
    save([fpath(1:findex(end-2)), 'Data/Results/realdata.mat'],'task','T','S','P')
end
% load([fpath(1:findex(end-2)), 'Data/Results/realdata'])


%% make figs
% set figure parameters that are consistent across panels
clc
clear G F H
h=figure(1); clf,
G.plot_chance=false;
G.plot_bayes=false;
G.plot_risk=false;
G.plot_time=false;
G.Nrows=2;
G.Ncols=length(T); %ceil(length(T)/2);
G.location = 'NorthEast';
G.legend = {'LOL';'PCA'};
G.linestyle={'-';'-';'-';'-';'-';'-';'-'};
G.title='';

orange=[1 0.6 0];
gray=0.75*[1 1 1];
purple=[0.5 0 0.5];
G.colors={'g';'m';[1 0.6 0];'c';'b'};
G.ms=14;
G.lw=0.5;

G.ylim=[0,0.4];
G.ytick=[0:0.1:1];
G.yscale='linear';

% G.xlim=[1,30];
G.xtick=[2 4 8 16 32];
G.xscale='log';
G.xlim=[0,32];
% G.ticksize=500;
%

for s=1:length(S)
    F=G;
    if s==1
        F.title='';
        F.doxlabel=1;
        F.ylabel='error rate';
        F.ylim=[0.03,0.18];
        F.ytick=[0:0.04:1];
    elseif s==2
        F.ylim=[0.05,0.4];
        F.xlabel='                                # of embedded dimensions';
    elseif s==3
        F.ylim=[0.1,1];
        F.ytick=[0:0.2:1];
        F.xlim=[0,T{s}.ntrain];
        F.xtick=[4, 16, 64];
        F.colors={'g';'m';[1 0.6 0];'b'};
    elseif s==4
        F.ylim=[0.7, 0.95]; %[min(S{s}.means.Lhats(:)), max(S{s}.means.Lhats(:))];%         F.yticks=[0:0.1:1];
        F.yscale='linear';
        F.xlim=[0,T{s}.ntrain];
        F.xtick=[4, 16, 64, 256];
        F.colors={'g';'m';[1 0.6 0];'b'};
    end
    tit{s}=[T{s}.name]; %
    F.title=tit{s};
    F.plot_chance=1;
    plot_Lhat(T{s},S{s},F,s)
end

%
% figure(2); clf, hold all
G.markerstyle = {'o';'+';'d';'s';'^';'.'};
G.markersize=5;
G.linewidth=2;
G.xlim=[0.01,20]; %[minx, max(S{s}.time(:))]
G.xtick=logspace(-2,4,7);
for s=1:length(S)
    F=G;
    subplot(F.Nrows,F.Ncols,F.Ncols+s), hold all
    [minLhat, mindim]=min(S{s}.means.Lhats');
    if s~=4
        minx=0.01; miny=0.01;
    else
        minx=0.01; miny=0.5;
    end
    if s>2
       F.colors={'g';'m';[1 0.6 0];'b'};
    end
    %     F.ylim=[miny, max(mean(S{s}.Lchance),max(minLhat)*1.01)]; %[miny,max(minLhat)*1.01];
    F.ylim=[miny, 1]; %[miny,max(minLhat)*1.01];
    rectangle('Position',[minx,miny,mean(S{s}.time(:,1))-minx,minLhat(1)-miny],'FaceColor',0.7*[1 1 1],'EdgeColor','none')
    rectangle('Position',[mean(S{s}.time(:,1)),minLhat(1),1000,1],'FaceColor',0.8*[1 1 1],'EdgeColor','none')
    plot([minx,100],mean(S{s}.Lchance)*[1 1],'--k')
    for j=1:T{s}.Nalgs
        plot(mean(S{s}.time(:,j)),minLhat(j),'.','color',F.colors{j},'marker',F.markerstyle{j},'markersize',F.markersize,'LineWidth',F.linewidth)
    end
    set(gca,'Xlim',F.xlim,'Ylim',F.ylim,'Xtick',F.xtick)
    %     if s==1, xlabel('time (sec)'); end
    if s==1, ylabel('min error rate'), end
    set(gca,'Xscale','log','Yscale','log')
    title([', D=',num2str(T{s}.D),', n=',num2str(T{s}.ntrain)]);
    if s==2
        xlabel(['                                time (sec)']);
    end
end
% text(-1,1.5,'# of embedded dimensions')


% print figure
if task.savestuff
    H.wh=[6.5 3.5];
    H.fname=[fpath(1:findex(end-2)), 'Figs/realdata'];
    print_fig(h,H)
end
