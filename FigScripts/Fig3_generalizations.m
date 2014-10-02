% generalizations figure
clearvars, clc,
fpath = mfilename('fullpath');
findex=strfind(fpath,'/');
p = genpath(fpath(1:findex(end-2)));
addpath(p);

%% task properties consistent across all tasks
clear task
task.algs={'LOL'};
task.simulation=1;
task.percent_unlabeled=0;
task.types={'DEAL';'DEFL'};
task.ntrials=40;
task.D=100;
task.ntrain=50;
task.ntest=500;
task.ks=1:task.ntrain-1;
task.savestuff=1;

%% multiple (3) class trunk

j=1;
task1=task;
task1.name=['3trunk4, D=', num2str(task1.D)];
task1.rotate=true;
task1.types={'NEFL';'DEFL'};
[T{j},S{j},P{j}] = run_task(task1);

%% union of affine spaces

j=2;
task1=task;
task1.name=['r2toeplitz, D=', num2str(task1.D)]; %'r2c'; %
task1.types={'DEFL';'DVFQ'};
[T{j},S{j},P{j}] = run_task(task1);


%% outliers

j=3;
task1=task;
task1.name='gms';
task1.ntrials=80;

task1.ntrain=500;
task1.ntest=500;
task1.n=task1.ntrain+task1.ntest;
task1.ks=unique(round(logspace(0,log10(task1.ntrain/2),50)));
types={'DEFL';'DERL'};

[~,~, task1.types] = parse_algs(types);
[T{j},S{j},P{j}] = run_task(task1);


%% xor

j=4;
task1=task;
task1.name=['xor, D=', num2str(task1.D)];
task1.ntrain=100;
task1.types={'DVFQ';'DEAQ';'NEAQ'};
% task1.algs={'LOL';'RF'};

task1.ks=unique(floor(logspace(0,log10(task1.ntrain/2),30)));
task1.ks=task1.ks(1:13);
task1.ntrials=4;
[T{j},S{j},P{j}] = run_task(task1);


%% save generalizations

% if task.savestuff
%     save([fpath(1:findex(end-2)), 'Data/Results/generalizations'])
% end
load([fpath(1:findex(end-3)), 'Data/Results/generalizations'])

%% make figs
% set figure parameters that are consistent across panels

clear G F H
h=figure(1); clf,
G.plot_chance=false;
G.plot_bayes=false;
G.plot_risk=false;
G.plot_time=false;
G.Nrows=2;
G.Ncols=length(T)+1; %ceil(length(T)/2);
G.location = 'NorthEast';
G.legend = {'LOL';'PCA'};
G.ylim=[0.2, 0.5];
G.linestyle={'-';'-';'-';'-';'-';'-';'-'};
G.title='';

orange=[1 0.6 0];
gray=0.75*[1 1 1];
purple=[0.5 0 0.5];
G.colors = {'k';gray;0.5*[1 1 1]}; %'g';'k';'c';orange;'c';'m'};
G.ms=28;
G.lw=0.5;

%% scatter plots

for j=1:length(T)
    task1=T{j};
    task1.rotate=false;
    task1.ntest=5000;
    [task1, X, Y, PP] = get_task(task1);
    
    Z = parse_data(X,Y,task1.ntrain,task1.ntest,0);
    
    subplot(G.Nrows,G.Ncols,j), cla, hold on
    Xplot1=Z.Xtest(:,Z.Ytest==1);
    Xplot2=Z.Xtest(:,Z.Ytest==2);
    idx=1:100;
    
    % plot samples
    plot(Xplot1(1,idx),Xplot1(2,idx),'o','color',G.colors{1},'LineWidth',G.lw,'MarkerSize',2),
    plot(Xplot2(1,idx),Xplot2(2,idx),'x','color',G.colors{2},'LineWidth',G.lw,'MarkerSize',2)
    
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
        if j~=4, ct=1; else ct=0.3; end
        plot(PP.mu(1,nsig)+ct*XY(:,1), PP.mu(2,nsig)+ct*XY(:,2),'-','color',G.colors{nsig},'linewidth',2); %M(1)+2*XY(:,1), M(2)+2*XY(:,2), 'b--')
    end
    
    if j==4 % for the multimodal example
        % plot more means
        plot(PP.mu(1,3),PP.mu(2,3),'.','color',G.colors{1},'linewidth',2,'MarkerSize',G.ms)
        plot(PP.mu(1,4),PP.mu(2,4),'.','color',G.colors{2},'linewidth',2,'MarkerSize',G.ms)

        % plot more contours
        plot(PP.mu(1,3)+ct*XY(:,1), PP.mu(2,3)+ct*XY(:,2),'-','color',G.colors{1},'linewidth',2); %M(1)+2*XY(:,1), M(2)+2*XY(:,2), 'b--')
        plot(PP.mu(1,4)+ct*XY(:,1), PP.mu(2,4)+ct*XY(:,2),'-','color',G.colors{2},'linewidth',2); %M(1)+2*XY(:,1), M(2)+2*XY(:,2), 'b--')

    end

    if j==1     % if there is a 3rd class
        Xplot3=Z.Xtest(:,Z.Ytest==3);
        plot(Xplot3(1,idx),Xplot3(2,idx),'x','color',G.colors{3},'LineWidth',G.lw,'MarkerSize',2)
        plot(PP.mu(1,3),PP.mu(2,3),'.','color',G.colors{3},'linewidth',2,'MarkerSize',G.ms)
        plot(PP.mu(1,3)+ct*XY(:,1), PP.mu(2,3)+ct*XY(:,2),'-','color',G.colors{3},'linewidth',2); %M(1)+2*XY(:,1), M(2)+2*XY(:,2), 'b--')
    end
    
    if j==1
        zlabel('samples')
        title('(A) 3 Classes')
        lims=[-12,12];
        ticks=-10:10:10;
        idx=1:100;
    elseif j==2
        title('(B) Nonlinear')
        lims=[-2.5, 2.5];
        ticks=-3:1.5:3;
        idx=1:100;
    elseif j==3
        title('(C) Outliers')
        axis('tight')
        idx=1:100;
    elseif j==4
        title('(D) XOR')
        idx=1:200;
        lims=[-2,2];
        ticks=[-1:1];
    end
    
    set(gca,'XTick',ticks,'YTick',ticks,'ZTick',ticks,'XLim',lims, 'YLim',lims, 'ZLim',lims)
    set(gca,'xticklabel',[],'yticklabel',[],'zticklabel',[])
    grid('on')
    
end

%%
j=1; F=G;
F.title='';
F.legendOn=0;
F.yscale='linear';
% F.ytick=[0.1, 0.2, 0.4];
F.doxlabel=1;
F.xtick=[20:20:50];
F.xlim=[1, 49];
F.ytick=[0.25:.2:.7];
F.ylim=[0.24,0.67];
F.legend = {'LOL';'PCA'};
F.colors = {'g';'m'};
F.ylabel='error rate';
F.linestyle={'-';'-';'-';'-';'-';'-'};
plot_Lhat(T{j},S{j},F,F.Ncols+j)

%%
j=2; F=G;
F.legendOn=0;
F.colors = {'g';purple};
F.ylim=[0.28 0.44];
F.xlim=[1 19];
F.xtick=[5:5:max(F.xlim)];
F.ytick=[0.2:0.05:0.5];
F.xlabel='total # of embedded dimensions';
plot_Lhat(T{j},S{j},F,F.Ncols+j)



%%
j=3; F=G;
F.ylim = [0.255, 0.271];
F.ytick = [0:0.005:0.5]; %[F.ylim(1): 0.01: F.ylim(2)];
F.xlim = [1 150];
F.xtick=[50:50:F.xlim(end)];
F.legendOn=0;
F.colors = {'g';'r'};
F.scale=0.5;
plot_Lhat(T{j},S{j},F,F.Ncols+j)


%%
j=4; F=G;
F.title = '';
F.ylim = [0.2, 0.45];
F.ytick = [0:0.1:0.5]; %[F.ylim(1): 0.01: F.ylim(2)];
F.xlim = [1 15];
F.xtick=[5:5:max(F.xlim)]; %:F.xlim(end)];
F.legendOn=0;
F.colors = {orange;purple;'y'};
F.linestyle={'-';'-';'-';'-';':';':';':';':';'--'};
plot_Lhat(T{j},S{j},F,F.Ncols+j)


%%
hl=subplot(F.Nrows,F.Ncols,F.Nrows*F.Ncols);
hold all, i=1; clear g
g(i)=plot(0,0,'color','g','linewidth',2); i=i+1;
g(i)=plot(0,0,'color','m','linewidth',2); i=i+1;
g(i)=plot(1,1,'color',purple,'linewidth',2); i=i+1;
g(i)=plot(0,0,'color','r','linewidth',2); i=i+1;
g(i)=plot(0,0,'color',orange,'linewidth',2); i=i+1;
g(i)=plot(0,0,'color','y','linewidth',2); i=i+1;

l=legend(g,'LOL','LDA o PCA','QOQ','ROL','QDA o \delta+RP','QDA o RP');
legend(g,'location',[0.82,0.22,0.1,0.1])
legend1 = legend(hl,'show');
set(legend1,'YColor',[1 1 1],'XColor',[1 1 1]);


set(gca,'XTick',[],'YTick',[],'Box','off','xcolor','w','ycolor','w')

%% print figure
if task.savestuff
    H.wh=[6.5 2.5]*1.2;
    H.fname=[fpath(1:findex(end-2)), 'Figs/generalizations'];
    print_fig(h,H)
end
