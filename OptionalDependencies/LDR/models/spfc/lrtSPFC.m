function [Wn,d,fn] = lrtSPFC(Yaux,X,morph,parameters)
%
% [Wmin,d,f] = lrtSPFC(Y,X,morph,parameters);
% 
% This function estimates the dimension of the central subspace that best
% describes the data under the SPFC model using a likelihood-ratio test.
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
[n,p] = size(X);

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
dofCHI2 = @(u)((r-u)*(p-u));

umax = min(r,p);
D = get_maxid(Fhandle,r,data_parameters);
lo = Fhandle(D,r);
alpha = parameters.alpha;
for u = 1:umax,
    D = get_maxid(Fhandle,u,data_parameters);
    f = Fhandle(D,u);
    statistic = 2*(f-lo);
    if (chi2cdf(statistic,dofCHI2(u)) < (1-alpha))||(u==umax);
        d = u;
        fn = f;
        Wn = firsteigs(inv(D)*SIGMA,d);
        break;
    end
end
