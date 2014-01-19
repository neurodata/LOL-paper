clear, clc,
savestuff = 0;

% hyper-parameters
ntrain = 50;
ntest = 500;
D = 100; % ambient ndimension
% sim_names={'pca';'lda';'sa';'r';'wra'; 's'; 'w'};
% sim_names={'pca'};%'lda';'sa';'r';'wra'; 's'; 'w'};
sim_names={'trunk';'toeplitz';'decaying'};

algs={'PCA','SDA','SSDA'};
k_max = D;  % # dimensions to project into

% generate data and embed it
tasks.ntrain=ntrain;
tasks.ntest=ntest;
tasks.D=D;
tasks.algs=algs;
tasks.ks=k_max;
Z = generate_and_embed(sim_names,job);



%% plot 2D
Nsims=length(sim_names);
Nalgs=length(algs);


h(3)=figure(3); clf

for j=1:Nsims
    h(j)=figure(j); clf
    
    for i=1:10;
        d(i)=find(Z{j}.P.pi==i);
    end
    
    nrows=Nalgs+1;
    dpairs=[d(1),d(2); d(1),d(3); d(2),d(3); d(3),d(4); d(4),d(5)];
    pairs=[1,2; 1,3; 2,3; 3,4; 4,5];
    Npairs=length(pairs);
    ncols=Npairs;
    
    for k=1:Npairs
        subplot(nrows,ncols,k), hold all
        plot(Z{j}.Xtest(Z{j}.Y0test,dpairs(k,1)),Z{j}.Xtest(Z{j}.Y0test,dpairs(k,2)),'r.')
        plot(Z{j}.Xtest(Z{j}.Y1test,dpairs(k,1)),Z{j}.Xtest(Z{j}.Y1test,dpairs(k,2)),'k.')
        axis([-1 1 -1 1])
        if k==1, ylabel('Ambient'), end
        set(gca,'XTick',[],'YTick',[])
        
        for i=1:Nalgs
            subplot(nrows,ncols,k+(Npairs)*(i)), hold all
            x01=Z{j}.Xtest_proj{i}(Z{j}.Y0test,pairs(k,1));
            x02=Z{j}.Xtest_proj{i}(Z{j}.Y0test,pairs(k,2));
            plot(x01,x02,'r.')
            
            x11=Z{j}.Xtest_proj{i}(Z{j}.Y1test,pairs(k,1));
            x12=Z{j}.Xtest_proj{i}(Z{j}.Y1test,pairs(k,2));
            plot(x11,x12,'k.')
            axis([min([x01;x11]) max([x01;x11]) min([x02;x12]) max([x02;x12])])
            if i==Nalgs-1
                xlabel(pairs(k,1))
                ylabel(pairs(k,2))
            end
            if k==1, ylabel(algs{i}), end
            set(gca,'XTick',[],'YTick',[])
        end
    end
    
end

% save figs
if savestuff
    wh=[4 4]*1.5;
    for i=1:Nsims
        print_fig(h(i),wh,['pairsplotss_', sim_names{i}])
    end
end