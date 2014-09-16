function [beta,S,Sfit,Sres] = mlm_fmpars(Y,X);
% [beta,S,Sfit,Sres] = mlm_fmpars(Y,X)
% Returns the parameter estimates from the full multivariate linear model.
% beta is the coefficient matrix
% S is the marginal covariance matrix of Y
% Sfit is the covariance matrix of the fitted vectors
% Sres is the covariance matrix of the residual vectors
% ====================================================
[n,p] = size(X);
F = mlm_center(X);
U = mlm_center(Y);
beta = U'*F*inv(F'*F);
Sfit = beta*F'*U/n;
S = U'*U/n;
Sres = S - Sfit;
