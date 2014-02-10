clear, clc,
savestuff=1;

% hyper-parameters
ntrain = 50; % training data sample size
ntest = 500;
n=ntrain+ntest;
D = 100; % ambient ndimension

sim_names={'pca';'lda';'sa';'r';'wra'; 's'; 'w'};
algs={'PCA','SDA','SSDA'};

Nsims=length(sim_names);
Nalgs=length(algs);
k_max = 3;  % # dimensions to project into
Ntrials=100;

%% generate and classify loop
parfor k=1:Ntrials
    
    display(['trial # ', num2str(k)])
    % generate data and embed it
    Z = generate_and_embed(ntrain,ntest,D,sim_names,algs, k_max);
    
    % classify
    for j=1:Nsims            
        for i=1:Nalgs
            W = LDA(Z{j}.Xtrain_proj{i},Z{j}.Ytrain);              % estimate LDA discriminating boundary from training data
            predictions{k}(i,j) = LDA_accuracy(Z{j}.Xtest_proj{i},Z{j}.Ytest,W); % make predictions
        end
        W = LDA(Z{j}.Xtrain,Z{j}.Ytrain);
        predictions{k}(i+1,j) = LDA_accuracy(Z{j}.Xtest,Z{j}.Ytest,W);
        
    end
end

%% store accuracies & relative accuracies
Lhats=nan(Nalgs+1,Nsims,Ntrials);
for k=1:Ntrials
    for j=1:Nsims
        for i=1:Nalgs+1;
            Lhats(i,j,k)=predictions{k}(i,j).Lhat;
        end
    end
end

Lhat_rel=nan(Nalgs+1,Nsims,Ntrials);
for k=1:Ntrials
    for j=1:Nsims
        for i=1:Nalgs+1;
            Lhat_rel(i,j,k)=predictions{k}(Nalgs+1,j).Lhat-predictions{k}(i,j).Lhat;
        end
    end
end

%% plot accuracies

whichalgs=[1:Nalgs];
legendcell=[];
for i=whichalgs
    legendcell=[legendcell; algs(i)];
end
legendcell=[legendcell;'LDA'];


figure(1), clf
for j=1:Nsims
    subplot(Nsims,2,2*j-1)
    boxplot(squeeze(Lhats(:,j,:))','plotstyle','traditional','notch','on')
    ylabel(sim_names{j})
    if j==1, title('Lhat Boxplots'), end
end
set(gca,'XTick',[1:5],'XTickLabel',legendcell)


% plot relative accuracies

colors{1}='k'; linestyles{1}='-';
colors{2}='m'; linestyles{2}='-.';
colors{3}='g'; linestyles{3}='--';
colors{4}='b'; linestyles{4}=':';
colors{5}='r'; linestyles{5}='.-';
colors{6}=0.25*[1 1 1];
colors{7}=0.5*[1 1 1];

for j=1:Nsims
    subplot(Nsims,2,2*j), hold all
    for i=1:Nalgs;
        [f{i,j},xi{i,j}] = ksdensity(squeeze(Lhat_rel(i,j,:)));
        plot(xi{i,j},f{i,j}/sum(f{i,j}),'color',colors{i},'linewidth',2,'linestyle',linestyles{i})
    end
    xlim([-0.25 0.25])
    ylabel(sim_names{j})
    if j==1, title('e_{LDA}-e_j'), end
    if j==3, legend(legendcell(1:end-1)), end
end

if savestuff
    wh=[8 6]*1.2;
    fname='Fig_simulation_errors';
    print_fig(gcf,wh,fname)
end

