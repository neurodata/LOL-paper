clear,
clc,

dataset.algs={'PCA','SDA','DRDA','LDA'};      % which algorithms to you
dataset.savestuff=1;                    % flag whether to save data & figures
dataset_list_name='MaiYuan12';
dataset_list = set_dataset_list(dataset_list_name);

%% figure setups
Nsims=length(dataset_list);
Nalgs=length(dataset.algs);

h(1)=figure(1); clf
ncols1=Nalgs+1;
nrows1=Nsims;

h(2)=figure(2); clf
ncols2=Nalgs;
nrows2=Nsims;

h(3)=figure(3); clf
ncols2=Nalgs;
nrows2=Nsims;

d1=1;
d2=2;
d3=3;




for j=1:Nsims
    
    
    % generate data and embed it
    [dataset, X, Y, P] = get_dataset(dataset_list{j});
    Z = parse_data(X,Y,dataset.ntrain,dataset.ntest);
    [Z,Proj,Phat,dataset] = embed_data(Z,dataset);
    
    % plot 1D
    figure(1)
    subplot(nrows1,ncols1,1+ncols1*(j-1)), hold on
    plot(Z.Xtrain(d1,Z.Ytrain==0),Z.Xtrain(d2,Z.Ytrain==0),'r.')
    plot(Z.Xtrain(d1,Z.Ytrain==1),Z.Xtrain(d2,Z.Ytrain==1),'k.')
    axis('equal')
    ylabel(dataset.name)
    set(gca,'XTick',[],'YTick',[])
    
    for i=1:Nalgs
        Z.Xp0=Z.Xtest_proj{i}(1,Z.Ytest==0);
        Z.Xp1=Z.Xtest_proj{i}(1,Z.Ytest==1);
        
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
        if j==1, title(dataset.algs{i}), end
        axis('tight')
        set(gca,'XTick',[],'YTick',[])
        
    end
    
    % plot 2D
    figure(2)
    subplot(nrows2,ncols2,1+(ncols2)*(j-1)), hold on
    plot(Z.Xtrain(d1,Z.Ytrain==0),Z.Xtrain(d2,Z.Ytrain==0),'r.')
    plot(Z.Xtrain(d1,Z.Ytrain==1),Z.Xtrain(d2,Z.Ytrain==1),'k.')
    axis('tight')
    ylabel(dataset.name)
    set(gca,'XTick',[],'YTick',[])
    
    
    for i=1:Nalgs-1
        if ~strcmp(dataset.algs{i},'delta')
            subplot(nrows2,ncols2,i+1+ncols2*(j-1)), hold on
            plot(Z.Xtest_proj{i}(1,Z.Ytest==0),Z.Xtest_proj{i}(2,Z.Ytest==0),'r.')
            plot(Z.Xtest_proj{i}(1,Z.Ytest==1),Z.Xtest_proj{i}(2,Z.Ytest==1),'k.')
            if j==1, title(dataset.algs{i}), end
            axis('tight')
            set(gca,'XTick',[],'YTick',[])
        end
        
    end
    
    %% plot 3D
    
%     figure(3)
%     subplot(nrows2,ncols2,1+ncols2*(j-1)), hold on
%     plot3(Z.Xtrain(d1,Z.Ytrain==0),Z.Xtrain(d2,Z.Ytrain==0),Z.Xtrain(d3,Z.Ytrain==0),'r.')
%     plot3(Z.Xtrain(d1,Z.Ytrain==1),Z.Xtrain(d2,Z.Ytrain==1),Z.Xtrain(d3,Z.Ytrain==1),'k+')
%     axis('equal')
%     ylabel(dataset.name)
%     set(gca,'XTick',[],'YTick',[])
%     
%     for i=1:dataset.Nalgs - 1
%         if ~strcmp(dataset.algs{i},'delta')
%             subplot(nrows2,ncols2,i+1+ncols2*(j-1)), hold on
%             plot3(Z.Xtest_proj{i}(1,Z.Ytest==0),Z.Xtest_proj{i}(2,Z.Ytest==0),Z.Xtest_proj{i}(3,Z.Ytest==0),'r.')
%             plot3(Z.Xtest_proj{i}(1,Z.Ytest==1),Z.Xtest_proj{i}(2,Z.Ytest==1),Z.Xtest_proj{i}(3,Z.Ytest==1),'k+')
%             if j==1, title(dataset.algs{i}), end
%             axis('tight')
%             set(gca,'XTick',[],'YTick',[])
%         end
%         
%     end
    
end


%% save figs
fn='../figs/illustrations_';
if dataset.savestuff
    wh=[6 nrows1]*1.2;
    fname{1}=[fn, '1D'];
    fname{2}=[fn, '2D'];
%     fname{3}=[fn, '3D'];
    
    for i=1:3
        print_fig(h(i),wh,fname{i})
    end
end
