clearvars, clc,

% task_list_names={'thin','sparse','fat','colon_prostate','pancreas'};
task_list_names={'QDA'};

for i=1:length(task_list_names)   
    display(task_list_names{i})
    [tasks, P, Phat, Proj, Stats] = run_task_list(task_list_names{i});
    plot_tasks(tasks,Stats,P,Proj,task_list_names{i})

end

%%
for i=1:length(tasks)
    a(i)=median(Stats{i}.Lbayes)-std(Stats{i}.Lbayes)/sqrt(tasks{i}.Ntrials);
    b(i)=Stats{i}.Risk;
    c(i)=median(Stats{i}.Lbayes)+std(Stats{i}.Lbayes)/sqrt(tasks{i}.Ntrials);
    d(i)=median(Stats{i}.Lbayes);
    e(i)=std(Stats{i}.Lbayes)/sqrt(tasks{i}.Ntrials);
end
[a;b;c], [a<b], [b<c]

%%

figure(4), clf, hold all
for i=1:length(tasks)
errorbar(b(i),d(i),e(i))
plot([0 0.5],[0, 0.5])
% plot(Stats{i}.Risk,median(Stats{i}.Lbayes),'.','markersize',22)
end
grid on
xlabel('risk')
ylabel('bayes')