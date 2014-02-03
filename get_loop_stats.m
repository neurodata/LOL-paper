function Stats = get_loop_stats(task,loop)
% this function computes a bunch of statistics based on the output run
% task_loop

Lhats=nan(task.Nalgs,task.Nks,task.Ntrials);
sensitivity=nan(task.Nalgs,task.Nks,task.Ntrials);
specificity=nan(task.Nalgs,task.Nks,task.Ntrials);

for k=1:task.Ntrials
    for i=1:task.Nalgs;
        if strcmp(task.algs{i},'LDA') || strcmp(task.algs{i},'treebagger')
            l=1;
            Lhats(i,l,k)=loop{k}.out(i,l).Lhat;
            sensitivity(i,l,k)=loop{k}.out(i,l).sensitivity;
            specificity(i,l,k)=loop{k}.out(i,l).specificity;
        else
            for l=1:task.Nks
                Lhats(i,l,k)=loop{k}.out(i,l).Lhat;
                sensitivity(i,l,k)=loop{k}.out(i,l).sensitivity;
                specificity(i,l,k)=loop{k}.out(i,l).specificity;
            end
        end
    end
end

Stats.means.Lhats=squeeze(nanmean(Lhats,3));
Stats.means.sensitivity=squeeze(nanmean(sensitivity,3));
Stats.means.specificity=squeeze(nanmean(specificity,3));

Stats.medians.Lhats=squeeze(nanmedian(Lhats,3));
Stats.medians.sensitivity=squeeze(nanmedian(sensitivity,3));
Stats.medians.specificity=squeeze(median(specificity,3));

Stats.stds.Lhats=squeeze(nanstd(Lhats,[],3));
Stats.stds.sensitivity=squeeze(nanstd(sensitivity,[],3));
Stats.stds.specificity=squeeze(nanstd(specificity,[],3));

% get mins of medians
for i=1:task.Nalgs;
    [~,Stats.mins.med.k(i)]=min(Stats.medians.Lhats(i,:));
    Stats.mins.med.Lhats(i)=Stats.medians.Lhats(i,Stats.mins.med.k(i));
    Stats.mins.med.sensitivity(i)=Stats.medians.sensitivity(i,Stats.mins.med.k(i));
    Stats.mins.med.specificity(i)=Stats.medians.specificity(i,Stats.mins.med.k(i));
    
    [~,Stats.mins.mean.k(i)]=min(Stats.means.Lhats(i,:));
    Stats.mins.mean.Lhats(i)=Stats.means.Lhats(i,Stats.mins.mean.k(i));
    Stats.mins.mean.sensitivity(i)=Stats.means.sensitivity(i,Stats.mins.mean.k(i));
    Stats.mins.mean.specificity(i)=Stats.means.specificity(i,Stats.mins.mean.k(i));
end

% also get chance & bayes stats
Stats.Lchance=nan(task.Ntrials,1);
Stats.Lbayes=nan(task.Ntrials,1);
for k=1:task.Ntrials
    Stats.Lchance(k)=loop{k}.Lchance;
    if task.QDA_model
        Stats.Lbayes(k)=loop{k}.Lbayes;
    end
end
