function [Sigma]=eqcor(p,rho)
% number of features-- the length of error vector
Sigma = (1-rho)*eye(p)+rho*ones(p,p);
