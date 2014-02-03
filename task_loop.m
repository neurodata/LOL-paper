function loop = task_loop(task)
% this function implements a parloop for Ntrials iterations and outputs the
% results

for k=1:task.Ntrials
    
    if mod(k,10)==0, display(['trial # ', num2str(k)]); end
    
    [task1, X, Y, P] = get_task(task.name);
    
    Z = parse_data(X,Y,task1.ntrain,task1.ntest);
    task1 = update_k(task1);
    
    %     [Proj, Phat] = estimate_projections(Z.Xtrain,Z.Ytrain,task.Kmax,task.algs);
    %    [Z,Proj,Phat] = embed_data(Z,task1);
    
    % tic
    
    Phat = estimate_parameters(Z.Xtrain,Z.Ytrain,task1.Kmax);
    
    Xtrain_centered = bsxfun(@minus,Z.Xtrain,Phat.mu);
    Xtest_centered = bsxfun(@minus,Z.Xtest,Phat.mu);
    
    % classify
    for i=1:task1.Nalgs
        if strcmp(task1.algs{i},'LDA')  % if LDA, no need to project, just operate on data in ambient dimension
            W = LDA_train(Xtrain_centered',Z.Ytrain);              % estimate LDA discriminating boundary from training data
            Yhat = LDA_predict(Xtest_centered',W);    % predict
            loop{k}.out(i,1) = get_task_stats(Yhat,Z.Ytest);              % get accuracy
            
        elseif strcmp(task1.algs{i},'treebagger')
            B = TreeBagger(100,Z.Xtrain',Z.Ytrain');
            [~, scores] = predict(B,Z.Xtest');
            Yhat=scores(:,1)<scores(:,2);
            loop{k}.out(i,1) = get_task_stats(Yhat,Z.Ytest);              % get accuracy
            
        elseif strcmp(task1.algs{i},'LOL')  % if LDA, no need to project, just operate on data in ambient dimension
            
            for l=1:task1.Nks
                [Proj, W] = LOL_train(Xtrain_centered, Z.Ytrain,Phat.delta,Phat.V(1:task1.ks(l),:));
                Yhat = LOL_predict(Xtest_centered,Proj,W);
                loop{k}.out(i,l) = get_task_stats(Yhat,Z.Ytest);              % get accuracy
            end
                        

        elseif strcmp(task1.algs{i},'RDA')  % if LDA, no need to project, just operate on data in ambient dimension
            
            [V_RDA, ~] = qr(randn(task1.D,task1.Kmax),0);
            Proj=V_RDA';

            training_features = Proj*Xtrain_centered;
            test_features = Proj*Xtest_centered;
            
            for l=1:task1.Nks
                W = LDA_train(training_features(1:task1.ks(l),:)',Z.Ytrain);       % estimate LDA discriminating boundary from training data
                Yhat = LDA_predict(test_features(1:task1.ks(l),:)',W);    % predict
                loop{k}.out(i,l) = get_task_stats(Yhat,Z.Ytest);              % get accuracy
            end
            
            
            
        else % if LDA, no need to project, just operate on data in ambient dimension
            for l=1:task1.Nks
                W = LDA_train(Z.Xtrain_proj{i}(1:task1.ks(l),:)',Z.Ytrain);       % estimate LDA discriminating boundary from training data
                Yhat = LDA_predict(Z.Xtest_proj{i}(1:task1.ks(l),:)',W);    % predict
                loop{k}.out(i,l) = get_task_stats(Yhat,Z.Ytest);              % get accuracy
            end
        end
    end
    
    % chance
    pihat = sum(Z.Ytrain)/task1.ntrain;
    Yhatchance=pihat>0.5;
    loop{k}.Lchance=sum(Yhatchance*ones(size(Z.Ytest))~=Z.Ytest)/task1.ntest;
    
    % Bayes optimal under QDA model
    if task1.QDA_model
        yhats=nan(task1.ntest,1);
        lnp1=log(1-pihat);
        lnp0=log(pihat);
        
        a1= -0.5*logdet(P.Sig1)+lnp1;
        a0= -0.5*logdet(P.Sig0)+lnp0;
        
        d1 = bsxfun(@minus,P.mu1,Z.Xtest);
        d0 = bsxfun(@minus,P.mu0,Z.Xtest);
        
        for mm=1:task1.ntest
            l1=-0.5*d1(:,mm)'*(P.Sig1\d1(:,mm))-a1;
            l0=-0.5*d0(:,mm)'*(P.Sig0\d0(:,mm))-a0;
            yhats(mm)= l1 > l0;
        end
        loop{k}.Lbayes=sum(yhats~=Z.Ytest)/task1.ntest;
    end
end