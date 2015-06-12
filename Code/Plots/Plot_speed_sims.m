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

newsim=0;
if newsim==1
    task.savestuff=0;
    [task,T,S,P,Pro,Z]= run_speed_sims;
else
    load([rootDir, '../Data/Results/speed_test'])
end

%% setup plots
h=figure(2); clf, hold all

set(gcf,'DefaultAxesColorOrder',[...
    1 0 1;... LOL
    0 1 0;... FLD o PCA
    0 0 1;... QOQ
    %     1 0 0;... RoLOL
    1 1 0;... RaLOL
    0 1 1;... FLOL
    ])

width=0.18;
height=0.3;
vspace=0.17;
hspace=0.08;
bottom(1)=0.12;
bottom(2)=bottom(1)+height+vspace; %1-(height+space);
left(1)=0.1;
left(2)=left(1)+width+hspace;         % left for 2nd column
left(3)=left(2)+width+hspace;% left for 3rd column
left(4)=left(3)+width+hspace;

%% plot time vs. d for several p's

for i=1:3
    %     subplot(2,3,i),
    subplot('Position',[left(i), bottom(2), width, height]), %[left,bottom,width,height]
    cla
    hold all
    for j=1:Ntypes
        errorbar(ks, mean_total(j,:,i),std_total(j,:,i)/sqrt(10),'linewidth',2)
    end
    %     grid on,
    axis('tight')
    set(gca,'xscale','log','Xtick',ks,'yscale','log')
    title(['(',char(i-1+'A'), ') p=', num2str(Ds(i))])
    if i==1,
        xlabel('d = # of embedded dimensions'),
        ylabel('time (sec)')
    end
    set(gca,'Ytick',[0.01, 0.1, 1.0],'YLim',[0.005, 1.2]) %:0.02:0.09)
    set(gca,'Xtick',[10,30,50,90],'XtickLabel',[10,30,50,90])
end

%% plot time vs. p for several D's
for i=1:3
%     subplot(2,3,3+i),
    subplot('Position',[left(i), bottom(1), width, height]), %[left,bottom,width,height]
    cla
    hold all
    if i==1, ii=1; elseif i==2, ii=3; else ii=5; end
    for j=1:Ntypes
        errorbar(Ds, squeeze(mean_total(j,ii,:)),squeeze(std_total(j,ii,:))/sqrt(10),'linewidth',2)
    end
    %     grid on,
    axis('tight')
    set(gca,'xscale','log','Xtick',Ds,'yscale','log')
    title(['(',char(i+3-1+'A'), ') d=', num2str(ks(ii))])
    if i==1,
        xlabel('p = # of ambient dimensions'),
        ylabel('time (sec)')
    end
    set(gca,'Ytick',[0.01, 0.1, 1.0],'YLim',[0.005, 1]) %:0.02:0.09)
    set(gca,'Xtick',[1000,2000,5000],'XtickLabel',[1000,2000,5000])
%     if i==3
%        legend('FLD o PCA','LOL','QOQ','LAL','LFL','Location','EastOutside') %'RoLOL', 
%     end
end

%% legend(types)

pos=[left(4), bottom(1), width, height]; %[left+(4-1)*(width+hspace)+0.04 0.2 width+0.05 height]; %[left,bottom,width,height]
% hl=subplot(F.Nrows,F.Ncols,F.Ncols);
hl=subplot('position',pos);
hold all, i=1; clear g
set(gcf,'DefaultAxesColorOrder',[...
    0 1 0;... FLD o PCA
    1 0 1;... LOL
    0 0 1;... QOQ
    %     1 0 0;... RoLOL
    1 1 0;... RaLOL
    0 1 1;... FLOL
    ])

i=1;
g(i)=plot(0,0,'color',[0 0 1],'linewidth',2); i=i+1; % QOQ
g(i)=plot(0,0,'color',[0 1 0],'linewidth',2); i=i+1; % LOL
g(i)=plot(0,0,'color',[1 0 1],'linewidth',2); i=i+1; % FLDoPCA
g(i)=plot(0,0,'color',[0 1 1],'linewidth',2); i=i+1; % LFL
g(i)=plot(0,0,'color',[1 1 0],'linewidth',2); i=i+1; % LAL


l=legend(g,...
    'QOQ',...
    'FLDoPCA',... 
    'LOL',... 
    'LFL',...
    'LAL'); 

legend1 = legend(hl,'show'); %
set(legend1,...
    'Position',[0.8 0.4 0.24 0.2],... [left, bottom, width, height]
    'FontName','FixedWidth',...
    'FontSize',9);
set(gca,'XTick',[],'YTick',[],'Box','off','xcolor','w','ycolor','w')
legend('boxoff')


% print figure
if savestuff
    H.wh=[6.5 3.25];
    H.fname=[fpath(1:findex(end-2)), 'Figs/', fname];
    print_fig(h,H)
end
