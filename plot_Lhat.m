function plot_Lhat(T,S,F,row,col)
%  plot Lhats for each alg, one row per task
% INPUT:
%   T: task info
%   S: statistics of algorithms
%   F: figure properties
%   row: which row
%   col: which col

Nalgs=length(T.algs);
legendcell=[];
for i=1:Nalgs
    legendcell=[legendcell; T.algs(i)];
end
legendcell=[legendcell;'chance'];
if T.simulation
    legendcell=[legendcell;'Bayes'];
end
if T.QDA_model
    legendcell=[legendcell;'Risk'];
end
minLDA=0.5;

% plot accuracies
subplot(F.Nrows,F.Ncols,F.Ncols*row-(F.Ncols-col)), hold all
minAlg=0.5;
for i=1:Nalgs;
    
    if T.ntest>9
        location=S.medians.Lhats(i,:);
        loc=' median';
    else
        location=S.means.Lhats(i,:);
        loc=' mean';
    end
    minloc=min(location);
    
    if isnan(location(2)) % if no dimension tuning in algorithm
        plot(T.ks,location(1)*ones(size(T.ks)),'-','linewidth',2,'color',F.gray)
    else
        plot(T.ks,location,'color',F.colors{i},'linewidth',2)
        minAlg=min(minAlg,minloc);
    end
end


% plot chance
plot(1:T.Kmax,mean(S.Lchance)*ones(T.Kmax,1),'-k','linewidth',2)

% plot optimal (when available)
if T.QDA_model % plot emperically computed Lhat for the Bayes classifier
    plot(1:T.Kmax,median(S.Lbayes)*ones(T.Kmax,1),'-.r','Linewidth',2)
    
    if isfield(S,'Risk')     % plot risk if we can compute it analytically
        plot(1:T.Kmax,S.Risk*ones(T.Kmax,1),'-r','linewidth',2)
    end
end

% formatting
if T.ntest>9
    YL=nanmin(S.medians.Lhats(:));
else
    YL=nanmin(S.means.Lhats(:));
end
YU = min(S.means.Lhats(:,1))*1.1;
set(gca,'XScale','log','Ylim',[YL*0.9 YU],'Xlim',[1 T.Kmax])
ylabel(T.name)
grid on
if row==1, title(['Lhat', loc]), end
if row==1, legend(legendcell,'Location','NorthWestOutside'), end
if row==F.Nrows, xlabel('# of dimensions'), end