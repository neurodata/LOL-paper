%% set path correctly
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

%% load example data
newsim=0;
if newsim==1;
    [T,S,P,task] = run_example_sims;
else
    load([rootDir, '../Data/Results/example_sims'])
end
pp=P; TT=T; SS=S;
if newsim==1;
    [T,S,P,task] = run_generalization_sims(task);
else
    load([rootDir, '../Data/Results/generalizations'])
end
for t=1:length(P)
    pp{end+1}=P{t};
    SS{end+1}=S{t};
    TT{end+1}=T{t};
end
P=pp; S=SS; T=TT;
S{1}.savestuff=0;



%% plot example panels

% clear G F H
h=figure(1); clf,
G.plot_chance=false;
G.plot_bayes=false;
G.plot_risk=false;
G.plot_time=false;
G.legendOn=0;
G.legend = {'LOL';'PCA'};

G.Nrows=5;
G.Ncols=4;

G.linestyle={'-';'-';'-';'-';'-';'-';'-'};

G.ytick=[0.1:.1:.5];
G.ylim=[0, 0.5];
G.yscale='linear';

G.xtick=[25:25:100];
G.xlim=[0, 80];
G.xscale='linear';


orange=[1 0.6 0];
gray=0.75*[1 1 1];
purple=[0.5 0 0.5];
G.colors = {'g';'m';'c'};
dd=2;
gg=dd*0.75;
% G.tick_ids{1}=G.xtick;
% G.tick_ids{2}=G.xtick-2;
% G.tick_ids{3}=G.xtick-1;

height=0.12;
vspace=0.08;
bottom=0.06;
left=0.09;
width=0.17;
hspace=0.06;
lfw='normal'; % legend fontweight
%% sample

for j=[1,2,4]
    task1=T{j};
    task1.rotate=false;
    [task1, X, Y, PP] = get_task(task1);
    
    Z = parse_data(X,Y,task1.ntrain,task1.ntest,0);
    
    pos=[left+(j-1)*(width+hspace) bottom+(height+vspace)*4-0.04 width height-0.01];
    subplot('position',pos), %[left,bottom,width,height]
    hold on
    
    maxd=task1.ntrain;
    mu=PP.mu; mu=mu/max(mu(:));
    plot(1:length(mu(:,2)),mu(:,1),'color','k','linestyle','-','linewidth',1.5)
    dashline(1:length(mu(:,2)),mu(:,2),dd/2,gg,dd/2,gg,'color',gray,'linewidth',1.5)
    if j==4
        dashline(1:length(mu(:,3)),mu(:,3),dd,gg,dd,gg,'color',0.5*[1 1 1],'linewidth',1.5)
    end
    
    xlim=[0,100];
    ylim=[-1,1];
    xtick=50:50:xlim(end);
    xticklabel=xtick;
    if j==1
        tit='(A) Rotated Trunk';
        ylabel('means','fontweight',lfw)
        xlabel('ambient dimension index','fontweight',lfw);
        ytick=[-1,0,1];
    elseif j==2,
        tit='(B) Toeplitz';
        xlim=[1,8];
        xtick=2:2:xlim(end);
        xticklabel=[{'2'};{'4'};{'...'};{'100'}];
        ytick=[];
    elseif j==3,
        tit='(C) Fat Tails';
        ytick=[];
    elseif j==4,
        tit='(D) 3 Classes';
    end
    title([{tit}; {['D=', num2str(T{j}.D), ' n=', num2str(T{j}.ntrain)]}])
    set(gca,'XTick',xtick,'XTickLabel',xticklabel,'Xlim',xlim,'ylim',ylim,'ytick',ytick)
    grid('off')
    
    
    % plot Lhat vs d
    pos=[left+(j-1)*(width+hspace) bottom+(height+vspace)*2 width height]; %[left,bottom,width,height]
    if j==1
        F=G;
        F.doxlabel=false;
        F.title='';
        F.ylabel='error rate';
        F.ytick=[0.0:0.2:1]; %[0.06, [0.1:0.1:0.3]];
        F.ylim=[0.0,0.5];
        F.xlabel='# of embedded dimensions';
        ids=1:10:100;
        F.xlim=[0,75];
    elseif j==2
        F=G;
        F.doxlabel=false;
        F.ylim=[0.30,0.51];
        F.ytick=[0:0.1:0.5];
        F.title='';
        ids=1:10;
        F.xlim=[0,75];
    elseif j==3
        F=G;
        F.doxlabel=false;
        F.ylim=[0.13,0.5];
        F.ytick=[0.0:0.15:1]; %:0.1:0.5];
        F.title='';
        %         F.xticklabel=[];
        ids=1:10:100;
        F.xlim=[0,75];
    elseif j==4
        F.name='3 Classes';
        F.ylim=[0.13,0.67];
        F.ytick=[0.15:0.2:1];
        F.xlim=[0 49];
        F.xtick=[15:15:F.xlim(2)];
    end
    plot_Lhat(T{j},S{j},F,pos)
    
    % plot covariances
    pos=[left+(j-1)*(width+hspace) bottom+(height+vspace)*3-0.06 0.15 0.15]; %[left,bottom,width,height]
    subplot('position',pos)
    imagesc(PP.Sigma(ids,ids))
    set(gca,'xticklabel',[],'yticklabel',[])
    colormap('bone')
    if j==1, ylabel('covariance','fontweight',lfw), end
    
end



%% make figs
% set figure parameters that are consistent across panels

G.colors = {'k';gray;0.5*[1 1 1]}; %'g';'k';'c';orange;'c';'m'};
G.ms=14;
G.lw=0.5;

G.ms1=1;
G.ms2=2;
%% scatter plots

hspace=0.06;
left=0.07;

for j=1:3%length(T)
    task1=T{j+4};
    task1.rotate=false;
    task1.ntest=5000;
    [task1, X, Y, PP] = get_task(task1);
    
    Z = parse_data(X,Y,task1.ntrain,task1.ntest,0);
    
    siz=0.11;
    pos=[left+(j-1)*(width+hspace)-0.02 bottom+(height+vspace)*1-0.04 siz siz]; %[left,bottom,width,height]
    subplot('position',pos)
    cla, hold on
    Xplot1=Z.Xtest(:,Z.Ytest==1);
    Xplot2=Z.Xtest(:,Z.Ytest==2);
    idx=1:100;
    
    % plot samples
    plot(Xplot1(1,idx),Xplot1(2,idx),'o','color',G.colors{1},'LineWidth',G.lw,'MarkerSize',G.ms1),
    plot(Xplot2(1,idx),Xplot2(2,idx),'x','color',G.colors{2},'LineWidth',G.lw,'MarkerSize',G.ms2)
    
    if j==1
        tit=['                  (E) QDA'];
        lims=[-2.5, 2.5];
        ticks=-3:1.5:3;
        idx=1:100;
        ylabel('dim 1','fontweight',lfw)
        xlabel('dim 2','fontweight',lfw)
    elseif j==2
        tit=['                  (F) Outliers'];
        axis('tight')
        idx=1:100;
    elseif j==3
        tit=['                  (G) XOR'];
        idx=1:200;
        lims=6*[-1,1];
        ticks=[-1:1];
    end
    title([{tit}; {['                  D=', num2str(T{j+4}.D), ' n=', num2str(T{j+4}.ntrain)]}])
    
    set(gca,'XTick',ticks,'YTick',ticks,'ZTick',ticks,'XLim',lims, 'YLim',lims, 'ZLim',lims)
    set(gca,'xticklabel',[],'yticklabel',[],'zticklabel',[])
    grid('off')
    
    % plot level sets
    pos=[left+(j-1)*(width+hspace)-0.02+0.11 bottom+(height+vspace)*1-0.04 siz siz]; %[left,bottom,width,height]
    subplot('position',pos), hold on
    % plot means
    plot(PP.mu(1,1),PP.mu(2,1),'.','color',G.colors{1},'linewidth',4,'MarkerSize',G.ms)
    plot(PP.mu(1,2),PP.mu(2,2),'.','color',G.colors{2},'linewidth',4,'MarkerSize',G.ms)
    
    % plot contours
    for nsig=1:2
        if size(PP.Sigma,3)==1,
            Sig=PP.Sigma(1:2,1:2);
        else
            Sig=PP.Sigma(1:2,1:2,nsig);
        end
        C = chol(Sig);
        angle = linspace(0,2*pi,200)';
        xy = [sin(angle) cos(angle)];
        XY = xy*C;
        ct=1; %if j~=3, ct=1; else ct=1; end
        plot(PP.mu(1,nsig)+ct*XY(:,1), PP.mu(2,nsig)+ct*XY(:,2),'-','color',G.colors{nsig},'linewidth',1.5); %M(1)+2*XY(:,1), M(2)+2*XY(:,2), 'b--')
    end
    
    if j==3 % for the multimodal example
        % plot more means
        plot(PP.mu(1,4),PP.mu(2,4),'.','color',G.colors{2},'linewidth',2,'MarkerSize',G.ms)
        plot(PP.mu(1,3),PP.mu(2,3),'.','color',G.colors{1},'linewidth',2,'MarkerSize',G.ms)
        
        % plot more contours
        plot(PP.mu(1,3)+ct*XY(:,1), PP.mu(2,3)+ct*XY(:,2),'-','color',G.colors{1},'linewidth',1.5); %M(1)+2*XY(:,1), M(2)+2*XY(:,2), 'b--')
        plot(PP.mu(1,4)+ct*XY(:,1), PP.mu(2,4)+ct*XY(:,2),'-','color',G.colors{2},'linewidth',1.5); %M(1)+2*XY(:,1), M(2)+2*XY(:,2), 'b--')
    end
    set(gca,'XTick',ticks,'YTick',ticks,'ZTick',ticks,'XLim',lims, 'YLim',lims, 'ZLim',lims)
    set(gca,'xticklabel',[],'yticklabel',[],'zticklabel',[])
    grid('off')
    
end

%%
G.title='';
% G=rmfield(G,'tick_ids');

for j=1:3
    F=G;
    if j==1 % QDA
        F.legendOn=0;
        F.colors = {'g';'b'};
        F.ylim=[0.18 0.44];
        F.xlim=[1 19];
        F.xtick=[5:5:max(F.xlim)];
        F.ytick=[0.2:0.1:0.5];
        F.xlabel='';
        F.linestyle={'-';'-'};
        F.xlabel='# of embedded dimensions';
        
    elseif j==2 % OUTLIERS
        F.ylim = [0.25, 0.27];
        F.ytick = [0:0.01:0.5]; %[F.ylim(1): 0.01: F.ylim(2)];
        F.xlim = [1 150];
        F.xtick=[50:50:F.xlim(end)];
        F.legendOn=0;
        F.colors = {'g';'r'};
        F.scale=1;
        
    elseif j==3 % XOR
        F.title = '';
        F.ylim = [0.3, 0.51];
        F.ytick = [0:0.1:0.5]; %[F.ylim(1): 0.01: F.ylim(2)];
        F.xlim = [1 15];
        F.xtick=[5:5:max(F.xlim)]; %:F.xlim(end)];
        F.legendOn=0;
        F.colors = {'g';'b'};
        F.linestyle={'-';'-';'--'};
        
    end
    
    pos=[left+(j-1)*(width+hspace) bottom+(height+vspace)*0+0.01 width height]; %[left,bottom,width,height]
    plot_Lhat(T{j+4},S{j+4},F,pos)
    
end


%% legend

pos=[left+(4-1)*(width+hspace)+0.05 0.07 width height]; %[left,bottom,width,height]
% hl=subplot(F.Nrows,F.Ncols,F.Ncols);
hl=subplot('position',pos);
hold all, i=1; clear g
g(i)=plot(0,0,'color','m','linewidth',2); i=i+1;
g(i)=plot(0,0,'color','c','linewidth',2); i=i+1;
g(i)=plot(0,0,'color','g','linewidth',2); i=i+1;
g(i)=plot(0,0,'color','r','linewidth',2); i=i+1;
g(i)=plot(0,0,'color','b','linewidth',2); i=i+1;

l=legend(g,...
    'FLD o PCA', ...'LDA o LOL(D,E,N)',... LDA o \delta+PCA',...
    'ROAD',...
    'LOL', ...'LDA o LOL(N,E,N)',...LDA o PCA',...
    'LRL',...'QDA o LOL(D,V,N)',...QDA o \delta+PCA^m',...
    'QOQ'); %,...'LDA o LOL(D,E,R)',...LDA o \delta+rPCA',...
legend1 = legend(hl,'show'); %
set(legend1,...
    'Position',[0.8 0.15 0.1 0.1],... %[left,bottom,width,height]
    'FontName','FixedWidth',...
    'FontSize',9);
% set(legend1,'YColor',[1 1 1],'XColor',[1 1 1],'FontName','FixedWidth');
set(gca,'XTick',[],'YTick',[],'Box','off','xcolor','w','ycolor','w')
legend('boxoff')


%% print figure
% if task.savestuff
%     H.wh=[7.5 6];
%     H.fname=[rootDir, '../Figs/properties'];
%     print_fig(h,H)
% end