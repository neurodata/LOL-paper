function XC = mlm_center(X);
% XC = mlm_center(X)
% Centers the matrix X
%==========================
[n,p] = size(X);
XC = zeros(n,p);
for j=1:p,
    XC(:,j) = X(:,j) - mean(X(:,j));
end

