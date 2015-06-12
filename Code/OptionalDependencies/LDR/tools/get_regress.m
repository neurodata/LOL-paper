function fit = get_regress(FF,X)
%
% fit = get_regress(FF,X);
%
% This function gives the fitted values from the regression of the predictors X onto basis FF. Predictors are centered, and regression includes the intercept.
%
% =============================================
n = size(X,1);
p = size(X,2);
fit = zeros(n,p);
ff = [ones(rows(FF),1) FF];
for j=1:p,
    Xcent = X(:,j) - mean(X(:,j));
    fit(:,j) = ff*regress(Xcent,ff);
end
