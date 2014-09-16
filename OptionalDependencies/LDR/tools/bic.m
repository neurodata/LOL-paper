function d = bic(f,dof,n)
% d = bic(f,dof,n)
%
% This function returns the dimension d that minimizes the Bayes
% information criterion for the assessed model.
% Inputs:
%   - f: a vector with minus the log-likelihood of the assessed model for
%   dimensions u=0,1,...,p.
%   - dof: vector with the degrees of freedom for the computation of
%   f for the assessed model and dimensions.
%   - n: size of the sample used to fit the assessed model.
%==========================================================================

am = 2*f+ log(n)*dof;
d = argmin(am) - 1;