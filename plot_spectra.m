function plot_spectra(T,P,Proj,F,row,col)
%  plot spectra, one row per task
% INPUT:
%   T: task info
%   P: task parameters
%   Proj: task projections
%   row: which row
%   col: which column


subplot(F.Nrows,F.Ncols,F.Ncols*row-col), hold all
maxd=0; maxy=0; 
legendcell=[];
for i=1:T.Nalgs;
    if strcmp(T.algs{i},'PCA')
        d=(Proj{i}.d);
        plot(d,'--k','linewidth',2)
        maxy=max(maxy,d(1));
        maxd=length(d);
        legendcell=[legendcell; {'dhat'}];
    elseif strcmp(T.algs{i},'SQDA')
        d0=Proj{i}.d0;
        d1=Proj{i}.d1;
        plot(d0,'--k','linewidth',2)
        plot(d1,'--m','linewidth',2)
        maxy=max(maxy,max(d0(1),d1(1)));
        maxd=max(max(max(d0),max(d1)),maxd);
        legendcell=[legendcell; {'dhat1'}; {'dhat2'}];
    end
end
if T.simulation
    plot(P.d1,'k','linewidth',2)
    plot(P.d0,'color',F.gray,'linewidth',2)
    maxy=max(maxy,P.d1(1));
    maxy=max(maxy,P.d0(1));
    maxd=max(max(max(P.d1),max(P.d0)),maxd);
    legendcell=[legendcell; {'d1'}; {'d0'}];
end
set(gca,'Yscale','linear','XLim',[1 maxd],'YLim',[0 1.1*maxy],'XScale','log')
grid on
if row==1
    legend(legendcell,'Location','NorthEast'),
end
if row==F.Nrows,
    xlabel('# of dimensions'),
    ylabel('eigenvalue')
end