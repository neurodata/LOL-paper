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
for i=1:T.Nalgs;
    plot(S.mins.mean.k(i),S.mins.mean.Lhats(i),'.','color',F.colors{i},'MarkerSize',F.markersize{i},'Marker',F.markers{i},'LineWidth',F.linewidth{i})
    miny=min(miny,S.mins.mean.Lhats(i));
    maxy=max(maxy,S.mins.mean.Lhats(i));
    legendcell=[legendcell; T.algs(i)];
end
grid on
axis('tight')
if row==F.Nrows
    xlabel('# of dimensions')
end
if col==1, ylabel('$\langle \hat{L}_n \rangle$','interp','latex'), end
set(gca,'XTick',[10:20:100],'XLim',[1 50])

% if row==2
%    legend(legendcell,'Location','NorthEast')
% end
