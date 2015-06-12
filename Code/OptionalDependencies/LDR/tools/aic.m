function d = aic(f,dof)
% d = aic(f,dof)
%
% This function returns the dimension d that minimizes the Akaike's
% information criterion.
% Inputs:
%   - f: a vector with minus the log-likelihood of the assessed model for
%   dimensions u=0,1,...,p.
%   - dof: vector with the degrees of freedom for the computation of
%   f for the assessed model and dimensions.
%==========================================================================
am = 2*(f+dof);
d = argmin(am)-1;