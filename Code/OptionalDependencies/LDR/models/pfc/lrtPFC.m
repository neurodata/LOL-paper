function [Wn,dim,fn] = lrtPFC(Yaux,X,morph,parameters)
%
% [Wmin,d,f] = lrtPFC(Y,X,morph,parameters);
% 
% This function estimates the dimension of the central subspace that best
% describes the data under the PFC model using a likelihood-ratio test.
% USAGE:
%  - outputs:
%    - Wmin: generating vectors for the central subespace of estimated
%    dimension.
%    - d: estimated dimension under LRT.
%    - f: value of the optimized function for dimension d. (perhaps this is useless)
%  - inputs: 
%    - Y: response vector;
%    - X: matrix of predictors;
%    - morph: 'cont' for continuous responses or 'disc' for discrete
%     responses.
%    - parameters (OPTIONAL): structure to set specific values of parameters for
%     computations. 
%           - parameters.alpha: test level. Default is 0.05.
%           - parameters.fy: basis for regression of centered predictors.
%           By default, this is a polynomial basis of degree 3.
%
%
%
% -------------------------- REQUIREMENTS ---------------------------------
% This function requires the Statistic Toolbox or a custom function to 
% compute the CDF for a chi2 distribution.
% =========================================================================

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

%--- get fitted covariance matrix
if strcmpi(morph,'cont')
    [SIGMAfit,r] = get_fitted_cov(Y,X,parameters.fy);
else
    [SIGMAfit,r] = get_average_cov(X,data_parameters);
end
SIGMA = data_parameters.sigmag;
SIGMAres = SIGMA - SIGMAfit;


%--- optimization .........................................................
[n,p] = size(X); 
alpha = parameters.alpha;

%--- get handle to objective function and degrees of freedom ......................
Fhandle = F(@F4pfc,data_parameters);
dofCHI2 = @(do) ((r-do)*(p-do));
lo = n*p/2*(1 + log(2*pi)) + n/2*logdet(SIGMAres);
%----

[W,vals] = firsteigs(inv(SIGMAres)*SIGMA,p);
for u=0:min(r,p),
    if u==0,
        fn = n*p/2*(1 + log(2*pi)) + n/2*logdet(SIGMA);
    else
        fn = Fhandle(vals(1:u));
    end
    statistic = 2*(fn-lo);
    if (chi2cdf(statistic,dofCHI2(u)) < (1-alpha)) || (u==min(r,p)),
        dim = u;
        break;
    end
end
if dim>0
    Wn = W(:,1:dim);
else
    Wn = zeros(p);
end


        
