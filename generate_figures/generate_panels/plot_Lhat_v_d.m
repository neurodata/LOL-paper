function plot_Lhat_v_d(T,S,F,row,col)
%  plot spectra, one row per task
% INPUT:
%   T: task info
%   P: task parameters
%   Proj: task projections
%   row: which row
%   col: which column

for i=1:T.Nalgs
    if strcmp(T.algs{i},'LOL')
        LOL_ind=i;
    end
end

% plot Lhat and min_k
subplot(F.Nrows,F.Ncols,F.Ncols*(row-1)+col), hold all
miny=0.5;
maxy=0;
legendcell=[];
maxx=0;
for i=1:T.Nalgs;
    plot(S.mins.mean.k(i),S.mins.mean.Lhats(i),'.','color',F.colors{i},'MarkerSize',F.markersize{i},'Marker',F.markers{i},'LineWidth',F.linewidth{i})
    miny=min(miny,S.mins.mean.Lhats(i));
    maxy=max(maxy,S.mins.mean.Lhats(i));
    legendcell=[legendcell; T.algs(i)];
    maxx=max(maxx,max(S.mins.mean.k));
    display([T.name,' ', T.algs{i},', dhat=',num2str(S.mins.mean.Lhats(i)),', Lhat=',num2str(S.mins.mean.k(i))])
end
grid on
axis('tight')
if row==F.Nrows
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
    xticklabel={'10';'';'30';'';'50';'';'70'};
    xmax=maxx;
end
    
set(gca,'XTick',xtick,'XTickLabel',xticklabel,'XLim',[0, xmax])

