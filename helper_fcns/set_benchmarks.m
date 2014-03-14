% profile on
clearvars, clc, updatepath

task_list_name='sa';
switch task_list_name
    case 'Mai13'
        task.ks=unique(round(logspace(0,2,50)));
        task.Ntrials=100;
        task.algs={'naivebayes','PDA','SLOL','LOL','DRDA','RDA','treebagger','svm'};
        task.savestuff=1;
    case 'thin'
        task.ks=unique(round(logspace(0,2,50)));
        task.Ntrials=10;
        task.algs={'naivebayes','LDA','PDA','SLOL','LOL','DRDA','RDA','treebagger','svm'};
        task.savestuff=1;
    case 'sa'
        task.ks=unique(round(logspace(0,2,50)));
        task.Ntrials=10;
        task.algs={'naivebayes','LDA','LOL'};
        task.savestuff=1;
end

[T,P,S] = run_benchmarks(task_list_name,task);
Figure_benchmarks(task_list_name)

% profile viewer