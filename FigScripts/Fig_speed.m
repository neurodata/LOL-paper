% generalizations figure
clearvars, clc,
fpath = mfilename('fullpath');
findex=strfind(fpath,'/');
p = genpath(fpath(1:findex(end-2)));
addpath(p);

%% task properties consistent across all tasks
clear task
task.algs={'LOL'};
task.simulation=1;
task.percent_unlabeled=0;
task.ntrials=4;
task.ntrain=100;
task.ntest=100;
task.savestuff=1;
task.name='oc';

types={'NEFL';'DENL';'DEFL';'DEAL'};
Ntypes=length(types);

ks=10:10:90;
Nks=length(ks);

Ds=10000; % [100, 200, 500, 1000, 2000, 5000, 10000];
NDs=length(Ds);

%% generate data

timee=nan(Ntypes,task.ntrials);
for j=1:task.ntrials
    for t=1:Ntypes
        for kk=1:Nks
            for d=1:NDs
                task.D=Ds(d);
                task.ks=ks(kk);
                task.types=types(t);
                [Tin,~,~,~] = get_task(task);       % get T details
                [task, X, Y, P] = get_task(Tin);
                Z = parse_data(X,Y,task.ntrain,task.ntest);
                tic
                Yhats = LOL_classify(Z.Xtest',Z.Xtrain',Z.Ytrain,task);
                timee(t,j,kk,d)=toc;
            end
        end
    end
end

figure(1), clf, hold all
plot(squeeze(mean(timee,2))','linewidth',2)
grid on