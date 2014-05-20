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
maxx=0;
if isfield(T,'types')
    Nalgs=T.Nalgs+length(T.types)-1;
else
    Nalgs=T.Nalgs;
end


legendcell=[];
% for i=1:T.Nalgs
%     if strcmp(T.algs{i},'LOL') % plot rectangle demarking region that is better than LOL
%         p=patch([0 S.mins.mean.k(i) S.mins.mean.k(i) 0],[0 0 S.mins.mean.Lhats(i) S.mins.mean.Lhats(i)],0.8*[1 1 1]);
%         set(p,'FaceAlpha',0.01,'EdgeColor','none');
%         hAnnotation = get(p,'Annotation');
%         hLegendEntry = get(hAnnotation,'LegendInformation');
%         set(hLegendEntry,'IconDisplayStyle','off')
%     end
%     legendcell=[legendcell; T.algs(i)];
% 
% end
if isfield(T,'types')
%     legendcell(end)=[];
    for i=1:length(T.types)
        legendcell=[legendcell; T.types(i)];
    end
end

for i=1:Nalgs
    location=S.means.Lhats(i,:);
    if length(location)>1
        if ~isnan(location(2))
            plot(S.mins.mean.k(i),S.mins.mean.Lhats(i),'.',...
                'color',F.colors{i},'MarkerSize',F.markersize{i},...
                'Marker',F.markers{i},'LineWidth',F.linewidth{i})
            
            miny=min(miny,S.mins.mean.Lhats(i));
            maxy=max(maxy,S.mins.mean.Lhats(i));
            maxx=max(maxx,max(S.mins.mean.k));
        end
    end
end
Lchance=mean(S.Lchance);



% plot([1 10^4], Lchance*[1 1],'-k','linewidth',2)
axis('tight')
if col==1
    xlabel('# of dimensions')
end
if col==1, ylabel('$\langle \hat{L}_n \rangle$','interp','latex'), end

if ~isfield(F,'ylim'), ylim=[miny,maxy]; else ylim=F.ylim; end
if ~isfield(F,'ytick'),
    if Lchance<miny, miny=Lchance*0.9; end
    if maxy>Lchance, maxy=Lchance*1.1; end
    ytick=round(linspace(ylim(1),ylim(2),5)*100)/100;
    ytick=unique(ytick);
    if miny>=maxy miny=maxy-eps; end
    if any(diff(ytick)<0.001), ytick=[miny*0.9,maxy*1.1]; end
else
    ytick=F.ytick;
end

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
if ~isfield(F,'xlim')
    xlim=[0, xmax];
else
    xlim=F.xlim;
end
if isfield(F,'xtick'), xtick=F.xtick; end
if diff(ylim)<eps; ylim(1)=ylim(1)*0.9; ylim(2)=ylim(2)*1.1; end
yticks=(linspace(ylim(1),ylim(2),3));
set(gca,'XTick',xtick,'XLim',xlim,'YLim',ylim,'YTick',yticks)
if col==F.Ncols,
    Position=get(gca,'Position');
%     legend(legendcell,'Location','EastOutside');
%     set(gca,'Position',[Position(1), 0.47, 0.15, 0.16]);
%     legend('boxoff')
end
grid('on')
set(gca,'layer','top')
