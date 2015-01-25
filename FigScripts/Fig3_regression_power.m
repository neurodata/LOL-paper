% this script either loads or runs a new simulation of both regression and
% power, and then plots the results.

clearvars, clc,
fpath = mfilename('fullpath');
findex=strfind(fpath,'/');
p = genpath(fpath(1:findex(end-2)));
addpath(p);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% regresssion %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

newsim=0;
task.save=1;
task.lasso=true;
if newsim==1;
    S = run_regression_sims(task);
else
    load([fpath(1:findex(end-2)), 'Data/results/extensions'])
end
S{1}.savestuff=1;


%% plot figs
h=figure(1); clf,

for s=1:length(S)
    subplot(2,length(S),s), hold all
    col{1}='g'; col{2}='g';col{3}='m';col{4}='m';col{5}='r';col{6}='r';
    ls{1}='--'; ls{2}='-'; ls{3}='--';ls{4}='-'; ls{5}='-';
    for j=1:length(S{s}.transformers)
        plot(S{s}.ks,S{s}.mean_lol(j,:)/S{s}.chance,'color',col{j},'linewidth',2,'linestyle',ls{j})
    end
    if isfield(S{s},'mean_lasso')
        plot(S{s}.mean_nlam,S{s}.mean_lasso(1:length(S{s}.mean_nlam))/S{s}.chance,'color','c','linestyle','-','linewidth',2)
    end
    plot([0 100],S{s}.mean_pls/S{s}.chance*ones(2,1),'k','linestyle','-','linewidth',2)
    %     plot([0,max(S{s}.ks)],[chance chance],'r')
    T=S{s}.transformers;
    set(gca,'Yscale','linear')
    xlim([0 90])
    if s==1
        ylabel('relative error')
        title('Sparse Sphere: D=1000, n=100','interpreter','none')
        ylim([0,1.1])
        ylim([0.88,1.05])
        set(gca,'YTick',[0.05:0.05:2])
    elseif s==2
        title('Sparse Toeplitz: D=1000, n=100','interpreter','none')
        ylim([0,1.1])
        ylim([0.048,0.1])
        set(gca,'YTick',[0.05:0.025:1])
    elseif s==3
        title('p=100, n=100, $\Sigma$=T','interpreter','none')
        set(gca,'Yscale','linear')
        ylim([0,1])
    end
    set(gca,'XTick',[0, 25, 50, 75])
    xlabel('# of embedded dimensions')
    if s==1, 
        legendcell={'LR o \delta+RP','LR o \delta+PCA','LR o RP','LR o PCA'}; %,transformers{3}};
        if isfield(S{s},'mean_lasso'), legendcell{end+1}='LASSO'; end
        legendcell{end+1}='PLS'; 
        legend(legendcell,'location','northeast');
    end
end
[min(S{1}.mean_lol'), S{1}.mean_pls]
% print figure

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% testing %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

newsim=0;
if newsim==1;
    tasknames={'trunk4, D=100';'toeplitz, D=100'};
    task.Ntrials=40;
    task.save=1;
    [T,S] = run_hotelling_sims(tasknames,task);
else
    load([fpath(1:findex(end-2)), 'Data/results/Lopes11a'])
end
S{1}.savestuff=1;


%% plot fig
plot_hotelling(T,S,2,2,2)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% save fig %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if S{1}.savestuff
    H.wh=[7 4];
    H.fname=[fpath(1:findex(end-2)), 'Figs/regression_power'];
    print_fig(h,H)
end