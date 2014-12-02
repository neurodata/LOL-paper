% this script either loads or runs a new simulation of both regression and
% power, and then plots the results.

clearvars, clc,
fpath = mfilename('fullpath');
findex=strfind(fpath,'/');
p = genpath(fpath(1:findex(end-2)));
addpath(p);

%% 
newsim=1;
if newsim==1;
    S = regression_sims;
else
    load([fpath(1:findex(end-2)), 'Data/results/extensions'])
end
S{1}.savestuff=1;


%% plot figs
h=figure(1); clf,

for s=1:length(S)
    subplot(1,length(S),s), hold all
    col{1}='g'; col{2}='m';col{3}='c';col{4}='k';
    for j=1:length(S{s}.transformers)
        plot(S{s}.ks,S{s}.mean_lol(j,:)/S{s}.chance,'color',col{j},'linewidth',2)
    end
    if isfield(S,'mean_lasso')
        plot(S{s}.mean_nlam,S{s}.mean_lasso(1:length(S{s}.mean_nlam))/S{s}.chance,'c','linestyle','--','linewidth',2)
    end
    plot([0 100],S{s}.mean_pls/S{s}.chance*ones(2,1),'k','linestyle','-','linewidth',2)
    %     plot([0,max(S{s}.ks)],[chance chance],'r')
    T=S{s}.transformers;
    set(gca,'Yscale','log')
    xlim([0 90])
    if s==1
        ylabel('relative error')
        title('p=100, n=100, $\Sigma$=I','interpreter','latex')
        ylim([0,1.1])
    elseif s==2
        xlabel('# of dimensions embedded into')
        title('p=200, n=100, $\Sigma$=I','interpreter','latex')
        ylim([0,1.1])
    elseif s==3
        title('p=100, n=100, $\Sigma$=T','interpreter','latex')
        legend('LDA o \delta+PCA','LDA o PCA','lasso','pls','location','northeast')
        set(gca,'Yscale','linear')
        ylim([0,1])
    end
    set(gca,'XTick',[0, 25, 50, 75])
end

% print figure
if S{1}.savestuff
    H.wh=[7.5 2];
    H.fname=[fpath(1:findex(end-2)), 'Figs/extensions'];
    print_fig(h,H)
end