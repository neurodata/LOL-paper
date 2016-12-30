function [Lhat,wt,KS,D,ntrain,ntest] = simple(setting,algs)

%% generate/load data
ntest=1000;
[Xtrain,Ytrain,Xtest,Ytest,D,ntrain,ntest] = load_data(setting,ntest);

%% run classifiers

% settings
ks=unique(round(logspace(0,log10(min(ntrain,D)-2),50)));
Nks=length(ks);

for i=1:length(algs)
    alg=algs{i};
    KS.(alg)=ks;
    try
        tic
        switch alg
            case 'LOL'
                P=LOL(Xtrain',Ytrain);
                V=P{1}.V';
                Lhat.LOL = proj_class(Xtrain,Xtest,Ytrain,Ytest,V,ks);
            case 'RRLDA'
                P=LOL(Xtrain',Ytrain,{'NENL'});
                V=P{1}.V';
                Lhat.RRLDA = proj_class(Xtrain,Xtest,Ytrain,Ytest,V,ks);
            case 'QOQ'
                P=LOL(Xtrain',Ytrain,{'DVNQ'});
                V=P{1}.V';
                Lhat.QOQ = proj_class(Xtrain,Xtest,Ytrain,Ytest,V,ks,'quadratic');
            case 'LRL'
                P=LOL(Xtrain',Ytrain,{'DERL'});
                V=P{1}.V';
                Lhat.LRL = proj_class(Xtrain,Xtest,Ytrain,Ytest,V,ks,'quadratic');
            case 'eigenfaces'
                [~,~,V]=svd(Xtrain);
                Lhat.eigenfaces = proj_class(Xtrain,Xtest,Ytrain,Ytest,V,ks);
                wt.eigenfaces=toc;
            case 'ROAD'
                para.K=Nks;
                Xtr=zscore(Xtrain);
                Xte=zscore(Xtest);
                fit = road(Xtr, Ytrain,0,0,para);
                [~,Yhat] = roadPredict(Xte, fit);
                Lhat.ROAD=misclass(Yhat+1,Ytest);
                KS.(alg)=fit.num';
            case 'lasso'
                [Lhat.lasso, KS.(alg)] = run_lasso(Xtrain,Xtest,Ytrain,Ytest,Nks);
            case 'RF'       % random forest
%                 loop{k}.out(jj,1) = run_RF(Z);
            case 'DR'       % sufficient dimensionality reduciton
%                 [loop{k}.out(jj,1)] = run_DR(Z,task);
            case 'LAD'      % likelihood acquired directions (Cook and Forzani, 2009b)
%                 [loop{k}.out(jj,1)] = run_LAD(Z,task);
            case 'SVM'
%                 loop{k}.out(jj,:) = run_SVM(Z,task.Nks);
        end
        wt.(alg)=toc;
    catch
        display(['had to skip ', alg])
    end
end

% save([setting, '.mat'],'Lhat','ks','D','ntrain','ntrain','algs','setting')
