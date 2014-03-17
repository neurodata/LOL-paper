function plot_benchmarks(task_list_name,F)
% plot results for a set of tasks
% generate a row of panels for each task
% each row has the following columns:
%   1) Lhat vs. k for each algorithm, including chance, Bayes, and Risk
%   2) Relative Lhat
%   3) Spectra and estimated spectra for data
%   4) sensitivity and specificity
%
% INPUT:
%   tasks: a structure for each task, containing all necessary meta.data
%   Stats: a structure for each task, containing all statistics
%
% OUTPUT: none

run([pwd,'/../helper_fcns/updatepath.m'])

task_list = set_task_list(task_list_name);
Ntasks=length(task_list);
renderer='painters'; % options: 'painters', 'zbuffer', 'OpenGL'

T = cell(1,Ntasks);
S = cell(1,Ntasks);
for j=1:Ntasks
    load(['../../data/results/', task_list{j}])
    T{j}=task;
    S{j}=Stats;
end


%% set some figure parameters
h(1)=figure(1); clf
% figure('visible','off');


F.Nrows=2;
F.Ncols=Ntasks;

%% make various plots
for j=1:F.Ncols
    
    F = figure_settings(T{j},F);
    plot_Lhat(T{j},S{j},F,j)                % column 1: plot Lhats
    plot_Lhat_v_d(T{j},S{j},F,2,j)          % column 2: Lhat vs dimension embedded
%     plot_Lhat_vs_time(T{j},S{j},F,3,j)      % column 3: Lhat vs. time
end
% save plots
if T{j}.savestuff
    wh=[F.Ncols*2 F.Nrows]*1.2;
    fname=['../../figs/', char(strcat('performance_', task_list_name))];
    print_fig(h(1),wh,fname,renderer)
end
