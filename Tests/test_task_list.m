function [task_list,task] = test_task_list(metatask)

if strcmp(metatask,'test_lda')
    task_list={'wra, D=5', 'wra, D=20'};
    task.algs={'LDA','lda','LOL'};
    task.ntrain=100;
    task.ntest=500;
    task.Ntrials=100;
    task.ks=unique(floor(logspace(0,log10(task.ntrain),30)));
elseif strcmp(metatask,'test_LOL')
    task_list={'toeplitz, D=10','wra, D=100','toeplitz, D=100'};
    task.algs={'LOL','LOL DEN'};
    task.ntrain=50;
    task.ntest=500;
    task.Ntrials=20;
    task.ks=unique(floor(logspace(0,log10(task.ntrain-5),30)));
elseif strcmp(metatask,'test_LOL3')
    task_list={'wra, D=10','toeplitz, D=100'};
    task.algs={'LOL','LOL'};
    task.types={'DENL'};
    task.ntrain=50;
    task.ntest=500;
    task.Ntrials=20;
    task.ks=unique(floor(logspace(0,log10(task.ntrain-5),30)));
elseif strcmp(metatask,'test_LOL4')
    task_list={'wra, D=10','toeplitz, D=100'};
    task.algs={'QOL','LOL'};
    task.types={'DENQ'};
    task.ntrain=50;
    task.ntest=500;
    task.Ntrials=20;
    task.ks=unique(floor(logspace(0,log10(task.ntrain/2),30)));
elseif strcmp(metatask,'test_LOL5')
    task_list={'wra, D=10','toeplitz, D=100'};
    task.algs={'LOL','QOL','LOL'};
    task.types={'DENL','DENQ'};
    task.ntrain=50;
    task.ntest=500;
    task.Ntrials=20;
    task.ks=unique(floor(logspace(0,log10(task.ntrain-5),30)));
elseif strcmp(metatask,'test_lda2')
    task_list={'s','wra, D=5', 'wra, D=20'};
    task.algs={'LDA','LOL'};
    task.ntrain=50;
    task.ntest=500;
    task.Ntrials=20;
    task.ks=unique(floor(logspace(0,log10(task.ntrain),30)));
elseif strcmp(metatask,'test_lda3')
    task_list={'wra, D=5','toeplitz, D=5'};
    task.algs={'LDA','lda'};
    task.ntrain=5000;
    task.ntest=500;
    task.Ntrials=2;
    task.ks=1;
elseif strcmp(metatask,'test_lda4')
    task_list={'wra, D=100'};
    task.algs={'LDA','LOL'};
    task.ntrain=50;
    task.ntest=500;
    task.Ntrials=2;
    task.ks=unique(floor(logspace(0,log10(task.ntrain),30)));
elseif strcmp(metatask,'test_LDA')
    task_list={'wra, D=5', 'wra, D=10'};
    task.algs={'LDA','lda'};
    task.ntrain=50;
    task.ntest=500;
    task.Ntrials=25;
elseif strcmp(metatask,'test_LDA2')
    task_list={'s','toeplitz, D=500'};
    task.algs={'LDA','LDA'};
    task.ntrain=50;
    task.ntest=500;
    task.Ntrials=10;
elseif strcmp(metatask,'test_LDA3')
    task_list={'s'};
    task.algs={'LDA','LDA'};
    task.ntrain=5000;
    task.ntest=500;
    task.Ntrials=10;
elseif strcmp(metatask,'test_LDA4')
    task_list={'gmm'};
    task.algs={'LDA','lda'};
    task.Ngroups=5;
    task.ntrain=task.Ngroups*25;
    task.ntest=500;
    task.n=task.ntrain+task.ntest;
    task.Ntrials=25;
    task.D=100;
    task.QDA_model=0;
elseif strcmp(metatask,'test_LDA5')
    task_list={'gmm'};
    task.algs={'LDA'};
    task.Ngroups=5;
    task.ntrain=task.Ngroups*25;
    task.ntest=500;
    task.n=task.ntrain+task.ntest;
    task.Ntrials=25;
    task.D=200;
    task.QDA_model=0;
elseif strcmp(metatask,'test_LDA6')
    task_list={'gmm'};
    task.algs={'LDA','LOL'};
    task.Ngroups=2;
    task.ntrain=task.Ngroups*25;
    task.ntest=500;
    task.n=task.ntrain+task.ntest;
    task.Ntrials=25;
    task.D=100;
    task.QDA_model=0;
    task.ks=unique(floor(logspace(0,log10(task.ntrain),30)));
elseif strcmp(metatask,'test_LDA7')
    task_list={'gmm'};
    task.algs={'LDA','LOL'};
    task.Ngroups=2;
    task.ntrain=task.Ngroups*25;
    task.ntest=500;
    task.n=task.ntrain+task.ntest;
    task.Ntrials=25;
    task.D=100;
    task.QDA_model=0;
    task.ks=unique(floor(logspace(0,log10(task.ntrain),30)));
elseif strcmp(metatask,'test_LDA8')
    task_list={'gmm'};
    task.algs={'LDA','LOL'};
    task.Ngroups=5;
    task.ntrain=task.Ngroups*25;
    task.ntest=500;
    task.n=task.ntrain+task.ntest;
    task.Ntrials=25;
    task.D=100;
    task.QDA_model=0;
    task.ks=unique(floor(logspace(0,log10(task.ntrain),30)));
elseif strcmp(metatask,'test_LDA9')
    task_list={'gmm'};
    task.algs={'LDA','LOL'};
    task.Ngroups=5;
    task.ntrain=task.Ngroups*25;
    task.ntest=500;
    task.n=task.ntrain+task.ntest;
    task.Ntrials=25;
    task.D=10;
    task.QDA_model=0;
    task.ks=unique(floor(logspace(0,log10(task.ntrain),30)));
elseif strcmp(metatask,'test_LDA9')
    task_list={'gmm'};
    task.algs={'LDA','LOL'};
    task.Ngroups=5;
    task.ntrain=task.Ngroups*25;
    task.ntest=500;
    task.n=task.ntrain+task.ntest;
    task.Ntrials=25;
    task.D=10;
    task.QDA_model=0;
    task.ks=unique(floor(logspace(0,log10(task.ntrain),30)));
elseif strcmp(metatask,'3 cigars')
    task_list={'gmm'};
    task.algs={'LDA','LOL'};
    task.Ngroups=3;
    task.ntrain=task.Ngroups*25;
    task.ntest=500;
    task.n=task.ntrain+task.ntest;
    task.Ntrials=25;
    task.D=100;
    task.ks=unique(floor(logspace(0,log10(task.ntrain),30)));
elseif strcmp(metatask,'test_qda')
    task_list={'wra, D=5', 'wra, D=20'};
    task.algs={'QDA','qda'};
    task.ntrain=100;
    task.Ntrials=50;
    
%%
elseif strcmp(metatask,'NaiveB_v_LOL')
    task_list={'wra, D=10','toeplitz, D=10'};
    task.algs={'NaiveB','LOL'};
    task.types={'NNNN'};
    task.ntrain=50;
    task.ntest=500;
    task.Ntrials=200;
    task.D=10;
    task.Ngroups=2;
    task.ks=10; %:task.ntrain-1;
elseif strcmp(metatask,'lda_v_LOL')
    task_list={'wra, D=10','toeplitz, D=10'};
    task.algs={'lda','LOL'};
    task.types={'NNNL'};
    task.ntrain=50;
    task.ntest=500;
    task.Ntrials=200;
    task.ks=10; %:task.ntrain-1;
elseif strcmp(metatask,'qda_v_LOL')
    task_list={'wra, D=10','toeplitz, D=10'};
    task.algs={'qda','LOL'};
    task.types={'NNNQ'};
    task.ntrain=100;
    task.ntest=500;
    task.Ntrials=200;
    task.ks=10;
    task.D=10;
elseif strcmp(metatask,'nld_v_LOLs')
    task_list={'wra, D=10','toeplitz, D=10'};
    task.algs={'NaiveB','lda','qda','LOL'};
    task.types={'NNNN';'NNNL';'NNNQ'};
    task.ntrain=100;
    task.ntest=500;
    task.Ntrials=200;
    task.ks=10;
    task.D=10;
elseif strcmp(metatask,'LOL_v_LOL')
    task_list={'wra, D=10','toeplitz, D=100'};
    task.algs={'LOL','LOL'};
    task.types={'DENL'};
    task.ntrain=50;
    task.ntest=500;
    task.Ntrials=20;
    task.ks=1:task.ntrain-1;
elseif strcmp(metatask,'QOL_v_LOL')
    task_list={'wra, D=10','toeplitz, D=100'};
    task.algs={'QOL','LOL'};
    task.types={'DENQ'};
    task.ntrain=50;
    task.ntest=500;
    task.Ntrials=20;
    task.ks=1:task.ntrain-1;
elseif strcmp(metatask,'RDA_v_LOL')
    task_list={'wra, D=10','toeplitz, D=100'};
    task.algs={'RDA','LOL'};
    task.types={'NRNL'};
    task.ntrain=50;
    task.ntest=500;
    task.Ntrials=20;
    task.ks=unique(floor(logspace(0,log10(task.ntrain),30)));
elseif strcmp(metatask,'DRDA_v_LOL')
    task_list={'wra, D=10','toeplitz, D=100'};
    task.algs={'DRDA','LOL'};
    task.types={'DRNL'};
    task.ntrain=50;
    task.ntest=500;
    task.Ntrials=20;
    task.ks=1:task.ntrain-1;
elseif strcmp(metatask,'NENLw')
    task_list={'wra, D=10'};
    task.algs={'PDA','LOL'};
    task.types={'NENL'};
    task.ntrain=50;
    task.ntest=500;
    task.Ntrials=20;
    task.ks=1:task.ntrain-1;
elseif strcmp(metatask,'NENLt')
    task_list={'toeplitz, D=100'};
    task.algs={'PDA','LOL'};
    task.types={'NENL'};
    task.ntrain=50;
    task.ntest=500;
    task.Ntrials=20;
    task.ks=1:task.ntrain-1;
elseif strcmp(metatask,'PDA_v_LOL')
    task_list={'wra, D=10','toeplitz, D=100'};
    task.algs={'PDA','LOL'};
    task.types={'NENL'};
    task.ntrain=50;
    task.ntest=500;
    task.Ntrials=20;
    task.ks=1:task.ntrain-1;
elseif strcmp(metatask,'QOL')
    task_list={'wra, D=10','toeplitz, D=100'};
    task.algs={'LOL'};
    task.types={'DENL';'DVNL'};
    task.ntrain=50;
    task.ntest=500;
    task.Ntrials=20;
    task.ks=1:task.ntrain-1;
elseif strcmp(metatask,'QOQ_v_LOL')
    task_list={'wra, D=10','toeplitz, D=100'};
    task.algs={'QOQ','LOL'};
    task.types={'DVNQ'};
    task.ntrain=50;
    task.ntest=500;
    task.Ntrials=20;
    task.ks=1:task.ntrain-1;
end

if ~isfield(task,'savestuff'), task.savestuff=1; end