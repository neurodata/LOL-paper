function plot_tasks(tasks,Stats,P,Proj,task_list_name)
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
F.colors{1}='m';
F.colors{2}='g';
F.colors{3}='b';
F.colors{4}=F.gray;

F.markers{1}='o';
F.markers{2}='+';
F.markers{3}='x';
F.markers{4}='*';

F.Ncols=5;
F.Nrows=length(tasks);

%% make various plots
for j=1:F.Nrows

    % rename variables for task j for legibility
    T=tasks{j};
    S=Stats{j};
    
    plot_Lhat(T,S,F,j,1)                % column 1: plot Lhats
    plot_relative(T,S,F,j,3)            % column 2: plot performance vs LDA
    plot_spectra(T,P{j},Proj{j},F,j,2)  % column 3: plot spectra
    plot_sens_spec(T,S,F,j,1)           % column 4 & 5: sensitivity and specificity

end

%% save plots
if T.savestuff
    wh=[8 F.Nrows]*1.2;
    fname=char(strcat('performance_', task_list_name));
    print_fig(gcf,wh,fname)
end
