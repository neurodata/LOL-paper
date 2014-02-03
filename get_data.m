function [X,Y,dataset] = get_data(dataset,P)
% get data based on description in dataset (and P if simulation)

if dataset.simulation
    if strcmp(dataset.name,'DRL')
        [X,Y] = sample_DRL(a);
    elseif strcmp(dataset.name,'xor')
        [X,Y] = sample_xor(dataset);
    else
        [X,Y] = sample_QDA(dataset.n,P.mu0,P.mu1,P.Sig0,P.Sig1);
    end
else
    [X,Y,dataset] = load_cancer(dataset);
end

[D, n]=size(X);

if D==length(Y)
    X=X';
    dataset.D = n;
    dataset.n = D;
else
    dataset.D = D;
    dataset.n = n;
end

