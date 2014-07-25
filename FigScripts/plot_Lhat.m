function plot_Lhat(T,S,F,subplot_id)
%  plot Lhats for each alg, one col per task
% INPUT:
%   T: task info
%   S: statistics of algorithms
%   F: figure properties
%   subplot_id: which subplot_id

if nargin==3, subplot_id=1; F.Ncols=1; F.Nrows=1; end
if ~isfield(F,'plot_chance'), F.plot_chance=false; end
if ~isfield(F,'plot_bayes'), F.plot_bayes=false; end
if ~isfield(F,'plot_risk'), F.plot_risk=false; end
if isfield(T,'types')
    Nalgs=T.Nalgs+length(T.types);
else
    Nalgs=T.Nalgs;
end
if any(strcmp(T.algs,'LOL')), Nalgs=Nalgs-1; end
legendcell=[];

algs=[T.types; T.algs{2:end}];

% plot accuracies
subplot(F.Nrows,F.Ncols,subplot_id), cla, hold all
minAlg=0.5;
maxloc=ones(1,Nalgs);
for i=1:Nalgs;
    location=S.means.Lhats(i,:);
    scale=S.stds.Lhats(i,:);
    minloc=min(location);
    
    if strcmp(algs{i},'ROAD'), ks=mean(S.ROAD_num); else ks=T.ks; end
    
    if length(location)>1
        if ~isnan(location(2))
            h(i)=plot(ks,location,'color',F.colors{i},'linewidth',2,'linestyle',F.linestyle{i}); %,'marker',F.markers{i},'markersize',F.markersize{i});
            eh=errorbar(ks(1:10:end),location(1:10:end),scale(1:10:end),'.','linewidth',2,'color',F.colors{i});
            errorbar_tick(eh,50000);
            maxloc(i)=max(location(2:end-1));
            if i<=length(T.types)
                legendcell=[legendcell, T.types(i)];
            end
        end
    end
    minAlg=min(minAlg,minloc);
end

% plot lower bound
if F.plot_chance,
    Lchance=mean(S.Lchance);
    plot(1:T.Kmax,Lchance*ones(T.Kmax,1),'-k','linewidth',2),
    legendcell=[legendcell, {'Chance'}];
end

if T.QDA_model % plot emperically computed Lhat for the Bayes classifier
    if F.plot_bayes
        plot(1:T.Kmax,mean(S.Lbayes)*ones(T.Kmax,1),'-.r','Linewidth',2)
        YL=0.9*median(S.Lbayes);
        legendcell=[legendcell, {'Bayes'}];
    end
    
    if isfield(S,'Risk')     % plot risk if we can compute it analytically
        if F.plot_risk,
            plot(1:T.Kmax,S.Risk*ones(T.Kmax,1),'-r','linewidth',2),
        end
        % YL=0.9*S.Risk;
        legendcell=[legendcell, {'Risk'}];
    end
end


if ~isfield(F,'ylim'),
    YU=1.01*min(maxloc); %YU = min(S.means.Lhats(:,1))*1.1;
    if F.plot_bayes, minAlg=min(minAlg,mean(S.Lbayes)); end
    YL=0.99*minAlg;
    if YU<YL, YU=mean([YU,YL])*1.1; YL=mean([YU,YL])*0.9; end
    if F.plot_chance
        if Lchance>YU
            YU=Lchance*1.05;
        end
        if Lchance<YL
            YL=Lchance*0.95;
        end
    end
    ylim=[YL,YU];
else
    ylim=F.ylim;
end
if ~isfield(F,'ytick'),
    ytick=round(linspace(ylim(1),ylim(2),5)*100)/100;    ytick=unique(ytick);
else
    ytick=F.ytick;
end

if ~isfield(F,'xlim'), xlim=[1 T.Kmax+1]; else xlim=F.xlim; end
if isfield(F,'xtick'), 
    xtick=F.xtick;
else
    xtick=round(linspace(min(T.ks),max(T.ks),4));   xtick=unique(xtick);
end
if isfield(F,'title'), tit=F.title; else tit=T.name; end
if subplot_id==1, 
    ylabel('error rate')
end
if isfield(F,'legend'), legendcell=F.legend; end
if isfield(F,'location'),
    location=F.location;
else
    location='EastOutside';
end
if isfield(F,'yscale'), yscale=F.yscale; else yscale='linear'; end
if isfield(F,'legendOn'), legendOn=F.legendOn; else legendOn=0; end
if legendOn
    legend(h,legendcell,'Location',location);
else
    legend off
end
if isfield(F,'xlabel'),xlabel(F.xlabel); end
if isfield(F,'ylabel'),ylabel(F.ylabel); end


set(gca,'YScale',yscale,'XScale','linear','Ylim',ylim,'Xlim',xlim,'XTick',xtick,'YTick',ytick)
title(tit)
grid on
