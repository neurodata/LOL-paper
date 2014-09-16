function [Wn,fn,fp] = lad(Yaux,X,u,morph,parameters)
% [Wn,fn,fp] = lad(Y,X,u,morph,parameters)
%
% This function implements the Likelihood Acquired Directions (LAD) model
% for Dimension Reduction in Regression (Cook and Forzani 2009).
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
%           - parameters.nslices: number of slices for discretization of
%           continuous responses.
%           - parameters.sg: optional parameters for sg_min (see sg_min 
%           documentation for details)
%
%
% --------------------------- REFERENCES -----------------------------------
% Cook, R. D. and Forzani, L. (2009). Likelihood-based sufficient dimension reduction. 
% Journal of the American Statistical Association. 104 (485): 197-208.\\
% doi:10.1198/jasa.2009.0106.
% -------------------------REQUIRED PACKAGES--------------------------------
%  - SG_MIN PACKAGE: several functions to perform Stiefel-Grassmann optimization.
%
% ===============================================================================
%----checking type of response and slicing if needed.......................
if strcmpi(morph,'disc'),
    Y = mapdata(Yaux);
    parameters.nslices = max(Y);
else % morph = 'cont'
    if parameters.nslices==0,
        warning('LDR:slices','for continuous responses, a number of slices should be given. Five slices will be used');
        parameters.nslices = 5;
    end
    Y = slices(Yaux,parameters.nslices);
end        
%--- get sample statistics ................................................
data_parameters = setdatapars(Y,X,parameters.nslices);

%--- get handle to objective function and derivative ......................
Fhandle = F(@F4lad,data_parameters);
dFhandle = dF(@dF4lad,data_parameters);


%--- optimization .........................................................
p = cols(X); Wn = eye(p);
fp = Fhandle(Wn);
if u == p,
    warning('LDR:nored','The subspace you are looking for has the same dimension as the original feature space')
    fn = fp;
else
    %--- get initial estimate .................................................
    if isempty(parameters.initvalue)||ischar(parameters.initvalue)
        guess = get_initial_estimate(Y,X,u,data_parameters,parameters);
        Wo = guess(Fhandle);
    else
        Wo = parameters.initvalue;
    end
    
    if ~isempty(parameters.sg),
        [fn Wn] = sg_min(Fhandle,dFhandle,Wo,parameters.sg{:},parameters.maxiter);
    else
        [fn Wn] = sg_min(Fhandle,dFhandle,Wo,'prcg','euclidean',{1:u},'quiet',parameters.maxiter);
    end
    Wn = orth(Wn);
end
