function FF = get_fy(Y,r,op)
%
% FF = get_fy(Y,r,op)
%
% This function builds a polynomial regression matrix to estimate the
% fitted covariance matrix for models PFC, IPFC. SPFC and SEPFC.
% USAGE:
%   - outputs:
%         FF: zero-mean polynomial basis for regression
%     - inputs:
%         Y: response vector;
%         r: order of polynomial basis
%         op: a flag to choose for a slightly modified version of the basis.
%         When this flag is set to 'sqr', the usual polynomials are used; 
%         when it is set to 'abs' second order terms are replaced by the absolute value.
% -------------------------------------------------------------------------
if nargin < 3,
	op = 'sqr';
end
n = length(Y);
FF = zeros(n,r);
for i=1:r,
    FF(:,i) = Y.^i - mean(Y.^i);
end
if strcmpi(op,'abs'),
	FF(:,2) = abs(Y) - mean(abs(Y));
end