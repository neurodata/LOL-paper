LOL = import_mrn('../../Data/Results/LOL-MRN-40.csv');
PCA = import_mrn('../../Data/Results/PCA-LDA-MRN-40.csv');
RRLDA = import_mrn('../../Data/Results/RR-LDA-MRN-40.csv');


h=figure(1); 
cla, hold all
x=LOL(1,:);
LOL=LOL(2:end,:);
PCA=PCA(2:end,:);
RRLDA=RRLDA(2:end,:);
n=size(LOL,1);

meanLOL=nanmean(LOL);
meanPCA=nanmean(PCA);
meanRRLDA=nanmean(RRLDA);

% errorbar(x,meanLOL,nanstd(LOL)/sqrt(n),'linewidth',2)
% errorbar(x+1,meanPCA,nanstd(PCA)/sqrt(n),'linewidth',2)
% errorbar(x+2,meanRRLDA,nanstd(RRLDA)/sqrt(n),'linewidth',2)


plot(x,nanmean(LOL),'linewidth',2)
plot(x+2,nanmean(RRLDA),'linewidth',2)
plot(x+1,nanmean(PCA),'linewidth',2)

% legend('lol','pca','rrlda')

axis('tight')
t=title([{'(D) MRN'}; {['D > 500,000,000, n = 112']}]);
set(t, 'horizontalAlignment', 'left')
set(t, 'units', 'normalized')
set(t, 'position', [0.1 0.8 0])

ymin=min([meanLOL, meanPCA]);
ymax=0.5; %0.01+max([meanLOL, meanPCA])
set(gca,'XTick',[25:25:100],'YTick',[0:0.1:1],'ylim',[ymin,ymax])


plot([1 1],[1 1],'linewidth',2)
plot([1 1],[1 1],'linewidth',2)
plot([1 1],[1 1],'linewidth',2)
plot([1 1],[1 1],'linewidth',2)
plot([1 1],[1 1],'linewidth',2)


%  print(h,'mrn','-dpng','-r300')