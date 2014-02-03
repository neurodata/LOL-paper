function plot_everything(varargin)

if nargin==1
    load(['../data/results/Fig_choosek_', job]);
else
    i=1;
    job=varargin{i}; i=i+1;
    P=varargin{i}; i=i+1;
    Phat=varargin{i}; i=i+1;
    Proj=varargin{i}; i=i+1;
    S=varargin{i};
    
    Lchance=S.Lchance;
    means=S.means;
    stds=S.stds;
    mins=S.mins;
end


%% set some figure parameters
figure(1); clf
% figure('visible','off');

gray=0.5*[1 1 1];
colors{1}='m';
colors{2}='g';
colors{3}='b';
colors{4}=gray;

markers{1}='o';
markers{2}='+';
markers{3}='x';
markers{4}='*';

ncols=5;

Nalgs=length(tasks.algs);
legendcell=[];
for i=1:Nalgs
    legendcell=[legendcell; tasks.algs(i)];
end
legendcell=[legendcell;'chance'];
if tasks.simulation
    legendcell=[legendcell;'Bayes'];
end
legendcell=[legendcell;'Risk'];



%% make various plots
for j=1:tasks.Ntasks
    
    % plot accuracies
    subplot(tasks.Ntasks,ncols,ncols*j-4), hold all
    for i=1:Nalgs;
        if ~strcmp(tasks.algs{i},'LDA')
            errorbar(tasks.ks,means.Lhats(i,j,1:tasks.Nks),stds.Lhats(i,j,1:tasks.Nks)/10,'color',colors{i},'linewidth',2)
        else
            errorbar(tasks.ks,means.Lhats(i,j,1)*ones(size(tasks.ks)),stds.Lhats(i,j,1)*ones(size(tasks.ks)),'-','linewidth',2,'color',gray)
        end
    end
    
    % plot chance
    errorbar(1:tasks.Kmax,mean(S.Lchance(:,j))*ones(tasks.Kmax,1),std(S.Lchance(:,j))*ones(tasks.Kmax,1),'-k','linewidth',2)

    % plot emperically computed Lhat for the Bayes classifier
    if tasks.QDA_model
        errorbar(1:tasks.Kmax,mean(S.Lbayes(:,j))*ones(tasks.Kmax,1),std(S.Lbayes(:,j))*ones(tasks.Kmax,1),'-.r','Linewidth',2)
        
        % plot risk if we can compute it analytically
        if norm(P{j}.Sig1-P{j}.Sig2)<10^-4
            plot(1:tasks.Kmax,P{j}.Risk*ones(tasks.Kmax,1),'-r','linewidth',2)
        end
    end
    
    set(gca,'XScale','log','Ylim',[0 0.5],'YTick',[0, 0.2, 0.4],'Xlim',[1 tasks.ntrain(j)])
    ylabel(tasks.tasks{j})
    grid on
    if j==1, title(['mean Lhat, D=', num2str(tasks.D(j))]), end
    if j==1, legend(legendcell,'Location','NorthEastOutside'), end
    if j==tasks.Ntasks, xlabel('# of dimensions'), end
    
%     % plot relative accuracies
%     maxt=0.0;
%     mint=0.5;
%     subplot(tasks.Ntasks,ncols,ncols*j-3), hold all
%     for i=1:tasks.Nalgs;
%         if vs_chance
%             temp=squeeze(means.Lhats_chance(i,j,:));
%             plot(tasks.ks,temp(1:tasks.Nks),'color',colors{i},'linewidth',2)
%             titl='e_{chance}-e_j';
%             col=gray;
%         else
%             temp=squeeze(means.Lhats_LDA(i,j,:));
%             plot(tasks.ks,temp(1:tasks.Nks),'color',colors{i},'linewidth',2)
%             titl='e_{LDA}-e_j';
%             col='k';
%         end
%         plot(tasks.ks,zeros(tasks.Nks,1),'--','color',col,'linewidth',2)
%         maxt=max(maxt,max(temp(1:tasks.Nks)));
%         mint=min(mint,min(temp(1:tasks.Nks)));
%     end
%     ylabel(['ntrain=', num2str(tasks.ntrain(j))])
%     set(gca,'XScale','log','Ylim',[mint maxt],'Xlim',[1 tasks.ntrain(j)])
%     grid on
%     if j==1,
%         title(titl), 
%     end
    
    % plot spectra
    subplot(tasks.Ntasks,ncols,ncols*j-2), hold all
    maxd=0; maxy=0;
    for i=1:tasks.Nalgs;
        if strcmp(tasks.algs{i},'PCA')
            d=(Proj{j}{i}.d);
            plot(d,'--k','linewidth',2)
            maxy=max(maxy,d(1));
            maxd=length(d);
        elseif strcmp(tasks.algs{i},'SQDA')
            d0=Proj{j}{tasks.algs(i)}.d0;
            d1=Proj{j}{tasks.algs(i)}.d1;
            plot(d0,'--k','linewidth',2)
            plot(d1,'--m','linewidth',2)
            maxy=max(maxy,max(d0(1),d1(1)));
            maxd=max(max(max(d0),max(d1)),maxd);
        end
    end
    if tasks.simulation
        plot(P{j}.d1,'k','linewidth',2)
        plot(P{j}.d2,'color',gray,'linewidth',2)
        maxy=max(maxy,P{j}.d1(1));
        maxy=max(maxy,P{j}.d2(1));
        maxd=max(max(max(P{j}.d1),max(P{j}.d2)),maxd);
    end
    set(gca,'Yscale','linear','XLim',[1 maxd],'YLim',[0 1.1*maxy],'XScale','log')
    grid on
    if j==tasks.Ntasks, 
        legend('joint dhat','dhat1','dhat2','d1','d2','location','SouthWestOutside'), 
        xlabel('# of dimensions'), 
        ylabel('eigenvalue')
    end

    
    % plot sensitivity and specificity
    subplot(tasks.Ntasks,ncols,ncols*j-1), hold all
    for i=1:tasks.Nalgs;
        plot(mins.sensitivity(i,j),mins.specificity(i,j),'.','color',colors{i},'Marker',markers{i},'MarkerSize',8,'LineWidth',8)
    end
    plot(mins.sensitivity(i,j),mins.specificity(i,j),'.','color',gray,'Marker',markers{i},'MarkerSize',8,'LineWidth',8)
    plot([0, 1],[1, 0],'color',gray)
    axis([0, 1, 0, 1])
    ticks=0:.25:1;
    set(gca,'XTick',ticks,'YTick',ticks,'XTickLabel',[],'YTickLabel',[])
    grid on
    if j==tasks.Ntasks
        ylabel('sensitivity')
        xlabel('specificity')
        set(gca,'XTick',ticks,'YTick',ticks,'XTickLabel',ticks,'YTickLabel',ticks)
    end
    
    % plot Lhat and min_k
    subplot(tasks.Ntasks,ncols,ncols*j), hold all
    for i=1:tasks.Nalgs;
        plot(mins.k(i,j),mins.Lhats(i,j),'.','color',colors{i},'MarkerSize',8,'Marker',markers{i},'LineWidth',8)
    end
    grid on
    axis('tight')
    if j==tasks.Ntasks
        ylabel('Lhat')
        xlabel('# of dimensions')
    end
end

%% save plots
if tasks.savestuff
    wh=[8 tasks.Nalgs]*1.2;
    print_fig(gcf,wh,['performance_', tasks.job])
end
