clearvars, clc,
run([pwd,'/../helper_fcns/updatepath.m'])

task.name='mnist';
[T,P,S] = run_task(task);

if task.savestuff
    save(['../../data/results/', task_list_name],'T','P','S')
end


%% plot results
F.ytick=0.1:0.1:0.5;
F.plot_chance=true;
F.plot_bayes=false;
F.plot_risk=false;
F.ylim=[0 0.5];
F.plot_time=true;
plot_benchmarks(task.name,F)
