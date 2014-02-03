function [datasets,P,Phat,Proj,S] = run_everything(datasets)
% this function
% 1) which simulations/real data examples to run
% 2) runs a variety of classifiers on such datasets for a variety of embedding
% dimensions
% 3) computes some summary statistics
% 4) saves the results

%% set some additional datasets parameters

fname=['Fig_choosek_', datasets.datasets];   % prefix of name of files to save


%% generate and classify loop
for k=1:datasets.Ntrials
    display(['trial # ', num2str(k)])
    
    for j=1:datasets.Ndatasets
        display(['simulation ', datasets.datasets{j}])
        
        Z = get_data(datasets.datasets{j});
        Z = embed_data(Z,max(datasets.ks),datasets.algs);
        
        % classify
        for ii=1:datasets.Nalgs
            if ~strcmp(datasets.algs{ii},'LDA')
                for l=1:length(ks)
                    W = LDA(Z.Xtrain_proj{ii}(:,1:ks(l)),Z.Ytrain);              % estimate LDA discriminating boundary from training data
                    loop{k}.out(ii,j,l) = LDA_accuracy(Z.Xtest_proj{ii}(:,1:ks(l)),Z.Ytest,W); % make predictions
                end
            else % if LDA, no need to project, just operate on data in ambient dimension
                W = LDA(Z.Xtrain_proj{ii},Z.Ytrain);              % estimate LDA discriminating boundary from training data
                loop{k}.out(ii,j,1) = LDA_accuracy(Z.Xtest_proj{ii},Z.Ytest,W); % make predictions
            end
        end
        
        % chance
        pihat = sum(Z.Ytrain)/length(Z.Ytrain);
        Yhatchance=pihat>0.5;
        loop{k}.Lchance(j)=sum(Yhatchance*ones(size(Z.Ytest))~=Z.Ytest)/Z.ntest;
        
        % Bayes optimal under QDA model
        if datasets.QDA_model
            yhats=nan(Z.ntest,1);
            for mm=1:Z.ntest
                l1=(Z.Xtest(mm,:)'-Z.P.mu1)'*(Z.P.Sig1\(Z.Xtest(mm,:)'-Z.P.mu1));
                l0=(Z.Xtest(mm,:)'-Z.P.mu2)'*(Z.P.Sig2\(Z.Xtest(mm,:)'-Z.P.mu2));
                yhats(mm)= l1 > l0;
            end
            loop{k}.Lbayes(j)=sum(yhats~=Z.Ytest)/Z.ntest;
        end
    end
end

%% store and generate parameters from a single simulation fo plotting the spectrum and getting performance bounds

Z = generate_and_embed(datasets);

for j=1:datasets.Ndatasets
    
    [datasets.n(j), datasets.D(j)]=size(Z.Xtrain);
    datasets.ntrain(j)=Z.ntrain;
    datasets.ks1{j}=Z.ks;
    datasets.Nks1(j)=length(Z.ks);
    
    if datasets.simulation
        P{j}=Z.P;
        if isfield(P{j},'Risk')
            S.Risk(j)=P{j}.Risk;
        else
            S.Risk(j)=nan;
        end
    else
        P=[]; % because i am saving P, so i need something there
    end
    Phat{j}=Z.Phat;
    Proj{j}=Z.Proj;
    
end

%% re-organize data and store stats

Lhats=nan(datasets.Nalgs,datasets.Ndatasets,datasets.Nks,datasets.Ntrials);
sensitivity=nan(datasets.Nalgs,datasets.Ndatasets,datasets.Nks,datasets.Ntrials);
specificity=nan(datasets.Nalgs,datasets.Ndatasets,datasets.Nks,datasets.Ntrials);

for k=1:datasets.Ntrials
    for i=1:datasets.Nalgs;
        for j=1:datasets.Ndatasets
            if ~strcmp(datasets.algs{i},'LDA')
                for l=1:datasets.Nks1(j)
                    Lhats(i,j,l,k)=loop{k}.out(i,j,l).Lhat;
                    sensitivity(i,j,l,k)=loop{k}.out(i,j,l).sensitivity;
                    specificity(i,j,l,k)=loop{k}.out(i,j,l).specificity;
                end
            else
                l=1;
                Lhats(i,j,l,k)=loop{k}.out(i,j,l).Lhat;
                sensitivity(i,j,l,k)=loop{k}.out(i,j,l).sensitivity;
                specificity(i,j,l,k)=loop{k}.out(i,j,l).specificity;
            end
        end
    end
end

S.means.Lhats=squeeze(nanmean(Lhats,4));
S.means.sensitivity=squeeze(nanmean(sensitivity,4));
S.means.specificity=squeeze(nanmean(specificity,4));

S.stds.Lhats=squeeze(nanstd(Lhats,[],4));
S.stds.sensitivity=squeeze(nanstd(sensitivity,[],4));
S.stds.specificity=squeeze(nanstd(specificity,[],4));

% get mins
for i=1:datasets.Nalgs;
    for j=1:datasets.Ndatasets
        [~,S.mins.k(i,j)]=min(S.means.Lhats(i,j,:));
        S.mins.Lhats(i,j)=S.means.Lhats(i,j,S.mins.k(i,j));
        S.mins.sensitivity(i,j)=S.means.sensitivity(i,j,S.mins.k(i,j));
        S.mins.specificity(i,j)=S.means.specificity(i,j,S.mins.k(i,j));
    end
end

% also get chance & bayes stats
S.Lchance=nan(datasets.Ntrials,datasets.Ndatasets);
S.Lbayes=nan(datasets.Ntrials,datasets.Ndatasets);
for k=1:datasets.Ntrials
    S.Lchance(k,:)=loop{k}.Lchance;
    S.Lbayes(k,:)=loop{k}.Lbayes;
end



%% save results


if datasets.savestuff
    save(['../data/results/', fname],'datasets','P','Phat','Proj','S')
end