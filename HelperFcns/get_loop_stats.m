function Stats = get_loop_stats(T,loop)
% this function computes a bunch of statistics based on the output run task_loop

if ~isfield(T,'Nalgs'), T.Nalgs=length(T.algs); end
if ~isfield(T,'Nks'), T.Nks=length(T.ks); end
if ~isfield(T,'ntrials'), T.ntrials=1; end
if isfield(T,'types')
    Nalgs=T.Nalgs+length(T.types);
else
    Nalgs=T.Nalgs;
end
if any(strcmp(T.algs,'LOL')), Nalgs=Nalgs-1; end

Lhats=nan(Nalgs,T.Nks,T.ntrials);
sensitivity=nan(Nalgs,T.Nks,T.ntrials);
specificity=nan(Nalgs,T.Nks,T.ntrials);
times=nan(Nalgs,T.Nks,T.ntrials);

for k=1:T.ntrials
    for i=1:Nalgs;
        for l=1:T.Nks
            Lhats(i,l,k)=loop{k}.out(i,l).Lhat;
            sensitivity(i,l,k)=loop{k}.out(i,l).sensitivity;
            specificity(i,l,k)=loop{k}.out(i,l).specificity;
            if isfield(loop{k},'nnz'), Stats.nnz(k,:)=loop{k}.nnz; end
            if size(loop{k}.out,2)==1 || isempty(loop{k}.out(i,2).Lhat) % if we did not do cv across dimensions for this algorithm
                break
            end
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
for i=1:Nalgs;
    [~,k]=min(Stats.medians.Lhats(i,:));
    Stats.mins.med.k(i)=T.ks(k);
    Stats.mins.med.Lhats(i)=Stats.medians.Lhats(i,k);
    Stats.mins.med.sensitivity(i)=Stats.medians.sensitivity(i,k);
    Stats.mins.med.specificity(i)=Stats.medians.specificity(i,k);
    Stats.mins.med.times(i)=Stats.medians.times(i,k);
    
    [~,k]=min(Stats.means.Lhats(i,:));
    Stats.mins.mean.k(i)=T.ks(k);
    Stats.mins.mean.Lhats(i)=Stats.means.Lhats(i,k);
    Stats.mins.mean.sensitivity(i)=Stats.means.sensitivity(i,k);
    Stats.mins.mean.specificity(i)=Stats.means.specificity(i,k);
    Stats.mins.mean.times(i)=Stats.means.times(i,k);
end

for i=1:T.Nalgs
    if strcmp(T.algs{i},'LDA'),
        Stats.mins.mean.k(i) = min(T.ntrain,T.D);
        Stats.med.mean.k(i) = min(T.ntrain,T.D);
    end
end

for k=1:T.ntrials
    for i=1:Nalgs;
        Stats.time(k,i)=loop{k}.time(i);
    end
end

% also get chance & bayes stats
Stats.Lchance=nan(T.ntrials,1);
Stats.Lbayes=nan(T.ntrials,1);
for k=1:T.ntrials
    if isfield(loop{k},'Lchance')
        Stats.Lchance(k)=loop{k}.Lchance;
    end
    if isfield(loop{k},'Lbayes')
        Stats.Lbayes(k)=loop{k}.Lbayes;
    end
end