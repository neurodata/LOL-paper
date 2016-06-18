% this script either loads or runs a new simulation of both regression and
% power, and then plots the results.

clearvars, clc, 
fpath = mfilename('fullpath');
findex=strfind(fpath,'/');
rootDir=fpath(1:findex(end-1));
p = genpath(rootDir);
gits=strfind(p,'.git');
colons=strfind(p,':');
for i=0:length(gits)-1
    endGit=find(colons>gits(end-i),1);
    p(colons(endGit-1):colons(endGit)-1)=[];
end
addpath(p);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% testing %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

newsim=0;
if newsim==1;
    tasknames={'trunk4, D=100';'toeplitz, D=100'};
    task.Ntrials=2;
    task.save=0;
    [T,S,P,task] = run_hotelling_sims(tasknames,task);
elseif newsim==2
    tasknames={'diag_lopes';'rand_lopes'};
    task.Ntrials=40;
    task.save=0;
    task.D=200;
    task.ntrain=100;
    task.bvec=[1,5,10,15,20,50,100];
    [T,S,P,task] = run_hotelling_sims(tasknames,task);
else
    load([rootDir, '../Data/results/Lopes11a'])
end
S{1}.savestuff=1;


%% plot testing fig
height=0.58;
vspace=0.08;
bottom=0.22;
left=0.09;
left3=0.58;
width=0.19;
hspace=0.03;
pos(1)=left; pos(2)=width; pos(3)=hspace; pos(4)=bottom; pos(5)=height; 
figure(1), clf
plot_hotelling(T,S,pos)


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% regresssion %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

newsim=0;
task.save=1;
task.lasso=true;
if newsim==1;
    S = run_regression_sims(task);
else
    load([rootDir, '../Data/results/extensions'])
end
S{1}.savestuff=1;


%% plot regression figs
h=figure(1); %clf,

for s=2%:length(S)
    ytick=10.^[1:0.5:8];
    if s==1, ss=2; elseif s==2, ss=1; end
    pos=[left3, bottom, width, height]; %[left,bottom,width,height]
    subplot('position',pos)
    hold all
    col{1}='g'; col{2}='g';col{3}='m';col{4}='m';col{5}='r';col{6}='r';
    ls{1}='--'; ls{2}='-'; ls{3}='--';ls{4}='-'; ls{5}='-';
    for j=2%:length(S{s}.transformers)
        plot(S{s}.ks,S{s}.mean_lol(j,:),'color',col{j},'linewidth',2,'linestyle',ls{j})
    end
    if isfield(S{s},'mean_lasso')
        plot(S{s}.mean_nlam,S{s}.mean_lasso(1:length(S{s}.mean_nlam)),'color','c','linestyle','-','linewidth',2)
    end
    plot([0 100],S{s}.mean_pls*ones(2,1),'k','linestyle','-','linewidth',2)
    T=S{s}.transformers;
    set(gca,'Yscale','linear')
    xlim([0 90])
    if s==1
        title('(D) Sparse Sphere: D=1000, n=100')
        ytick=10.^[1:0.05:8];
        set(gca,'Ylim',[0.29*10^5,0.39*10^5],'Ytick',ytick) %,'YTickLabel',log10(ytick)/0.5)
    elseif s==2
        ylabel('regression error')
        title([{'(C) Sparse Toeplitz'}; {'D=1000, n=100'}])
        set(gca,'Ylim',[10^4,4*10^5],'YTick',ytick,'YTickLabel',log10(ytick)/0.5)
    elseif s==3
        title('p=100, n=100, $\Sigma$=T','interpreter','none')
        set(gca,'Yscale','linear')
        ylim([0,1])
    end
    set(gca,'YScale','log')
    set(gca,'XTick',[0, 25, 50, 75])
    xlabel('# of embedded dimensions')
end


%% plot legend

orange = [1 0.5 0];

pos=[left+(4-1)*(width+hspace)+0.04 0.2 width+0.05 height]; %[left,bottom,width,height]
% hl=subplot(F.Nrows,F.Ncols,F.Ncols);
hl=subplot('position',pos);
hold all, i=1; clear g
g(i)=plot(0,0,'color','g','linewidth',2); i=i+1;
g(i)=plot(0,0,'color',orange,'linewidth',2,'linestyle','-'); i=i+1;
g(i)=plot(0,0,'color',orange,'linewidth',2,'linestyle','--'); i=i+1;
g(i)=plot(0,0,'color','m','linewidth',2); i=i+1;
g(i)=plot(0,0,'color','c','linewidth',2); i=i+1;
g(i)=plot(0,0,'color','k','linewidth',2); i=i+1;


l=legend(g,...
    'LOL',... \delta+PCA',...
    'LAL',... \delta+RP',...
    'H o RP',...
    'H o PCA',...
    'Lasso',...
    'PLS'); %,transformers{3}};
legend1 = legend(hl,'show'); %
set(legend1,...
    'Position',[0.85 0.5 0.05 0.1],... [left, bottom, width, height]
    'FontName','FixedWidth',...
    'FontSize',9);
set(gca,'XTick',[],'YTick',[],'Box','off','xcolor','w','ycolor','w')
legend('boxoff')


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% save fig %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if S{1}.savestuff
    H.wh=[6.5 2];
    H.fname=[rootDir, '../Figs/regression_power'];
    print_fig(h,H)
end