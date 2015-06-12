% generalizations figure
% clearvars, clc,
fpath = mfilename('fullpath');
findex=strfind(fpath,'/');
p = genpath(fpath(1:findex(end-2)));
addpath(p);
fname='speed_test';

%% task properties consistent across all tasks
clear task
task0.algs={'LOL'};
task0.simulation=1;
task0.percent_unlabeled=0;
task0.ntrials=10;
task0.ntrain=100;
task0.ntest=100;
task0.n=task0.ntrain+task0.ntest;
task0.name='oc';

savestuff=1;

types={ 'NENL';... PCA
        'DENL';... LOL
        'DVFQ';... QOQ
%         'DERL';... RoLOL
        'DEAL';... RaLOL
        'DEFL';... fLOL
        };

Ntypes=length(types);

ks=10:20:90;
Nks=length(ks);

Ds=[1000, 2000, 5000]; % [100, 200, 500, 1000, 2000, 5000, 10000];
NDs=length(Ds);

%% generate data

%%%%%%%%% DO NOT PARFOR THIS!!! %%%%%%%%%%%%%
learn_time=nan(Ntypes,task0.ntrials,Nks,NDs);
classify_time=nan(Ntypes,task0.ntrials,Nks,NDs);
for j=1:task0.ntrials
    for t=1:Ntypes
        for kk=1:Nks
            for d=1:NDs
                task_in=task0;
                task_in.D=Ds(d);
                task_in.ks=ks(kk);
                task_in.types=types(t);
                
                fprintf('D=%d, k=%d, type=%s, trial=%d\n',task_in.D, task_in.ks,types{t},j)
                
                [Tin,~,~,~] = get_task(task_in);       % get T details
                [task, X, Y, P] = get_task(Tin);
                Z = parse_data(X,Y,task.ntrain,task.ntest);
                
                [transformers, deciders] = parse_algs(task.types);
                tic
                [Proj, Phat] = LOL(Z.Xtrain',Z.Ytrain,transformers,max(task.ks));
                learn_time(t,j,kk,d)=toc;
                
                tic
                Xtest=Proj{1}.V*Z.Xtest;
                Xtrain=Proj{1}.V*Z.Xtrain;
                Yhat = decide(Xtest,Xtrain,Z.Ytrain,deciders{1}{1},task.ks);
                classify_time(t,j,kk,d)=toc;
                
            end
        end
    end
    
    % get stats
    mean_learn=squeeze(nanmean(learn_time,2));
    mean_class=squeeze(nanmean(classify_time,2));
    mean_total=mean_learn+mean_class;
    
    std_learn=squeeze(nanstd(learn_time,[],2));
    std_class=squeeze(nanstd(classify_time,[],2));
    std_total=std_learn+std_class;
    
    % save speed
    if savestuff
        save([fpath(1:findex(end-2)), 'Data/Results/', fname])
    end
    % load([fpath(1:findex(end-2)), 'Data/Results/', fname])
    
end



