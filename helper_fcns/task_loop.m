function loop = task_loop(task_in)
% this function implements a parloop for Ntrials iterations and outputs the
% results

loop = cell(1,task_in.Ntrials);
for k=1:task_in.Ntrials
        
    if mod(k,10)==0, display(['trial # ', num2str(k)]); end
    
    % prepare data
    [task, X, Y, P] = get_task(task_in);
    Z = parse_data(X,Y,task.ntrain,task.ntest,task.percent_unlabeled);

    if any(any([strcmp(task.algs,'PDA');strcmp(task.algs,'LOL');strcmp(task.algs,'SLOL');strcmp(task.algs,'rLOL');strcmp(task.algs,'QOL');strcmp(task.algs,'QOQ');strcmp(task.algs,'DRDA')]))
        tic % get delta and eigenvectors
        Phat = estimate_parms(Z.Xtrain,Z.Ytrain);
        loop{k}.svdtime = toc;
    end
    
    % center data
%     Xtrain_centered = bsxfun(@minus,Z.Xtrain,Phat.mu);
%     Xtest_centered = bsxfun(@minus,Z.Xtest,Phat.mu);
    
    % classify
    for i=1:task.Nalgs
        if strcmp(task.algs{i},'LDA')
            tic
            Yhat = LDA_train_and_predict(Z.Xtrain,Z.Ytrain,Z.Xtest);
            loop{k}.time(i,1)=toc;
            loop{k}.out(i,1) = get_task_stats(Yhat,Z.Ytest);              % get accuracy
        elseif strcmp(task.algs{i},'mLDA')
            tic
            Yhat = mLDA_train_and_predict(Z.Xtrain,Z.Ytrain,Z.Xtest);
            loop{k}.time(i,1)=toc;
            loop{k}.out(i,1) = get_task_stats(Yhat,Z.Ytest);              % get accuracy
        elseif strcmp(task.algs{i},'lda')
            tic
            Yhat = classify(Z.Xtest',Z.Xtrain',Z.Ytrain);
            loop{k}.time(i,1)=toc;
            loop{k}.out(i,1) = get_task_stats(Yhat,Z.Ytest);              % get accuracy

        elseif strcmp(task.algs{i},'QDA')
            tic
            D = size(Z.Xtrain,1);
            if D<1000 % skip LDA if the # of dimensions is too large such that pinv takes forever!
                Yhat = QDA_train_and_predict(Z.Xtrain,Z.Ytrain,Z.Xtest);
            else
                Yhat = nan(size(Z.Ytest));
            end
            loop{k}.time(i,1)=toc;
            loop{k}.out(i,1) = get_task_stats(Yhat,Z.Ytest);              % get accuracy

        elseif strcmp(task.algs{i},'qda')
            tic
            Yhat = classify(Z.Xtest',Z.Xtrain',Z.Ytrain,'quadratic');
            loop{k}.time(i,1)=toc;
            loop{k}.out(i,1) = get_task_stats(Yhat,Z.Ytest);              % get accuracy

        elseif strcmp(task.algs{i},'PDA')
            for l=1:task.Nks
                tic
                Yhat = PDA_train_and_predict(Z.Xtrain,Z.Ytrain,Z.Xtest,Phat.V(1:task.ks(l),:));
                loop{k}.time(i,l)=toc+loop{k}.svdtime;
                loop{k}.out(i,l) = get_task_stats(Yhat,Z.Ytest);              % get accuracy
            end
            
        elseif strcmp(task.algs{i},'RF')
            tic
            B = TreeBagger(100,Z.Xtrain',Z.Ytrain');
            [~, scores] = predict(B,Z.Xtest');
            Yhat=scores(:,1)<scores(:,2);
            loop{k}.time(i,1)=toc;
            loop{k}.out(i,1) = get_task_stats(Yhat,Z.Ytest);  
            % get accuracy
            for ii=1:B.NTrees
                loop{k}.NumParents=length(unique(B.Trees{ii}.Parent));
            end
        elseif strcmp(task.algs{i},'LOL')
            for l=1:task.Nks
                tic
                Yhat = LOL_train_and_predict(Z.Xtrain,Z.Ytrain,Z.Xtest,Phat.delta,Phat.V(:,1:task.ks(l))');
                if task.ks(l)==1
                    loop{k}.time(i,l)=toc;
                else
                    loop{k}.time(i,l)=toc+loop{k}.svdtime;
                end
                loop{k}.out(i,l) = get_task_stats(Yhat,Z.Ytest);              % get accuracy
            end
            
        elseif strcmp(task.algs{i},'SLOL')
            for l=1:task.Nks
                tic
                Yhat = LOL_train_and_predict(Z.Xtrain,Z.Ytrain,Z.Xtest,Phat.sdelta,Phat.V(1:task.ks(l),:));
                loop{k}.time(i,l)=toc+loop{k}.svdtime;
                loop{k}.out(i,l) = get_task_stats(Yhat,Z.Ytest);              % get accuracy
            end
            
        elseif strcmp(task.algs{i},'RLOL')
            for l=1:task.Nks
                tic
                Yhat = LOL_train_and_predict(Z.Xtrain,Z.Ytrain,Z.Xtest,Phat.rdelta,Phat.rV(1:task.ks(l),:));
                loop{k}.time(i,l)=toc+loop{k}.svdtime;
                loop{k}.out(i,l) = get_task_stats(Yhat,Z.Ytest);              % get accuracy
            end
            
        elseif strcmp(task.algs{i},'QOL')
            for l=1:task.Nks
                tic
                Yhat = QOL_train_and_predict(Z.Xtrain,Z.Ytrain,Z.Xtest,Phat.delta,task.ks(l));
                loop{k}.time(i,l)=toc;
                loop{k}.out(i,l) = get_task_stats(Yhat,Z.Ytest);              % get accuracy
            end
            
        elseif strcmp(task.algs{i},'QOQ')
            for l=1:task.Nks
                tic
                Yhat = QOQ_train_and_predict(Z.Xtrain,Z.Ytrain,Z.Xtest,Phat.delta,task.ks(l));
                loop{k}.time(i,l)=toc;
                loop{k}.out(i,l) = get_task_stats(Yhat,Z.Ytest);              % get accuracy
            end
            
        elseif strcmp(task.algs{i},'RDA')
            for l=1:task.Nks
                tic
                Yhat = RDA_train_and_predict(Z.Xtrain,Z.Ytrain,Z.Xtest,task.ks(l));
                loop{k}.time(i,l)=toc;
                loop{k}.out(i,l) = get_task_stats(Yhat,Z.Ytest);              % get accuracy
            end
            
        elseif strcmp(task.algs{i},'DRDA')
            for l=1:task.Nks
                tic
                Yhat = DRDA_train_and_predict(Z.Xtrain,Z.Ytrain,Z.Xtest,Phat.delta,task.ks(l));
                loop{k}.time(i,l)=toc;
                loop{k}.out(i,l) = get_task_stats(Yhat,Z.Ytest);              % get accuracy
            end
            
            %         elseif strcmp(task.algs{i},'knn')
            %
            %             d=bsxfun(@minus,Z.Xtrain,Z.Xtest).^2;
            %             [~,IX]=sort(d);
            %
            %             for l=1:tasks1.Nks
            %                 Yhat(i)=sum(Z.Ytrain(IX(1:l,:)))>k/2;
            %                 loop{k}.out(i,l) = get_task_stats(Yhat,Z.Ytest);              % get accuracy
            %             end
            
        elseif strcmp(task.algs{i},'NaiveB')
            tic
            nb = NaiveBayes.fit(Z.Xtrain',Z.Ytrain);
            Yhat = predict(nb,Z.Xtest');
            loop{k}.time(i,1)=toc;
            loop{k}.out(i,1) = get_task_stats(Yhat,Z.Ytest);              % get accuracy
            
        elseif strcmp(task.algs{i},'svm')
            tic
            SVMStruct = svmtrain(Z.Xtrain',Z.Ytrain);
            Yhat = svmclassify(SVMStruct,Z.Xtest');
            loop{k}.time(i,1)=toc;
            loop{k}.out(i,1) = get_task_stats(Yhat,Z.Ytest);              % get accuracy
        end
    end
    
    % chance
    pihat = sum(Z.Ytrain)/task.ntrain;
    Yhatchance=pihat>0.5;
    loop{k}.Lchance=sum(Yhatchance*ones(size(Z.Ytest))~=Z.Ytest)/task.ntest;
    
    % Bayes optimal under QDA model
    if task.QDA_model
        yhats=nan(task.ntest,1);
        lnp1=log(1-pihat);
        lnp0=log(pihat);
        
        a1= -0.5*logdet(P.Sig1)+lnp1;
        a0= -0.5*logdet(P.Sig0)+lnp0;
        
        d1 = bsxfun(@minus,P.mu1,Z.Xtest);
        d0 = bsxfun(@minus,P.mu0,Z.Xtest);
        
        for mm=1:task.ntest
            l1=-0.5*d1(:,mm)'*(P.Sig1\d1(:,mm))-a1;
            l0=-0.5*d0(:,mm)'*(P.Sig0\d0(:,mm))-a0;
            yhats(mm)= l1 > l0;
        end
        loop{k}.Lbayes=sum(yhats~=Z.Ytest)/task.ntest;
    end
end