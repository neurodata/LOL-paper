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
    plot(S.mins.mean.times(i),S.mins.mean.Lhats(i),'.','color',F.colors{i},'MarkerSize',F.markersize{i},'Marker',F.markers{i},'LineWidth',F.linewidth{i})
    miny=min(miny,S.mins.mean.Lhats(i));
    maxy=max(maxy,S.mins.mean.Lhats(i));
    legendcell=[legendcell; T.algs(i)];
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
ylabel('$\langle \hat{L}_n \rangle$','interp','latex')
if Lchance<miny, miny=Lchance*0.9; end
minx=10^floor(log10(minx));
maxx=10^ceil(log10(maxx));
xtick=10.^[-10:10];
set(gca,'YLim',[miny maxy],'XLim',[minx maxx],'YScale','linear','XTick',xtick,'XScale','log')
