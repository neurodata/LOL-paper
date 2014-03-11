% function [T,P,S] = Figure3_choosek(task_list_name)
clearvars, 
clc, updatepath

task_list_name='pancreas';
task_list = set_task_list(task_list_name);

for j=1:length(task_list)
    display(task_list{j})
    
    task.name=task_list{j};
    task.ks=unique(round(logspace(0,2,50)));
    task.Ntrials=1000;
    task.algs={'LDA','PDA','SLOL','LOL','treebagger','svm'};
    task.savestuff=1;
    
    [T{j},P{j},S{j}] = run_task(task);
end