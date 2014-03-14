function plot_choosek(tasks,Stats,task_list_name,renderer)
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
h(1)=figure(1); clf
% figure('visible','off');


F.gray=0.5*[1 1 1];
F.Nrows=3;
F.Ncols=length(tasks);

%% make various plots
for j=1:F.Ncols
    
    % rename variables for task j for legibility
    T=tasks{j};
    S=Stats{j};
    
    for i=1:T.Nalgs
        
        if strcmp(T.algs{i},'LDA')
            F.colors{i}='g';            % green
            F.markers{i}='.';
            F.markersize{i}=24;
            F.linewidth{i}=4;
        elseif strcmp(T.algs{i},'PDA')
            F.colors{i}='m';            % magenta
            F.markers{i}='s';
            F.markersize{i}=3;
            F.linewidth{i}=4;
        elseif strcmp(T.algs{i},'LOL')
            F.colors{i}='c';            % cyan
            F.markers{i}='v';
            F.markersize{i}=2;
            F.linewidth{i}=4;
        elseif strcmp(T.algs{i},'SLOL')
            F.colors{i}=[0.5 0 0.9];    % purple
            F.markers{i}='+';
            F.markersize{i}=2;
            F.linewidth{i}=4;
        elseif strcmp(T.algs{i},'RDA')
            F.colors{i}= 'y';           % yellow
            F.markers{i}='*';
            F.markersize{i}=8;
            F.linewidth{i}=2;
        elseif strcmp(T.algs{i},'DRDA')
            F.colors{i}= [1 0.5 0.2];   % orange
            F.markers{i}='x';
            F.markersize{i}=8;
            F.linewidth{i}=2;
        elseif strcmp(T.algs{i},'treebagger')
            F.colors{i}= 'b';           % dark blue
            F.markers{i}='o';
            F.markersize{i}=8;
            F.linewidth{i}=2;
        elseif strcmp(T.algs{i},'svm')
            F.colors{i}= [0 0.5 0];     % dark green
            F.markers{i}='d';
            F.markersize{i}=8;
            F.linewidth{i}=2;
        elseif strcmp(T.algs{i},'naivebayes')
            F.colors{i}= [0.9 0.75 0];    % brown
            F.markers{i}='h';
            F.markersize{i}=8;
            F.linewidth{i}=2;
        end
    end
    
    plot_Lhat(T,S,F,j)                % column 1: plot Lhats
    plot_Lhat_v_d(T,S,F,2,j)          % column 2: Lhat vs dimension embedded
    plot_Lhat_vs_time(T,S,F,3,j)      % column 3: Lhat vs. time
end

%% save plots
if T.savestuff
    wh=[F.Ncols*3 F.Nrows]*1.2;
    fname=['../../figs/', char(strcat('performance_', task_list_name))];
    print_fig(h(1),wh,fname,renderer)
end
