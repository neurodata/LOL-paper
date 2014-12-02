function [X,Y] = sample_regress(task)

if isfield(task,'D'), D=task.D; else D=100; end
if isfield(task,'n'), n=task.n; else n=550; end
w=1;    % default weight for regression terms
eps=0;  % default weight for "zero" terms
eps2=0;

if strcmp(task.subname,'p=D') % stability selection (a), 
    X=randn(D,n);
    p=100; % nnz
elseif strcmp(task.subname,'p=2D')
    X=randn(D,n);
    p=200; % nnz
else strcmp(task.subname,'toeplitz') % stability selection (c)
    rho=0.99;
    c=rho.^(0:D-1);
    A = toeplitz(c);
    X = mvnrnd(zeros(D,1),A,n);
    X = X';
    p=100; % nnz
    eps2=4;
end

%% generate beta & Y
beta=[eps*randn(D-p,1); w*rand(p,1)];
beta=beta(randperm(D));
Y=beta'*X+eps2*randn(1,n);