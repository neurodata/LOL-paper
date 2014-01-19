clear, 
clc,

task_name='w2';
task.ks=1:5;                         % maximum # of different dimensions to embed into
task.algs={'PCA','SDA','DRDA','LDA'};      % which algorithms to you
task.savestuff=1;                    % flag whether to save data & figures
task.name={task_name};
task.simulation=1;

% generate data and embed it
[task, X, Y, P] = get_task(task_name);
Z = parse_data(X,Y,task.ntrain,task.ntest);
[Z,Proj,Phat,task] = embed_data(Z,task);


%% figure setups
Nsims=1; %length(task.name);
Nalgs=length(task.algs);

h(1)=figure(1); clf
ncols1=Nalgs+1;
nrows1=Nsims;

h(2)=figure(2); clf
ncols2=Nalgs;
nrows2=Nsims;

h(3)=figure(3); clf
ncols2=Nalgs;
nrows2=Nsims;


for j=1:Nsims
    % plot 1D
    
    figure(1)
    
    d1=1; %find(P.pi==1);
    d2=2; %find(P.pi==2);
    d3=3 ;%find(P.pi==3);
    
    subplot(nrows1,ncols1,1+ncols1*(j-1)), hold on
    plot(Z.Xtrain(Z.Y0train,d1),Z.Xtrain(Z.Y0train,d2),'r.')
    plot(Z.Xtrain(Z.Y1train,d1),Z.Xtrain(Z.Y1train,d2),'k.')
    axis('equal')
    ylabel(task.name)
    set(gca,'XTick',[],'YTick',[])
    
    for i=1:Nalgs
        Z.Xp0=Z.Xtest_proj{i}(Z.Y0test,1);
        Z.Xp1=Z.Xtest_proj{i}(Z.Y1test,1);
        
        if mean(Z.Xp0)>mean(Z.Xp1);
            colors={'k','r'};
        else
            colors={'r','k'};
        end
        
        [N1,Z.X1]=hist(Z.Xp0,50);
        [N2,Z.X2]=hist(Z.Xp1,50);
        
        subplot(nrows1,ncols1,i+1+ncols1*(j-1)), hold on
        plot(Z.X1,N1,'-','color',colors{1})
        plot(Z.X2,N2,'-','color',colors{2})
        if j==1, title(task.algs{i}), end
        axis('tight')
        set(gca,'XTick',[],'YTick',[])
        
    end
    
    % plot 2D
    figure(2)
    subplot(nrows2,ncols2,1+(ncols2)*(j-1)), hold on
    plot(Z.Xtrain(Z.Y0train,d1),Z.Xtrain(Z.Y0train,d2),'r.')
    plot(Z.Xtrain(Z.Y1train,d1),Z.Xtrain(Z.Y1train,d2),'k.')
    axis('equal')
    ylabel(task.name)
    set(gca,'XTick',[],'YTick',[])
    
    
    k=0;
    for i=1:Nalgs-1
        if ~strcmp(task.algs{i},'delta')
            k=k+1;
            subplot(nrows2,ncols2,i+1+ncols2*(j-1)), hold on
            plot(Z.Xtest_proj{i}(Z.Y0test,1),Z.Xtest_proj{i}(Z.Y0test,2),'r.')
            plot(Z.Xtest_proj{i}(Z.Y1test,1),Z.Xtest_proj{i}(Z.Y1test,2),'k.')
            if j==1, title(task.algs{i}), end
            axis('tight')
            set(gca,'XTick',[],'YTick',[])
        end
        
    end
    
        %% plot 3D
    
        figure(3)
        subplot(nrows2,ncols2,1+ncols2*(j-1)), hold on
        plot3(Z.Xtrain(Z.Y0train,d1),Z.Xtrain(Z.Y0train,d2),Z.Xtrain(Z.Y0train,d3),'r.')
        plot3(Z.Xtrain(Z.Y1train,d1),Z.Xtrain(Z.Y1train,d2),Z.Xtrain(Z.Y1train,d3),'k+')
        axis('equal')
        ylabel(task.name)
        set(gca,'XTick',[],'YTick',[])
    
        k=0;
        for i=1:task.Nalgs - 1 
            if ~strcmp(task.algs{i},'delta')
                k=k+1;
                subplot(nrows2,ncols2,i+1+ncols2*(j-1)), hold on
                plot3(Z.Xtest_proj{i}(Z.Y0test,1),Z.Xtest_proj{i}(Z.Y0test,2),Z.Xtest_proj{i}(Z.Y0test,3),'r.')
                plot3(Z.Xtest_proj{i}(Z.Y1test,1),Z.Xtest_proj{i}(Z.Y1test,2),Z.Xtest_proj{i}(Z.Y1test,3),'k+')
                if j==1, title(task.algs{i}), end
                axis('tight')
                set(gca,'XTick',[],'YTick',[])
            end
    
        end
    
end

%% save figs
fn='illustrations_';
if task.savestuff
    wh=[6 4]*1.2;
    fname{1}=[fn, '1D'];
    fname{2}=[fn, '2D'];
    fname{3}=[fn, '3D'];
    
    for i=1:3
        print_fig(h(i),wh,fname{i})
    end
end