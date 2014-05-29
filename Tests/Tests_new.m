%% new tests
clearvars, clf, clc
profile on

task.name='mnist';
task.types={'DENE';'DEFE'};
task.algs={'LOL'};
task.ntrials=1;
task.simulation=false;

[task, X, Y, parms] = get_task(task);
Z = parse_data(X,Y,task.ntrain,task.ntest,task.percent_unlabeled);

% classify
[Yhats, Proj, P, times] = LOL_classify(Z.Xtest',Z.Xtrain',Z.Ytrain,task);

loop{1}.out=get_task_stats(Yhats,Z.Ytest);

S = get_loop_stats(task,loop);      % get stats
profile viewer

%%
clearvars,clc
D=10;
n=100;
data=rand(D,n);
group_size=20;
mode=2;
[robust_geom_mean,geometric_median_cov,elementwise_median_cov,sample_cv]=robust_geomcov(data,group_size,mode);
