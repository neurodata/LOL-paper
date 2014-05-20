% clearvars, clc,
% metatask='test_LOL'
% [T,S,P] = run_task_list(metatask);
%
% F.plot_bayes=false;
% F.plot_time=false;
% plot_benchmarks(metatask,F);

%%
% clearvars, clc,
% metatask='test_LOL2'
% [T,S,P] = run_task_list(metatask);
%
% F.plot_bayes=false;
% F.plot_time=false;
% plot_benchmarks(metatask,F);

%%
% clearvars, clc,
% metatask='test_LOL6'
% [T,S,P] = run_task_list(metatask);
%
% F.plot_bayes=false;
% F.plot_time=false;
% plot_benchmarks(metatask,F);

%%
clearvars, clc
% metatask='NaiveB_v_LOL';
% metatask='lda_v_LOL';
% metatask='qda_v_LOL';
% metatask='nld_v_LOLs';
% metatask='LOL_v_LOL';
% metatask='QOL_v_LOL';
% metatask='RDA_v_LOL';
% metatask='DRDA_v_LOL';
% metatask='NENLw';
% metatask='NENLt';
metatask='QOL';


[task_list,task] = test_task_list(metatask);
[T,S,P] = run_task_list(metatask,task_list,task);
%%
F.plot_bayes=false;
F.plot_time=false;
F = plot_benchmarks(metatask,F);


%%

