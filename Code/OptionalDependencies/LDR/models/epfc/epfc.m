function [Wn,fn,fp] = epfc(Yaux,X,u,morph,parameters)
% [Wn,fn,fp] = epfc(Y,X,u,morph,parameters)
%
% This function implements the Extended Principal Fitted Components (EPFC) 
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


if strcmpi(morph,'cont')
    SIGMAfit = get_fitted_cov(Y,X,parameters.fy);
else
    SIGMAfit = get_average_cov(X,data_parameters);
end
SIGMA = data_parameters.sigmag;
SIGMAres = SIGMA - SIGMAfit;
data_parameters.Afit = SIGMAfit;
data_parameters.B = SIGMAres;

%--- get handle to objective function and derivative ......................
Fhandle = F(@F4epfc,data_parameters);
dFhandle = dF(@dF4epfc,data_parameters);

%--- get initial estimate .................................................
if strcmpi(morph,'cont')
    haux = 5;
    Ysliced = slices(Y,haux);
    aux_datapars = setdatapars(Ysliced,X,haux);
    auxpars = parameters; auxpars.nslices=haux;
else
    Ysliced = Y;
    aux_datapars = data_parameters;
    auxpars = parameters;
end
if isempty(parameters.initvalue)||ischar(parameters.initvalue)
    guess = get_initial_estimate(Ysliced,X,u,aux_datapars,auxpars);
    Wo = guess(Fhandle);
else
    Wo = parameters.initvalue;
end

%--- optimization .........................................................
p = cols(X); Wn = eye(p);
fp = Fhandle(Wn);
if u == p,
    warning('LDR:nored','The subspace you are looking for has the same dimension as the original feature space')
    fn = fp;
else
    if ~isempty(parameters.sg),
        [fn Wn] = sg_min(Fhandle,dFhandle,Wo,parameters.sg{:},parameters.maxiter);
    else
        [fn Wn] = sg_min(Fhandle,dFhandle,Wo,'prcg','euclidean',{1:u},'quiet',parameters.maxiter);
    end
    Wn = orth(Wn);
end
