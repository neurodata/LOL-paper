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

dark_green = [0 0.7 0];
mid_green = [0 0.85 0];
orange = [1 0.5 0];
dark_orange = [255, 140, 0]/364;
mid_orange = [255, 140, 0]/310;

% time
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


filename = [rootDir, '../Data/Results/sparse-EM.n-1000.d-100.csv'];
FMEM = import_da(filename);
da3=FMEM(2:end,2:end);
pvec3=FMEM(1,2:end);

filename = [rootDir, '../Data/Results/sparse-IM.n-1000.d-100.csv'];
FMEM = import_da(filename);
da4=FMEM(2:end,2:end);
pvec4=FMEM(1,2:end);


% hem=errorbar(pvec,nanmean(da1),nanstd(da1),'--','color','g','linewidth',2);
% hin=errorbar(pvec2,nanmean(da2),nanstd(da2),'g','linewidth',4);
% hrpe=errorbar(pvec3,nanmean(da3),nanstd(da3),'--','color',orange,'linewidth',2);
% hrpi=errorbar(pvec4,nanmean(da4),nanstd(da4),'color',orange,'linewidth',4);

hem=plot(pvec,nanmean(da1),'-','color',dark_green,'linewidth',2);
hin=plot(pvec2,nanmean(da2),'g','linewidth',2);
hrpe=plot(pvec3,nanmean(da3),'-','color',dark_orange,'linewidth',2);
hrpi=plot(pvec4,nanmean(da4),'color',orange,'linewidth',2);

xticks=pvec(1,[2:2:end]);
yticks=[1,10,100,1000];
set(gca,'XTick',xticks,'XTickLabel',xticks/1e6,'XScale','log');
set(gca,'YTick',yticks,'Yscale','log');
xlim([min(pvec), max(pvec)])
xscale('log');
axis('tight')

% xlabel('p=dimensionality (in millions)               ')
% ylabel('time (sec) ','HorizontalAlignment','right')
% title('n=2000, d=100     ','HorizontalAlignment','right')
xlabel('p=dimensionality (in millions)')
ylabel('time (sec)')
title('n=2000, d=100')

%
text(max(pvec2(:))+1e7,max(da2(:))-1e2,'I','color','g','fontsize',12,'FontName','FixedWidth')
text(max(pvec(:))+1e7,max(da1(:)),'E','color',dark_green,'fontsize',12,'FontName','FixedWidth')
text(max(pvec(:))-3e7,max(da2(:))-1e2,'LOL','color',mid_green,'fontsize',12,'FontName','FixedWidth')

text(max(pvec2(:))+1e7,max(da4(:)),'I','color',orange,'fontsize',12,'FontName','FixedWidth')
text(max(pvec(:))+1e7,max(da3(:)),'E','color',dark_orange,'fontsize',12,'FontName','FixedWidth')
text(max(pvec(:))-3e7,max(da4(:)),'LAL','color',mid_orange,'fontsize',12,'FontName','FixedWidth')
% legend([hin, hem, hrpi, hrpe],'LOL-IM','LOL-EM','LAL-IM','LAL-EM','location','SouthEast')
% legend('boxoff')
% grid('on')


%% error
% subplot(132), 
pos(1)=pos(1)+width+hspace+0.08;
pos(3)=pos(3)-0.04;
subplot('position',pos), cla

hold all
filename = [rootDir, '../Data/Results/FM.n-1000.p-16000000-more.csv'];
FMEM = import_da2(filename);

title('n=2000, p=16,000,000')
LOL=FMEM(:,[1,3:3:end]);
LFL=FMEM(:,[1,4:3:end]);
PCA=FMEM(:,2:3:end);
pvec=[1,10,50,100,500];
z=sqrt(size(PCA,2));
hpca=errorbar(pvec,nanmean(PCA),nanstd(PCA)/z,'m','linewidth',2);
hlfl=errorbar(pvec,nanmean(LFL),nanstd(LFL)/z,'color',orange,'linewidth',2);
hlol=errorbar(pvec,nanmean(LOL),nanstd(LOL)/z,'g','linewidth',2);
xtick=pvec([1,2,3:end]);
ytick=[0.1:0.1:1];
set(gca,'XTick',xtick,'YTick',ytick,'XScale','log');
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

