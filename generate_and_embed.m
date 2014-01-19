function Z = generate_and_embed(task)

ks=task.ks;

if strcmp(task.job_list_list,'DRL')
    if j==1 || j==4
        a='0';
        ntrain=50;
    elseif j==2 || j==5
        a='00';
        ntrain=25;
    elseif j==3 || j==6
        a='01';
        ntrain=25;
    end
    [X,Y] = generate_DRL(a);
    [n, D]=size(X);
    
    if strcmp(task.name(4),'2')
        ntrain=ntrain*4;
    end
    ntest=n-ntrain;
    
elseif task.simulation
    % simulate
    sim.name=task.name;
    sim.permute=0;
    [X,Y,P] = choose_simulation(sim);
    [n, D]=size(X);
    ntrain=50;
    ntest=n-ntrain;
else
    if strfind(task.job_list,'pancreas')
        [X,Y]=choose_pancreas(data,Ys,task.name);
        [n, D]=size(X);
        ntrain=n-2;
        ntest=2;
    else
        [X,Y]=choose_cancer(task.name);
        [n, D]=size(X);
        ntrain=round(n*2/3);
        ntest=n-ntrain;
    end
end

% parse data
Z = parse_data(X,Y,ntrain,ntest);
if task.simulation
    Z.P=P;
end

% estimate parameters and projection matrices
k_max=min(ntrain,min(D,max(task.ks)));
[Z.Proj, Z.Phat] = estimate_projections(Z.Xtrain,Z.Ytrain,k_max,task.algs);

% generate and project test data onto subspace
Xtrain_centered = bsxfun(@minus,Z.Xtrain,Z.Phat.mu);
Xtest_centered = bsxfun(@minus,Z.Xtest,Z.Phat.mu);
for i=1:length(task.algs)
    Z.Xtrain_proj{i}=Xtrain_centered*Z.Proj{i}.Vhat;
    Z.Xtest_proj{i}=Xtest_centered*Z.Proj{i}.Vhat;
end

Z.ks=ks(ks<=k_max);


