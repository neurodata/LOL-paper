function [T,S,P] = run_task_list(metatask,task_list,task)
% runs a bunch of tasks and saves them
% 
% INPUT: 
%   metatask (char): name of metatask 
%   (optional) task_list: array where each element names a task
%   (optional) task: settings common to all tasks
% 
% OUTPUT
%   T (struct): task settings for each task
%   S (struct): summary statistics for each task
%   P (struct): parameters for simulated tasks

if nargin==1
    [task_list, task] = set_task_list(metatask);
else
    if ~isfield(task,'savestuff'), task.savestuff=1; end
end

Ntasks=length(task_list);
T=cell(1,Ntasks); P=cell(1,Ntasks); S=cell(1,Ntasks);
for j=1:Ntasks
    task.name=task_list{j};    
    fprintf('\n task name = %s\n\n',task.name)
    [T{j},S{j},P{j}] = run_task(task);
end

if task.savestuff
    save(['../../Data/Results/', metatask],'T','P','S','task_list','metatask')
end
