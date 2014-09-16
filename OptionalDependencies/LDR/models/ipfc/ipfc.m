function [Wn,fn,fp] = ipfc(Yaux,X,u,morph,parameters)
% [Wn,fn,fp] = ipfc(Y,X,u,morph,parameters)
%
% This function implements the Isotonic Principal Fitted Components (IPFC) 
% model for Dimension Reduction in Regression (Cook 2007).
% USAGE:
% - outputs:
%     Wn: generating vectors for the central subspace;
%     fn: value of the loss function at the optimal point;
%     fp: value of the loss function for the original predictors;
%  - inputs:
%     Y: Response vector. 
%     X: Data matrix. Each row is an observation. It is assumed
%        that rows relate with the corresponding rows in Y, so that Y(k) is 
%	    the response due to X(k,:). 
%     u: Dimension of the sufficient subspace. It must be a 
%        natural greater than 1 and smaller than the number of columns in X.
%     morph: 'cont' for continuous responses or 'disc' for discrete
%     responses.
%     parameters (OPTIONAL): structure to set specific values of parameters for
%     computations. 
%           - parameters.fy: basis for regression of centered predictors.
%           By default, this is a polynomial basis of degree 3.
%
%
% --------------------------- REFERENCES -----------------------------------
% Cook, R. D. (2007). Fisher Lecture: Dimension reduction in regression (with discussion). 
% Statistical Science 22, 1-26.
% =======================================================

%----checking type of response ......................
if strcmpi(morph,'disc'),
    Y = mapdata(Yaux);
    parameters.nslices = max(Y);
else % morph = 'cont'
    Y = Yaux;
    parameters.nslices = length(Y);
end        
%--- get sample statistics ................................................
data_parameters = setdatapars(Y,X,parameters.nslices);

%--- get handle to objective function ......................
Fhandle = F(@F4pfc,data_parameters);

if strcmpi(morph,'cont')
    SIGMAfit = get_fitted_cov(Y,X,parameters.fy);
else
    SIGMAfit = get_average_cov(X,data_parameters);
end

%--- optimization .........................................................
p = cols(X); 
Wn = eye(p);
fp = Fhandle(ones(1,p));
if u == p,
    warning('LDR:nored','The subspace you are looking for has the same dimension as the original feature space')
    fn = fp;
else
    [Wn,vals] = firsteigs(SIGMAfit,u);
    fn = Fhandle(vals);
end
