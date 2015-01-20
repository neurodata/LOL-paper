% this script generates the simulation for power results for Fig 3,
% which will shows LOL vs. RP for power

%% set path correctly
clearvars, clc,
fpath = mfilename('fullpath');
findex=strfind(fpath,'/');
p = genpath(fpath(1:findex(end-2)));
addpath(p);
s=rng;
% save('~/Research/working/A/LOL/Data/randstate','s')
% load([fpath(1:findex(end-2)), 'Data/randstate']);
% rng(s);

%% set up tasks
clear idx
task.D=200;
task.n=500;
task.ks=unique(round(logspace(0,log10(task.D-10),30)));
[~, ~,task.types] = parse_algs({'DENL';'NERL'});
task.savestuff=1;
task.Ntrials=3;
task.Ntypes=length(task.types);
task.Nks=length(task.ks);
task.Kmax=max(task.ks);
subnames={'diag_slow'}; %;'diag_fast';'rand_slow';'rand_fast'};
Ns=length(subnames);
for subname=1:Ns
    task.name=subnames{subname};
    pval=nan(task.Ntrials,task.Nks,task.Ntypes);
    for t=1:task.Ntrials
        % generate data and embed it
        P = set_parameters(task);
        gmm = gmdistribution(P.mu',P.Sigma,P.w);
        [X,Y] = random(gmm,task.n);
        
        % LOL
        [transformers, deciders] = parse_algs(task.types);
        [Proj, P] = LOL(X',Y,transformers,max(task.ks));
        
        % generate test statistics
        for k=1:task.Nks
            Xhat = X*Proj{1}.V(1:task.ks(k),:)';
            for j=1:length(Proj)
                pval(t,k,j)=Hotelling(Xhat,Y);
            end
        end
        
    end
    
    %% get stats
    
    power=pval<0.05;
    % store stats for plotting
    S{subname}.mean_power=squeeze(mean(power,1));
    S{subname}.std_power=squeeze(std(power,1));
        
    S{subname}.subname=task.subname;
    S{subname}.ks=task.ks;
    S{subname}.savestuff=task.savestuff;
end

%% loop to get other stuff saved
clear Z transformers X Y task1
for subname=1:length(subnames)
    task.subname=subnames{subname};
    [transformers, deciders] = parse_algs(task.types);
    S{subname}.transformers=transformers;
end

if task.savestuff, save([fpath(1:findex(end-2)), 'Data/results/extensions'],'S'), end

%%

