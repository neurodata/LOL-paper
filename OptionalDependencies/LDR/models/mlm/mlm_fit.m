function [WX,W,f,d] = mlm_fit(Y,X,dim,varargin)
% function [GX,G,f,d] = MLM_fit(Y,X,dim,varargin)
% Fits the envelope model and returns G = Gamma, 
%     f= value of maximized log likelihood and d = estimate of d.
% Set d a specific value for a preselected dimension
% Set d to " 'lrt', .05 " to use the likelihood ratio testing criterion
%     to estimate d with level .05
% Setting d to 'aic' or 'bic' uses the AIC or BIC criterion.
% ==========================================================  
A = randn(size(Y,1),1);
[WX,W,f,d] = ldr(A,Y,'epfc','cont',dim,'fy',X,varargin{:});

