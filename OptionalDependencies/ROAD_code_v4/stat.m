function [mua, mud, Sigma, x1, x2, n1, n2] = stat(x, y)
if(min(y)==0)
    y = y + 1;
end
x1 = x(y==1,:);
x2 = x(y==2,:);
n1 = size(x1, 1);
n2 = size(x2, 1);
mu1 = mean(x1)';
mu2 = mean(x2)';
mua = (mu2+mu1)/2;
mud = (mu2-mu1)/2;

Sigma = (n1*cov(x1) +  n2*cov(x2))/(n1+n2);