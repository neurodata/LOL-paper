function loop = dataset_loop(dataset)
% this function implements a parloop for Ntrials iterations and outputs the
% results

for k=1:dataset.Ntrials

    if mod(k,10)==0, display(['trial # ', num2str(k)]); end
    
    [dataset1, X, Y, P] = get_dataset(dataset.name);
    Z = parse_data(X,Y,dataset1.ntrain,dataset1.ntest);

    [Z,~,~,dataset1] = embed_data(Z,dataset1);
    
    % classify
    for i=1:dataset1.Nalgs
        if strcmp(dataset1.algs{i},'LDA')  % if LDA, no need to project, just operate on data in ambient dimension
            W = LDA_train(Z.Xtrain_proj{i}',Z.Ytrain);              % estimate LDA discriminating boundary from training data
            Yhat = LDA_predict(Z.Xtest_proj{i}',W);    % predict
            loop{k}.out(i,1) = get_dataset_stats(Yhat,Z.Ytest);              % get accuracy
        
        elseif strcmp(dataset1.algs{i},'treebagger')
            B = TreeBagger(100,Z.Xtrain',Z.Ytrain');
            [~, scores] = predict(B,Z.Xtest');
            Yhat=scores(:,1)<scores(:,2);
            loop{k}.out(i,1) = get_dataset_stats(Yhat,Z.Ytest);              % get accuracy

        elseif strcmp(dataset1.algs{i},'LOL')  % if LDA, no need to project, just operate on data in ambient dimension
            
            
            for l=1:dataset1.Nks
                W = LDA_train(Z.Xtrain_proj{i}(1:dataset1.ks(l),:)',Z.Ytrain);       % estimate LDA discriminating boundary from training data
                Yhat = LDA_predict(Z.Xtest_proj{i}(1:dataset1.ks(l),:)',W);    % predict
                loop{k}.out(i,l) = get_dataset_stats(Yhat,Z.Ytest);              % get accuracy
            end
            
        else % if LDA, no need to project, just operate on data in ambient dimension
            for l=1:dataset1.Nks
                W = LDA_train(Z.Xtrain_proj{i}(1:dataset1.ks(l),:)',Z.Ytrain);       % estimate LDA discriminating boundary from training data
                Yhat = LDA_predict(Z.Xtest_proj{i}(1:dataset1.ks(l),:)',W);    % predict
                loop{k}.out(i,l) = get_dataset_stats(Yhat,Z.Ytest);              % get accuracy
            end
        end
    end
    
    % chance
    pihat = sum(Z.Ytrain)/dataset1.ntrain;
    Yhatchance=pihat>0.5;
    loop{k}.Lchance=sum(Yhatchance*ones(size(Z.Ytest))~=Z.Ytest)/dataset1.ntest;
    
    % Bayes optimal under QDA model
    if dataset1.QDA_model
        yhats=nan(dataset1.ntest,1);
        lnp1=log(1-pihat);
        lnp0=log(pihat);

        a1= -0.5*logdet(P.Sig1)+lnp1;
        a0= -0.5*logdet(P.Sig0)+lnp0;
        
        d1 = bsxfun(@minus,P.mu1,Z.Xtest);
        d0 = bsxfun(@minus,P.mu0,Z.Xtest);

        for mm=1:dataset1.ntest
            l1=-0.5*d1(:,mm)'*(P.Sig1\d1(:,mm))-a1;
            l0=-0.5*d0(:,mm)'*(P.Sig0\d0(:,mm))-a0;
            yhats(mm)= l1 > l0;
        end
        loop{k}.Lbayes=sum(yhats~=Z.Ytest)/dataset1.ntest;
    end
end