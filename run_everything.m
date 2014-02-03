function [tasks,P,Phat,Proj,S] = run_everything(tasks)
% this function
% 1) which simulations/real data examples to run
% 2) runs a variety of classifiers on such tasks for a variety of embedding
% dimensions
% 3) computes some summary statistics
% 4) saves the results

%% set some additional tasks parameters

fname=['Fig_choosek_', tasks.tasks];   % prefix of name of files to save


%% generate and classify loop
for k=1:tasks.Ntrials
    display(['trial # ', num2str(k)])
    
    for j=1:tasks.Ntasks
        display(['simulation ', tasks.tasks{j}])
        
        Z = get_data(tasks.tasks{j});
        Z = embed_data(Z,max(tasks.ks),tasks.algs);
        
        % classify
        for ii=1:tasks.Nalgs
            if ~strcmp(tasks.algs{ii},'LDA')
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
        if tasks.QDA_model
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

Z = generate_and_embed(tasks);

for j=1:tasks.Ntasks
    
    [tasks.n(j), tasks.D(j)]=size(Z.Xtrain);
    tasks.ntrain(j)=Z.ntrain;
    tasks.ks1{j}=Z.ks;
    tasks.Nks1(j)=length(Z.ks);
    
    if tasks.simulation
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

Lhats=nan(tasks.Nalgs,tasks.Ntasks,tasks.Nks,tasks.Ntrials);
sensitivity=nan(tasks.Nalgs,tasks.Ntasks,tasks.Nks,tasks.Ntrials);
specificity=nan(tasks.Nalgs,tasks.Ntasks,tasks.Nks,tasks.Ntrials);

for k=1:tasks.Ntrials
    for i=1:tasks.Nalgs;
        for j=1:tasks.Ntasks
            if ~strcmp(tasks.algs{i},'LDA')
                for l=1:tasks.Nks1(j)
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
for i=1:tasks.Nalgs;
    for j=1:tasks.Ntasks
        [~,S.mins.k(i,j)]=min(S.means.Lhats(i,j,:));
        S.mins.Lhats(i,j)=S.means.Lhats(i,j,S.mins.k(i,j));
        S.mins.sensitivity(i,j)=S.means.sensitivity(i,j,S.mins.k(i,j));
        S.mins.specificity(i,j)=S.means.specificity(i,j,S.mins.k(i,j));
    end
end

% also get chance & bayes stats
S.Lchance=nan(tasks.Ntrials,tasks.Ntasks);
S.Lbayes=nan(tasks.Ntrials,tasks.Ntasks);
for k=1:tasks.Ntrials
    S.Lchance(k,:)=loop{k}.Lchance;
    S.Lbayes(k,:)=loop{k}.Lbayes;
end



%% save results


if tasks.savestuff
    save(['../data/results/', fname],'tasks','P','Phat','Proj','S')
end