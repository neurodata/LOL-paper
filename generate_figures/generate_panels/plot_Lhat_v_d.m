function plot_Lhat_v_d(T,S,F,row,col)
%  plot Lhat vs dimension for best performing algorithm
% INPUT:
%   T: task info
%   S: Statss
%   F: plotting details
%   row: which row
%   col: which column


% plot Lhat and min_k
subplot(F.Nrows,F.Ncols,F.Ncols*(row-1)+col), hold all
miny=0.5;
maxy=0;
legendcell=[];
maxx=0;
for i=1:T.Nalgs;
    plot(S.mins.mean.k(i),S.mins.mean.Lhats(i),'color',F.colors{i},'MarkerSize',F.markersize{i},'Marker',F.markers{i},'LineWidth',F.linewidth{i})
    miny=min(miny,S.mins.mean.Lhats(i));
    maxy=max(maxy,S.mins.mean.Lhats(i));
    legendcell=[legendcell; T.algs(i)];
    maxx=max(maxx,max(S.mins.mean.k));
    display([T.name,' ', T.algs{i},', dhat=',num2str(S.mins.mean.Lhats(i)),', Lhat=',num2str(S.mins.mean.k(i))])
end
Lchance=mean(S.Lchance);
% plot([1 10^4], Lchance*[1 1],'-k','linewidth',2)
grid on
axis('tight')
if col==1
    xlabel('# of dimensions')
end
if col==1, ylabel('$\langle \hat{L}_n \rangle$','interp','latex'), end
if maxx<11
    xtick=[0:2:10];
    xticklabel={'0';'';'4';'';'8';'';'12'};
    xmax=10;
elseif maxx<21
    xtick=[0:4:20];
    xticklabel={'0';'';'8';'';'16';'';'24'};
    xmax=20;
else
    xtick=10:10:100;
    xticklabel={'10';'';'30';'';'50';'';'70';'';'90';'';'110'};
    xmax=maxx;
end
    
if xmax<=0, xmax=0.1; end
if ~isfield(F,'ylim'), ylim=[miny,maxy]; else ylim=F.ylim; end
if ~isfield(F,'ytick'),
    if Lchance<miny, miny=Lchance*0.9; end
    if maxy>Lchance, maxy=Lchance*1.1; end
%     ytick=round(linspace(miny*0.9,maxy*1.1,5)*1000)/1000;    
    ytick=round(linspace(YL,YU,5)*100)/100;    
    ytick=unique(ytick);
    if miny>=maxy miny=maxy-eps; end
    if any(diff(ytick)<0.001), ytick=[miny*0.9,maxy*1.1]; end
else
    ytick=F.ytick;
end
set(gca,'XTick',xtick,'XTickLabel',xticklabel,'XLim',[0, xmax],'YLim',ylim,'YTick',ytick)
if col==F.Ncols, 
    Position=get(gca,'Position');
    legend_handle=legend(legendcell,'Location','EastOutside');
    set(gca,'Position',Position);
    legend('boxoff')
end

