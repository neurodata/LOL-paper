function plot_Lhat_vs_time(T,S,F,row,col)
%  plot Lhat vs time for all algorithms
% INPUT:
%   T: task info
%   S: Stats
%   F: plotting details

subplot(F.Nrows,F.Ncols,F.Ncols*(row-1)+col), hold all

miny=0.5;
maxy=0;
legendcell=[];
minx=inf;
maxx=0;
for i=1:T.Nalgs;
    if strcmp(T.algs{i},'LOL') % plot rectangle demarking region that is better than LOL
        p=patch([10^-5 S.mins.mean.times(i) S.mins.mean.times(i) 10^-5],[0 0 S.mins.mean.Lhats(i) S.mins.mean.Lhats(i)],0.7*[1 1 1]);
        set(p,'FaceAlpha',0.01,'EdgeColor','none');
        hAnnotation = get(p,'Annotation');
        hLegendEntry = get(hAnnotation,'LegendInformation');
        set(hLegendEntry,'IconDisplayStyle','off')
    end
    
    h=plot(S.mins.mean.times(i),S.mins.mean.Lhats(i),'.',...
        'color',F.colors{i},'MarkerSize',F.markersize{i},...
        'Marker',F.markers{i},'LineWidth',F.linewidth{i});
    
    % turn off algs with multiple dimensions
    location=S.means.Lhats(i,:);
    if length(location)>1
        if ~isnan(location(2))
            set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        else
            legendcell=[legendcell; T.algs(i)];
        end
    else
        legendcell=[legendcell; T.algs(i)];    
    end
    
    miny=min(miny,S.mins.mean.Lhats(i));
    maxy=max(maxy,S.mins.mean.Lhats(i));
    minx=min(minx,min(S.mins.mean.times));
    maxx=max(maxx,max(S.mins.mean.times));
    display([T.name,' ', T.algs{i},', dhat=',num2str(S.mins.mean.Lhats(i)),', Lhat=',num2str(S.mins.mean.k(i))])
end
Lchance=mean(S.Lchance);
plot(minx, Lchance,'.k','markersize',16)

if maxy>Lchance, maxy=Lchance*1.1; end

% title(T.name)
grid on
xlabel('time (sec)')
if col==1, ylabel('$\langle \hat{L}_n \rangle$','interp','latex'), end
if Lchance<miny, miny=Lchance*0.9; end
minx=10^floor(log10(minx));
maxx=10^ceil(log10(maxx));
xtick=10.^[-10:10];
if ~isfield(F,'ylim'), ylim=[miny,maxy]; else ylim=F.ylim; end
if ~isfield(F,'ytick'),
    ytick=round(linspace(YL,YU,5)*100)/100;    ytick=unique(ytick);
else
    ytick=F.ytick;
end

set(gca,'YLim',ylim,'XLim',[minx maxx],'XTick',xtick,'XScale','log','Ytick',ytick)
set(gca,'layer','top')
if col==F.Ncols,
    Position=get(gca,'Position');
    legend(legendcell,'Location','EastOutside');
    set(gca,'Position',Position);
    legend('boxoff')
end
