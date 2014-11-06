function [X,Y] = sample_regress(task)

if isfield(task,'D'), D=task.D; else D=100; end
if isfield(task,'n'), n=task.n; else n=550; end

X=randn(D,n);
beta=rand(D,1);

Y=beta'*X;