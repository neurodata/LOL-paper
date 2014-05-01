function F = plot_benchmarks(metatask,F)
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

if nargin==1, F=struct; end
load(['../../Data/Results/', metatask])
Ntasks=length(task_list);

% task_list = set_task_list(metatask);
% T = cell(1,Ntasks);
% S = cell(1,Ntasks);
% for j=1:Ntasks
%     load(['../../Data/Results/', task_list{j}])
%     T{j}=task;
%     S{j}=Stats;
% end


%% set some figure parameters
if ~isfield(F,'fig_num'), F.fig_num=1; end
h(F.fig_num)=figure(F.fig_num); clf
% figure('visible','off');
if ~isfield(F,'plot_time'), F.plot_time=true; end
if F.plot_time, F.Nrows=3; else F.Nrows=2; end
F.Ncols=Ntasks;

wh=[F.Ncols*2 F.Nrows]*1.2;
F.PaperSize=wh;
F.PaperPosition=[-0.7 0 wh(1) wh(2)];
F.renderer='painters'; % options: 'painters', 'zbuffer', 'OpenGL'

%% make various plots
for j=1:F.Ncols
    
    F = figure_settings(T{j},F);
    F.xlim=[1 min(T{j}.ntrain,T{j}.D)];
    if F.xlim(2)<=10
        F.xtick=0:2:F.xlim(2);
    elseif F.xlim(2)<=20
        F.xtick=0:5:F.xlim(2);
    elseif F.xlim(2)<=30
        F.xtick=0:10:F.xlim(2);
    elseif F.xlim(2)<=50
        F.xtick=10:10:F.xlim(2);
    elseif F.xlim(2)<=100
        F.xtick=0:25:F.xlim(2);
    end
    if ~isfield(F,'ylim')
        F.ylim=[S{j}.Risk, mean(S{j}.Lchance)];
        if isnan(F.ylim(1)), F.ylim(1)=0; end
    end
    
    plot_Lhat(T{j},S{j},F,j)                % column 1: plot Lhats
    plot_Lhat_v_d(T{j},S{j},F,2,j)          % column 2: Lhat vs dimension embedded
    if F.plot_time, plot_Lhat_vs_time(T{j},S{j},F,3,j), end     % column 3: Lhat vs. time

    for i=1:length(T{j}.algs)
        if ~strcmp(T{j}.algs{i},'LOL')
            display([T{j}.name,' ', T{j}.algs{i},', Lhat=',num2str(S{j}.mins.mean.Lhats(i)),', dhat=',num2str(S{j}.mins.mean.k(i))])
        else
            for jj=1:length(T{j}.types)
                display([T{j}.name,' ', T{j}.types{jj},', Lhat=',num2str(S{j}.mins.mean.Lhats(i-1+jj)),', dhat=',num2str(S{j}.mins.mean.k(i-1+jj))])
            end
        end
    end

end
% save plots
if T{j}.savestuff
    if F.plot_time
        F.fname=['../../figs/', char(strcat('performance_time_', metatask))];
    else
        F.fname=['../../figs/', char(strcat('performance_', metatask))];
    end
    print_fig(h(F.fig_num),F)
end
