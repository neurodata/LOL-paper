function plot_Lhat_vs_time(T,S,F)
%  plot Lhat vs time for all algorithms
% INPUT:
%   T: task info
%   S: Statss
%   F: plotting details

for i=1:T.Nalgs
    if strcmp(T.algs{i},'LOL')
        LOL_ind=i;
    end
end

% plot Lhat and min_k
% figure(4), hold all
miny=0.5;
maxy=0;
legendcell=[];
minx=inf;
maxx=0;
for i=1:T.Nalgs;
    plot(S.mins.mean.times(i),S.mins.mean.Lhats(i),'.','color',F.colors{i},'MarkerSize',F.markersize{i},'Marker',F.markers{i},'LineWidth',F.linewidth{i})
    miny=min(miny,S.mins.mean.Lhats(i));
    maxy=max(maxy,S.mins.mean.Lhats(i));
    legendcell=[legendcell; T.algs(i)];
    minx=min(minx,min(S.mins.mean.times));
    maxx=max(maxx,max(S.mins.mean.times));
    display([T.name,' ', T.algs{i},', dhat=',num2str(S.mins.mean.Lhats(i)),', Lhat=',num2str(S.mins.mean.k(i))])
end
Lchance=mean(S.Lchance);
plot(0, Lchance,'.k','linewidth',2)
grid on
axis('tight')
% if row==F.Nrows
xlabel('time (sec)')
% end
% if col==1, 
ylabel('$\langle \hat{L}_n \rangle$','interp','latex')
%     , end
% if maxx<11
%     xtick=[0:2:10];
%     xticklabel={'0';'';'4';'';'8';'';'12'};
%     xmax=10;
% elseif maxx<21
%     xtick=[0:4:20];
%     xticklabel={'0';'';'8';'';'16';'';'24'};
%     xmax=20;
% else
%     xtick=10:10:100;
%     xticklabel={'10';'';'30';'';'50';'';'70'};
%     xmax=maxx;
% end
    
if Lchance<miny, miny=Lchance*0.9; end
ytick=round(linspace(miny*0.9,maxy*1.1,5)*1000)/1000;
% set(gca,'XTick',xtick,'XTickLabel',xticklabel,'XLim',[0, xmax],'YLim',[miny, maxy],'YTick',ytick)
% set(gca,'YLim',[miny, maxy],'YTick',ytick,'Xscale','log')
set(gca,'YLim',[miny maxy],'XLim',[minx*.95 maxx*1.05],'Xscale','log')
% axis('tight')
