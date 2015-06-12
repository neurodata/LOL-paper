function [Afit,r] = get_fitted_cov(Y,X,fy)
%
% [Afit,r] = get_fitted_cov(Y,X,fy)
%
% This function returns the covariance matrix of the fitted values from the
% regression of the predictors X onto a regression basis fy (wich is a 
% function of Y).
% If fy is not specified, it is set by default as a polynomial basis of
% degree r=3, evaluated at the points in Y. When fy, is given, r returns
% the number of columns in the regression basis fy.
%==========================================================================
if~isempty(fy),
	FF = fy;
    r = cols(fy);
else
    disp('using default basis for regression');
    r = 3;
    FF = get_fy(Y,r); % default option
end
fit = get_regress(FF,X);
Afit = get_cov(fit);    
