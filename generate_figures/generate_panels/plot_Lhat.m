function plot_Lhat(T,S,F,col)
%  plot Lhats for each alg, one col per task
% INPUT:
%   T: task info
%   S: statistics of algorithms
%   F: figure properties
%   col: which col


Nalgs=length(T.algs);
legendcell = cell(1,Nalgs);

if ~isfield(F,'plot_chance'), F.plot_chance=false; end
if ~isfield(F,'plot_bayes'), F.plot_bayes=false; end
if ~isfield(F,'plot_risk'), F.plot_risk=false; end
    
if F.plot_chance, legendcell=[legendcell,'chance']; end
if F.plot_bayes,  legendcell=[legendcell,'Bayes']; end
if F.plot_risk,   legendcell=[legendcell,'Risk']; end

% plot accuracies
subplot(F.Nrows,F.Ncols,col), hold all
minAlg=0.5;
maxloc=ones(1,Nalgs);
for i=1:Nalgs;
    location=S.means.Lhats(i,:);
    minloc=min(location);
    
    if length(location)>1
        if ~isnan(location(2))
            plot(T.ks,location,'color',F.colors{i},'linewidth',2)
            maxloc(i)=max(location(2:end));
        end
    end
    minAlg=min(minAlg,minloc);
end

if T.QDA_model % plot emperically computed Lhat for the Bayes classifier
    if F.plot_bayes
        plot(1:T.Kmax,median(S.Lbayes)*ones(T.Kmax,1),'-.r','Linewidth',2)
        YL=0.9*median(S.Lbayes);
    end
    
    if isfield(S,'Risk')     % plot risk if we can compute it analytically
        if F.plot_risk,
            plot(1:T.Kmax,S.Risk*ones(T.Kmax,1),'-r','linewidth',2),
        end
        % YL=0.9*S.Risk;
    end
end

% formatting
YU=1.01*min(maxloc); %YU = min(S.means.Lhats(:,1))*1.1;
YL=0.99*minAlg;
if YU<YL, YU=mean([YU,YL])*1.1; YL=mean([YU,YL])*0.9; end

% plot upper and lower bounds
if F.plot_chance,
    Lchance=mean(S.Lchance);
    plot(1:T.Kmax,Lchance*ones(T.Kmax,1),'-k','linewidth',2),
    if Lchance>YU
        YU=Lchance*1.05;
    end
    if Lchance<YL
        YL=Lchance*0.95;
    end
end
if col==1
    xlabel('# of dimensions')
end

xtick=round(linspace(min(T.ks),max(T.ks),4));   xtick=unique(xtick);
if ~isfield(F,'ylim'), ylim=[YL,YU]; else ylim=F.ylim; end
if ~isfield(F,'ytick'),
    ytick=round(linspace(YL,YU,5)*100)/100;    ytick=unique(ytick);
else
    ytick=F.ytick;
end
set(gca,'XScale','linear','Ylim',ylim,'Xlim',[1 T.Kmax+1],'XTick',xtick,'YTick',ytick)
title(T.name)
grid on
if col==1, ylabel('$\langle \hat{L}_n \rangle$','interp','latex'), end