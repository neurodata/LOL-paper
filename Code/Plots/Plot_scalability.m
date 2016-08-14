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

filename = [rootDir, '../Data/Results/FM-LOL-IM.n-1000.d-100.csv'];
FMEM = import_da(filename);
LOL_IM=FMEM(2:end,2:end);
pvec_OI=FMEM(1,2:end);

filename = [rootDir, '../Data/Results/FM-LOL-EM.n-1000.d-100.csv'];
FMEM = import_da(filename);
LOL_EM=FMEM(2:end,2:end);
pvec_OE=FMEM(1,2:end);

filename = [rootDir, '../Data/Results/FM-LAL-IM.n-1000.d-100.csv'];
FMEM = import_da(filename);
LAL_IM=FMEM(2:end,2:end);
pvec_AI=FMEM(1,2:end);

filename = [rootDir, '../Data/Results/FM-LAL-EM.n-1000.d-100.csv'];
FMEM = import_da(filename);
LAL_EM=FMEM(2:end,2:end);
pvec_AE=FMEM(1,2:end);


filename = [rootDir, '../Data/Results/FM-PCA-IM.n-1000.d-100.csv'];
FMEM = import_da(filename);
PCA_IM=FMEM(2:end,2:end);
pvec_PI=FMEM(1,2:end);

filename = [rootDir, '../Data/Results/FM-PCA-EM.n-1000.d-100.csv'];
FMEM = import_da(filename);
PCA_EM=FMEM(2:end,2:end);
pvec_PE=FMEM(1,2:end);



% hem=errorbar(pvec,nanmean(da1),nanstd(da1),'--','color','g','linewidth',2);
% hin=errorbar(pvec2,nanmean(da2),nanstd(da2),'g','linewidth',4);
% hrpe=errorbar(pvec3,nanmean(da3),nanstd(da3),'--','color',orange,'linewidth',2);
% hrpi=errorbar(pvec4,nanmean(da4),nanstd(da4),'color',orange,'linewidth',4);


hrpe=plot(pvec_PE,nanmean(PCA_EM),'--','color','m','linewidth',2);
aem=plot(pvec_AE,nanmean(LAL_EM),'--','color',orange,'linewidth',2);
hem=plot(pvec_OE,nanmean(LOL_EM),'--','color','g','linewidth',2);


hrpi=plot(pvec_PI,nanmean(PCA_IM),'-','color','m','linewidth',2);
ain=plot(pvec_AI,nanmean(LAL_IM),'-','color',orange,'linewidth',2);
hin=plot(pvec_OI,nanmean(LOL_IM),'-g','linewidth',2);


xticks=pvec_OE(1,[2:2:end]);
yticks=[1,10,100,1000];
set(gca,'XTick',xticks,'XTickLabel',xticks,'XScale','log');
set(gca,'YTick',yticks,'Yscale','log');
xlim([min(pvec_OE), max(pvec_OE)])
xscale('log');
axis('tight')

% xlabel('p=dimensionality (in millions)               ')
% ylabel('time (sec) ','HorizontalAlignment','right')
% title('n=2000, d=100     ','HorizontalAlignment','right')
xlabel('p=dimensionality (in millions)')
ylabel('time (sec)')
title('n=2000, d=100')



%%
pvec=pvec_OE
text(max(pvec(:))+1,max(LOL_IM(:))-1e2,'I','color','g','fontsize',12,'FontName','FixedWidth')
text(max(pvec(:))+1,max(LOL_EM(:)),'E','color',dark_green,'fontsize',12,'FontName','FixedWidth')
text(max(pvec(:))-3,max(LOL_EM(:))-1e2,'LOL','color',mid_green,'fontsize',12,'FontName','FixedWidth')

text(max(pvec(:))+1,max(PCA_IM(:)),'I','color',orange,'fontsize',12,'FontName','FixedWidth')
text(max(pvec(:))+1,max(PCA_EM(:)),'E','color',dark_orange,'fontsize',12,'FontName','FixedWidth')
text(max(pvec(:))-3,max(LAL_EM(:)),'LAL','color',mid_orange,'fontsize',12,'FontName','FixedWidth')
% legend([hin, hem, hrpi, hrpe],'LOL-IM','LOL-EM','LAL-IM','LAL-EM','location','SouthEast')
% legend('boxoff')
% grid('on')


%% error
% subplot(132), 
pos(1)=pos(1)+width+hspace+0.08;
pos(3)=pos(3)-0.04;
subplot('position',pos), cla

hold all
filename = [rootDir, '../Data/Results/FM.n-1000.p-16000000.csv'];
FMEM = import_da3(filename);

title('n=2000, p=16,000,000')
LOL=FMEM(:,[1:5]);
LFL=FMEM(:,[6:10]);
PCA=FMEM(:,11:15);
LR_FLD=FMEM(:,16:20);
pvec=[1,10,50,100,500];
z=sqrt(size(PCA,2));
hpca=errorbar(pvec,nanmean(PCA),nanstd(PCA)/z,'m','linewidth',2);
hlfl=errorbar(pvec,nanmean(LFL),nanstd(LFL)/z,'color',orange,'linewidth',2);
hlol=errorbar(pvec,nanmean(LOL),nanstd(LOL)/z,'g','linewidth',2);
hlr=errorbar(pvec,nanmean(LR_FLD),nanstd(LR_FLD)/z,'c','linewidth',2);
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

