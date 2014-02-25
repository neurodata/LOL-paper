function plot_tasks(tasks,Stats,task_list_name)
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


%% set some figure parameters
figure(1); clf
% figure('visible','off');


F.gray=0.5*[1 1 1];
F.Nrows=2;
F.Ncols=length(tasks);

%% make various plots
for j=1:F.Ncols
    
    % rename variables for task j for legibility
    T=tasks{j};
    S=Stats{j};
    
    for i=1:T.Nalgs
        
        if strcmp(T.algs{i},'LDA')
            F.colors{i}='g';
            F.markers{i}='.';
            F.markersize{i}=24;
            F.linewidth{i}=4;
        elseif strcmp(T.algs{i},'PDA')
            F.colors{i}='m';
            F.markers{i}='s';
            F.markersize{i}=3;
            F.linewidth{i}=4;
        elseif strcmp(T.algs{i},'LOL')
            F.colors{i}='c';
            F.markers{i}='v';
            F.markersize{i}=2;
            F.linewidth{i}=4;
        elseif strcmp(T.algs{i},'DRDA')
            F.colors{i}= [1 0.5 0.2];
            F.markers{i}='x';
            F.markersize{i}=8;
            F.linewidth{i}=2;
        end
    end
    
    plot_Lhat(T,S,F,j)                % column 1: plot Lhats
    plot_Lhat_v_d(T,S,F,2,j)           % column 3 & 4: sensitivity and specificity
    %     plot_sens_spec(T,S,F,j,1)           % column 3 & 4: sensitivity and specificity
    
end

%% save plots
if T.savestuff
    wh=[F.Ncols 2]*1.2;
    fname=['../../figs/', char(strcat('performance_', task_list_name))];
    print_fig(gcf,wh,fname)
end
