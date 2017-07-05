function [W,f] = spfc(Yaux,X,u,morph,parameters)
%
% [W,f] = spfc(Y,X,u,morph)
% This function implements Diagonal Principal Fitted Components model for
% Dimension Reduction in Regression. See references for details.
% USAGE:
% - outputs:
%     Wn: generating vectors for the central subspace;
%     fn: value of the loss function at the optimal point;
%     fp: value of the loss function for the original predictors;
%  - inputs:
%     Y: Response vector. 
%     X: Data matrix. Each row is an observation. It is assumed
%        that rows relate with the corresponding rows in Y, so that Y(k) is 
%	     the response due to X(k,:). 
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
%
% --------------------------- REFERENCES -----------------------------------
% Cook, R. D. and Forzani, L. (2009). Principal fitted components in regression.
% Statistcal Science 23 (4), 485-501.
% ===============================================================================

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


if strcmpi(morph,'cont')
    [SIGMAfit,r] = get_fitted_cov(Y,X,parameters.fy);
else
    [SIGMAfit,r] = get_average_cov(X,data_parameters);
end
SIGMA = data_parameters.sigmag;
SIGMAres = SIGMA - SIGMAfit;
data_parameters.Afit = SIGMAfit;
data_parameters.B = SIGMAres;
data_parameters.r = r;

%--- get handle to objective function and derivative ......................
Fhandle = F(@F4spfc,data_parameters);

D = get_maxid(Fhandle,u,data_parameters);
p = cols(X);
if u==p,
    W = eye(p);
else
    W = firsteigs(inv(D)*SIGMA,u);
end
f = Fhandle(D,u);
