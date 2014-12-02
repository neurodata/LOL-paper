function S = regression_sims(task)

% this function generates the simulation for regression results for Fig 3,
% which will shows LOL vs. Lasso & PLS for regression

fpath = mfilename('fullpath');
findex=strfind(fpath,'/');
p = genpath(fpath(1:findex(end-2)));
addpath(p);
s=rng;

%% set up tasks
if nargin==0
    task.D=1000;
    task.ntrain=100;
    task.ks=unique(round(logspace(0,log10(task.ntrain-10),30)));
    task.name='regress';
    task.ntest=500;
    task.rotate=false;
    task.algs={'LOL'};
    task.types={'DENZ';'NENZ'};
    task.savestuff=1;
    task.ntrials=2;
    task.lasso=false;
end

%% run trials
subnames={'p=2D';'toeplitz'};
Ns=length(subnames);
lol_time=nan(Ns,1); lasso_time=nan(Ns,1); pls_time=nan(Ns,1); chance=nan(Ns,1); err_pls=nan(Ns,1);
for subname=1:Ns
    
    task.subname=subnames{subname};
    
    err_lasso=nan(task.ntrials,length(task.ks));
    for t=1:task.ntrials
        % generate data and embed it
        [task1, X, Y, ~] = get_task(task);
        Z = parse_data(X,Y,task1.ntrain,task1.ntest,0);
        
        % LOL
        tic
        [Yhats] = LOL_classify(Z.Xtest',Z.Xtrain',Z.Ytrain,task);
        lol_time(t)=toc;
        display(['lol ', num2str(lol_time(t))])

        for k=1:length(Yhats)
            for j=1:size(Yhats{1},1)
                err_LOL(t,k,j)=sum((Yhats{k}(j,:)-Z.Ytest).^2);
            end
        end

        % LASSO
        if task.lasso
            tic
            [B,FitInfo] = lasso([ones(task.ntrain,1),Z.Xtrain'],Z.Ytrain,'NumLambda',length(task.ks));
            lasso_time(t)=toc;
            
            J=size(B,2);
            Ylasso=nan(J,task.ntest);
            for j=1:size(B,2)
                Ylasso(j,:) = [ones(task.ntest,1),Z.Xtest']*B(:,j);
                err_lasso(t,j)=sum((Ylasso(j,:)-Z.Ytest).^2);
                nlambda{t}=FitInfo.DF;
            end
            display(['lasso ', num2str(lasso_time(t))])
        end
        
        % PLS
        tic
        [~,~,~,~,BETA] = plsregress(Z.Xtrain',Z.Ytrain',1);
        Ypls = [ones(1,task.ntest);Z.Xtest]'*BETA;
        pls_time(t)=toc;
        display(['pls ', num2str(pls_time(t))])
        
        err_pls(t)=sum((Z.Ytest-Ypls').^2);
        
        chance(t)=sum((Z.Ytest-mean(Z.Ytrain)).^2);
    end
    
    %% get stats
    
    mean_lasso = mean(err_lasso);
    mean_lol = squeeze(mean(err_LOL,1));
    if size(err_LOL,2)==1, mean_lol=mean_lol'; end
    
    
    % store stats for plotting
    if task.lasso
        len=0;
        for i=1:task.ntrials
            len=max(len,length(nlambda{i}));
        end
        nlam=nan(task.ntrials,len);
        for i=1:task.ntrials
            nlam(i,1:length(nlambda{i}))=nlambda{i};
        end
        mean_nlam=mean(nlam);
        
        S{subname}.mean_nlam=mean_nlam;
        S{subname}.mean_lasso=mean_lasso;
        S{subname}.se_lasso = std(err_lasso)/task.ntrials;
        S{subname}.lasso_time=lasso_time;

    end
    
    S{subname}.mean_lol=mean_lol;
    S{subname}.se_lol = squeeze(std(err_LOL))/task.ntrials;    
    S{subname}.lol_time=lol_time;
    
    S{subname}.mean_pls=mean(err_pls);
    S{subname}.pls_time=pls_time;
    
    S{subname}.subname=task.subname;
    S{subname}.chance=mean(chance);
    S{subname}.ks=task.ks;
    S{subname}.savestuff=task.savestuff;
end

%% loop to get other stuff saved
clear Z transformers X Y task1
for subname=1:length(subnames)
    task.subname=subnames{subname};
    [transformers, ~] = parse_algs(task.types);
    S{subname}.transformers=transformers;
end

if task.savestuff, save([fpath(1:findex(end-2)), 'Data/results/extensions'],'S'), end

%%

