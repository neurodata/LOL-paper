% speed sims figure
clearvars, clc,
fpath = mfilename('fullpath');
findex=strfind(fpath,'/');
rootDir=fpath(1:findex(end-1));
p = genpath(rootDir);
gits=strfind(p,'.git');
colons=strfind(p,':');
for i=0:length(gits)-1
    endGit=find(colons>gits(end-i),1);
    p(colons(endGit-1):colons(endGit)-1)=[];
end
addpath(p);

%%
h=figure(1); clf, hold all

height=0.65;
vspace=0.08;
bottom=0.22;
left=0.09;
left3=0.58;
width=0.4;
hspace=0.05;
pos(1)=left; pos(2)=bottom; pos(3)=width; pos(4)=height; 


%% time
% subplot(131), 
subplot('position',pos), cla
hold all
filename = [rootDir, '../Data/Results/FM-IM.n-1000.d-100.csv'];
FMEM = import_da(filename);
da2=FMEM(2:end-1,2:end);
pvec2=FMEM(1,2:end);

filename = [rootDir, '../Data/Results/FM-EM.n-1000.d-100.csv'];
FMEM = import_da(filename);
da1=FMEM(2:end,2:end);
pvec=FMEM(1,2:end);


hem=errorbar(pvec,nanmean(da1),nanstd(da1),'--','color',[0 0.7 0],'linewidth',2);
hin=errorbar(pvec2,nanmean(da2),nanstd(da2),'g','linewidth',4);

xticks=pvec(1,[1,5,7:end]);
set(gca,'XTick',xticks,'XTickLabel',xticks/1e6,'XScale','linear')
xlim([min(pvec), max(pvec)])
axis('tight')
xlabel('p=dimensionality (in millions)')
ylabel('time (sec)')
title('d=100')
legend([hin, hem],'IM','EM','location','NorthWest')
legend('boxoff')


%% error
% subplot(132), 
pos(1)=pos(1)+width+hspace+0.05;
subplot('position',pos), cla

hold all
filename = [rootDir, '../Data/Results/FM.n-1000.p-16000000.csv'];
FMEM = import_da(filename);

title('p=16,000,000')
LOL=FMEM(3:end-1,2:2:end);
PCA=FMEM(3:end-1,3:2:end);
pvec=[10,50,100,500];
hlol=errorbar(pvec,nanmean(LOL),nanstd(LOL),'g','linewidth',2);
hpca=errorbar(pvec,nanmean(PCA),nanstd(PCA),'m','linewidth',2);
xtick=pvec([1,3:end]);
ytick=[0.1:0.1:1];
set(gca,'XTick',xtick,'YTick',ytick,'XScale','linear')
xlim([min(pvec), max(pvec)])
axis('tight')
xlabel('# embedded dimensions')
ylabel('Error')
% legend([hpca, hlol],'PCA','LOL','location','NorthEast')


% %% error
% % subplot(133), 
% pos(1)=pos(1)+width+hspace;
% subplot('position',pos), cla
% 
% hold all
% filename = [rootDir, '../Data/Results/FM.n-1000.p-1000000.csv'];
% FMEM = import_da(filename);
% 
% title('p=1M')
% LOL=FMEM(3:end-1,2:2:end);
% PCA=FMEM(3:end-1,3:2:end);
% pvec=[10,50,100,500];
% hlol=errorbar(pvec,nanmean(LOL),nanstd(LOL),'g','linewidth',2);
% hpca=errorbar(pvec,nanmean(PCA),nanstd(PCA),'m','linewidth',2);
% xtick=pvec([1,3:end]);
% ytick=[0.1:0.1:1];
% set(gca,'XTick',xtick,'YTick',ytick,'XScale','linear')
% xlim([min(pvec), max(pvec)])
% axis('tight')
% xlabel('# embedded dimensions')
% % ylabel('Error')
% % legend([hpca, hlol],'PCA','LOL','location','NorthEast')

%%
H=struct;
H.wh=[6.5 2];
H.fname=[rootDir, '../Figs/scalability'];
print_fig(h,H)

