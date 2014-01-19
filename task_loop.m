function loop = task_loop(task)
% this function implements a parloop for Ntrials iterations and outputs the
% results

parfor k=1:task.Ntrials
    display(['trial # ', num2str(k)])
    
    [task1, X, Y, P] = get_task(task.name);
    Z = parse_data(X,Y,task1.ntrain,task1.ntest);
    [Z,~,~,task1] = embed_data(Z,task1);
    
    % classify
    for i=1:task1.Nalgs
        if ~strcmp(task1.algs{i},'LDA')
            for l=1:task1.Nks
                W = LDA(Z.Xtrain_proj{i}(:,1:task1.ks(l)),Z.Ytrain);              % estimate LDA discriminating boundary from training data
                loop{k}.out(i,l) = LDA_accuracy(Z.Xtest_proj{i}(:,1:task1.ks(l)),Z.Ytest,W); % make predictions
            end
        else % if LDA, no need to project, just operate on data in ambient dimension
            W = LDA(Z.Xtrain_proj{i},Z.Ytrain);              % estimate LDA discriminating boundary from training data
            loop{k}.out(i,1) = LDA_accuracy(Z.Xtest_proj{i},Z.Ytest,W); % make predictions
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
        
        d1 = bsxfun(@minus,P.mu1,Z.Xtest');
        d0 = bsxfun(@minus,P.mu0,Z.Xtest');

        for mm=1:task1.ntest
            l1=-0.5*d1(:,mm)'*(P.Sig1\d1(:,mm))-a1;
            l0=-0.5*d0(:,mm)'*(P.Sig0\d0(:,mm))-a0;
            yhats(mm)= l1 < l0;
        end
        loop{k}.Lbayes=sum(yhats~=Z.Ytest)/task1.ntest;
    end
end