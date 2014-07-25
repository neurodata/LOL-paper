function Stats = get_loop_stats(T,loop)
% this function computes a bunch of statistics based on the output run task_loop

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
            if isfield(loop{k},'time'), time=loop{k}.time(i,l); else time=NaN; end
            times(i,l,k)=time;
            if isfield(loop{k},'ROAD_num'), Stats.ROAD_num(k,:)=loop{k}.ROAD_num; end
            if size(loop{k}.out,2)==1 || isempty(loop{k}.out(i,2).Lhat) % if we did not do cv across dimensions for this algorithm
                break
            end
        end
    end
end

% ii=1;
% if isfield(loop{1},'ROAD')
%     for k=1:T.ntrials
%         for i=1:Nalgs;
%             for l=1:T.Nks
%                 Lhats(ii+i,l,k)=loop{k}.ROAD(i,l).Lhat;
%                 ks(i,l,k)=loop{k}.out(i,l).num;
%                 if size(loop{k}.out,2)==1 || isempty(loop{k}.out(i,2).Lhat) % if we did not do cv across dimensions for this algorithm
%                     break
%                 end
%             end
%         end
%     end
% end
% 
% for i=1:T.Nalgs
%     if strcmp(T.algs{i},'RF')
%         for k=1:T.ntrials
%             Stats.NumParents(k)=loop{k}.NumParents;
%         end
%     end
% end

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