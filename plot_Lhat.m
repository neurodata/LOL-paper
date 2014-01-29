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
    if ~strcmp(T.algs{i},'LDA')
        %         errorbar(T.ks,S.means.Lhats(i,:),S.stds.Lhats(i,:)/10,'color',F.colors{i},'linewidth',2)
        if T.ntest>9
            plot(T.ks,S.medians.Lhats(i,:),'color',F.colors{i},'linewidth',2)
            loc=' median';
            temp=min(S.medians.Lhats(:));
        else
            plot(T.ks,S.means.Lhats(i,:),'color',F.colors{i},'linewidth',2)
            loc=' mean';
            temp=min(S.means.Lhats(:));
        end
        minAlg=min(minAlg,temp);
    else
        %         errorbar(T.ks,S.means.Lhats(i,1)*ones(size(T.ks)),S.stds.Lhats(i,1)*ones(size(T.ks)),'-','linewidth',2,'color',F.gray)
        if T.ntest>9
            plot(T.ks,S.medians.Lhats(i,1)*ones(size(T.ks)),'-','linewidth',2,'color',F.gray)
            minLDA=S.medians.Lhats(i,1);
        else
            plot(T.ks,S.means.Lhats(i,1)*ones(size(T.ks)),'-','linewidth',2,'color',F.gray)
            minLDA=S.means.Lhats(i,1);
        end
        
    end
end



% plot chance
% errorbar(1:T.Kmax,mean(S.Lchance)*ones(T.Kmax,1),std(S.Lchance)*ones(T.Kmax,1),'-k','linewidth',2)
plot(1:T.Kmax,mean(S.Lchance)*ones(T.Kmax,1),'-k','linewidth',2)

% plot emperically computed Lhat for the Bayes classifier
if T.QDA_model
    %     errorbar(1:T.Kmax,mean(S.Lbayes)*ones(T.Kmax,1),std(S.Lbayes)*ones(T.Kmax,1),'-.r','Linewidth',2)
    plot(1:T.Kmax,median(S.Lbayes)*ones(T.Kmax,1),'-.r','Linewidth',2)
    
    % plot risk if we can compute it analytically
    if isfield(S,'Risk')
        plot(1:T.Kmax,S.Risk*ones(T.Kmax,1),'-r','linewidth',2)
    end
end
% minT=min(0.5,minLDA);
% minT=min(minT,maxAlg);


% YU=min(YU,min(nanmax(S.means.Lhats(:,1:end-5))));

if T.ntest>9
    YL=nanmin(S.medians.Lhats(:));
else
    YL=nanmin(S.means.Lhats(:));
end
set(gca,'XScale','log','Ylim',[YL min(S.means.Lhats(:,1))*1.1],'Xlim',[1 T.Kmax])
ylabel(T.name)
grid on
if row==1, title(['Lhat', loc]), end
if row==1, legend(legendcell,'Location','NorthWestOutside'), end
if row==F.Nrows, xlabel('# of dimensions'), end