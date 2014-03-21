function [T,S,P] = run_task_list(metatask)
% runs a bunch of tasks and saves them
% 
% INPUT: metatask (char): name of metatask 
% 
% OUTPUT
%   T (struct): task settings for each task
%   S (struct): summary statistics for each task
%   P (struct): parameters for simulated tasks

run([pwd,'/../helper_fcns/updatepath.m'])
[task_list, task] = set_task_list(metatask);

Ntasks=length(task_list);
T=cell(1,Ntasks); P=cell(1,Ntasks); S=cell(1,Ntasks);
for j=1:Ntasks
    task.name=task_list{j};    
    fprintf('\n task name = %s\n\n',task.name)
    [T{j},S{j},P{j}] = run_task(task);
end

if task.savestuff
    save(['../../data/results/', metatask],'T','P','S')
end
