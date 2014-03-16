function Stats = get_loop_stats(task,loop)
% this function computes a bunch of statistics based on the output run
% task_loop

Lhats=nan(task.Nalgs,task.Nks,task.Ntrials);
sensitivity=nan(task.Nalgs,task.Nks,task.Ntrials);
specificity=nan(task.Nalgs,task.Nks,task.Ntrials);
times=nan(task.Nalgs,task.Nks,task.Ntrials);

for k=1:task.Ntrials
    for i=1:task.Nalgs;
        for l=1:task.Nks
            Lhats(i,l,k)=loop{k}.out(i,l).Lhat;
            sensitivity(i,l,k)=loop{k}.out(i,l).sensitivity;
            specificity(i,l,k)=loop{k}.out(i,l).specificity;
            times(i,l,k)=loop{k}.time(i,l);
            if size(loop{k}.out,2)==1 || isempty(loop{k}.out(i,2).Lhat) % if we did not do cv across dimensions for this algorithm
                break
            end
        end
    end
end

for i=1:task.Nalgs
   if strcmp(task.algs{i},'treebagger')
      for k=1:task.Ntrials
         Stats.NumParents(k)=loop{k}.NumParents; 
      end
   end
end

Stats.means.Lhats=squeeze(nanmean(Lhats,3));
Stats.means.sensitivity=squeeze(nanmean(sensitivity,3));
Stats.means.specificity=squeeze(nanmean(specificity,3));
Stats.means.times=squeeze(nanmean(times,3));

Stats.medians.Lhats=squeeze(nanmedian(Lhats,3));
Stats.medians.sensitivity=squeeze(nanmedian(sensitivity,3));
Stats.medians.specificity=squeeze(median(specificity,3));
Stats.medians.times=squeeze(median(times,3));

Stats.stds.Lhats=squeeze(nanstd(Lhats,[],3));
Stats.stds.sensitivity=squeeze(nanstd(sensitivity,[],3));
Stats.stds.specificity=squeeze(nanstd(specificity,[],3));
Stats.stds.times=squeeze(nanstd(times,[],3));

% get mins of medians
for i=1:task.Nalgs;
    [~,k]=min(Stats.medians.Lhats(i,:));
    Stats.mins.med.k(i)=task.ks(k);
    Stats.mins.med.Lhats(i)=Stats.medians.Lhats(i,Stats.mins.med.k(i));
    Stats.mins.med.sensitivity(i)=Stats.medians.sensitivity(i,Stats.mins.med.k(i));
    Stats.mins.med.specificity(i)=Stats.medians.specificity(i,Stats.mins.med.k(i));
    Stats.mins.med.times(i)=Stats.medians.times(i,Stats.mins.med.k(i));
    
    [~,k]=min(Stats.means.Lhats(i,:));
    Stats.mins.mean.k(i)=task.ks(k);
    Stats.mins.mean.Lhats(i)=Stats.means.Lhats(i,Stats.mins.mean.k(i));
    Stats.mins.mean.sensitivity(i)=Stats.means.sensitivity(i,Stats.mins.mean.k(i));
    Stats.mins.mean.specificity(i)=Stats.means.specificity(i,Stats.mins.mean.k(i));
    Stats.mins.mean.times(i)=Stats.means.times(i,Stats.mins.mean.k(i));
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
