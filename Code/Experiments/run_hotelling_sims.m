function [T,S,P,task] = run_hotelling_sims(tasknames,task)

if nargin==0
    tasknames={'toeplitz, D=100'};
elseif nargin==1
    task=struct;
end
if ~iscell(tasknames), tasknames={'toeplitz, D=100'}; end

% tasknames={'Hotelling1';'trunk4, D=100';'toeplitz, D=100';'fat tails, D=100'};

if ~isfield(task,'save'),   task.save=1; end
if ~isfield(task,'Ntrials'),task.Ntrials=20; end
if ~isfield(task,'B'),      task.B=100; end
if ~isfield(task,'Ndim'),   task.Ndim=5; end
if ~isfield(task,'D'),      task.D=200; end
if ~isfield(task,'n'),      task.n=100; end
if ~isfield(task,'Nb'),     task.Nb=8; end
if ~isfield(task,'bvec'),   task.bvec=[0,logspace(-2,-1,task.Nb-1)]/2; end
if ~isfield(task,'transformers'), task.transformers= parse_algs({'NEAL';'DEAL';'NENL';'DENL'}); end

task.Nb=length(task.bvec);
task.Ntransformers=length(task.transformers);

for t=1:length(tasknames)
    
    T1=task;
    T1.name=tasknames{t};
    
    switch T1.name
        case 'Hotelling1'
            T1.bvec=[0,logspace(-1.5,-1,T1.Nb-1)]/2; %logspace(-1.5,log10(0.5),Nb);
        case 'trunk4, D=100'
            T1.bvec=logspace(-1,1,T1.Nb);
        case 'toeplitz, D=100'
            T1.bvec=logspace(-1,0.5,T1.Nb);
        case 'r2toeplitz, D=100'
            T1.bvec=[0,logspace(-2,1,T1.Nb-1)]/2; %logspace(-1.5,log10(0.5),Nb);
        case 'rand_lopes'
            T1.Ntrials=800;
    end
    
    T1
    
    pval=nan(T1.Ntrials,T1.Nb);
    pvalB=pval;
    pval2=nan(T1.Ntransformers,T1.Ntrials,T1.Nb);
    T2=pval2;
    
    %% compute p-values
    for k=1:T1.Nb
        
        disp(k)
        for i=1:T1.Ntrials
            
            T1.b=T1.bvec(k);
            P = set_parameters(T1);
            gmm = gmdistribution(P.mu',P.Sigma,P.w);
            [X,Y] = random(gmm,T1.n);
            
            % projection hotelling's
            for jj=1:T1.Ntransformers
                PP.B=T1.B;
                PP.transformers=T1.transformers(jj);
                [pval2(jj,i,k), T2(jj,i,k)]=Hotelling(X,Y,PP);
            end
            
            if T1.D < T1.n% hotelling
                pval(i,k)=Hotelling(X,Y);
                pvalB(i,k)=Hotelling(X,Y,T1);
            end
        end
    end
    
    %% get power stats
    
    
    S{t}.lol_power= pval2<0.05;
    for j=1:T1.Ntransformers
        S{t}.mean_pval(j,:)=squeeze(mean(pval2(j,:,:)))';
        S{t}.mean_power(j,:)=squeeze(mean(S{t}.lol_power(j,:,:)))';
        S{t}.std_power(j,:)=squeeze(std(S{t}.lol_power(j,:,:)))';
    end
    
    
    if T1.D < T1.n
        S{t}.mean_pval=mean(pval);
        S{t}.power=pval<0.05;
        S{t}.mean_power(1,:)=mean(power);
        S{t}.std_power(1,:)=std(power);
        
        S{t}.mean_pval(2+j,:)=mean(pvalB);
        S{t}.powerB=pvalB<0.05;
        S{t}.mean_power(2+j,:)=mean(powerB);
        S{t}.std_power(2+j,:)=std(powerB);
    end
    
    S{t}.sensitivity=mean((pval2(:,:,1))>0.05,2);
    T{t}=T1;
end

if task.save
    save(['../../Data/Results/test_sims2'],'T','S','task')
end
