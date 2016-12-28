function [Lhat,ks,D,ntrain,ntest] = simple(setting,algs)

%% generate/load data
ntest=1000;
switch setting
    case {'rtrunk','toeplitz','3trunk4'}
        D=100; ntrain=100; 
        [Xtrain,Ytrain,Xtest,Ytest] = load_gmm(setting,D,ntrain,ntest);
    case 'fat_tails'
        D=1000; ntrain=100; 
        [Xtrain,Ytrain,Xtest,Ytest] = fat_tails(D,ntrain,ntest);
    case 'xor2'
        D=100; ntrain=100; 
        [Xtrain,Ytrain,Xtest,Ytest] = xor2(D,ntrain,ntest);
    case 'outliers'
        D=100; ntrain=100; 
        [Xtrain,Ytrain,Xtest,Ytest] = outliers(D,ntrain,ntest);
    case {'prostate','colon','MNIST','CIFAR-10'}
        [Xtrain,Ytrain,Xtest,Ytest,D,ntrain,ntest]=load_data2(setting);
end

%% run classifiers

% settings
ks=unique(round(logspace(0,log10(min(ntrain,D)-2),50)));
Nks=length(ks);


for i=1:length(algs)
    alg=algs{i};
    try
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
        case 'ROAD'
            para.K=Nks;
            Xtr=zscore(Xtrain);
            Xte=zscore(Xtest);
            fit = road(Xtr, Ytrain,0,0,para);
            [~,Yhat] = roadPredict(Xte, fit);
            Lhat.ROAD=misclass(Yhat+1,Ytest);
        case 'lasso'
            opts=struct('nlambda',Nks);
%             if max(Z.Ytrain)==9
%                 Z.Ytest=Z.Ytest+1;
%                 Z.Ytrain=Z.Ytrain+1;
%             end
            fit=glmnet(Xtrain',Ytrain,'multinomial',opts);
            pfit=glmnetPredict(fit,Xtest,fit.lambda,'response','false',fit.offset);
            [~,yhat]=max(pfit,[],2);
            Yhat_GLM=squeeze(yhat)';
            Lhat.lasso=misclass(Yhat+1,Ytest);            
    end
    catch
        display(['had to skip ', alg])
    end
end

% save([setting, '.mat'],'Lhat','ks','D','ntrain','ntrain','algs','setting')
