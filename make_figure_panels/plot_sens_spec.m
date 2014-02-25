function plot_sens_spec(T,S,F,row,col)
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

% plot sensitivity and specificity
subplot(F.Nrows,F.Ncols,F.Ncols*row-col), hold all
for i=1:T.Nalgs;
    plot(S.mins.mean.sensitivity(i),S.mins.mean.specificity(i),'.','color',F.colors{i},'Marker',F.markers{i},'MarkerSize',8,'LineWidth',8)
end
plot([0, 1],[1, 0],'color',F.gray)
axis([0, 1, 0, 1])
ticks=0:.25:1;
set(gca,'XTick',ticks,'YTick',ticks,'XTickLabel',[],'YTickLabel',[])
grid on
title(['Se=',num2str(round(S.mins.mean.sensitivity(LOL_ind)*100)/100), ' Sp=', num2str(round(S.mins.mean.specificity(LOL_ind)*100)/100)])
if row==F.Nrows
    ylabel('sensitivity')
    xlabel('specificity')
    set(gca,'XTick',ticks,'YTick',ticks,'XTickLabel',ticks,'YTickLabel',ticks)
end