function [Wn,d,fn] = aicSPFC(Yaux,X,morph,parameters)
%[Wmin,d,f] = aicSPFC(Y,X,morph,parameters);
% 
% This function estimates the dimension of the central subspace that best
% describes the data under the SPFC model using Akaike's information criterion.
% USAGE:
%  - outputs:
%    - Wmin: generating vectors for the central subspace of estimated
%    dimension.
%    - d: estimated dimension under AIC.
%    - f: value of the optimized function for dimension d. (perhaps this is useless)
%  - inputs: 
%    - Y: response vector;
%    - X: matrix of predictors;
%    - morph: 'cont' for continuous responses or 'disc' for discrete
%     responses.
%    - parameters (OPTIONAL): structure to set specific values of parameters for
%     computations. 
%           - parameters.fy: basis for regression of centered predictors.
%           By default, this is a polynomial basis of degree 3.
%
% 
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
p = cols(X);

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
dof = @(u) (r*u + u*(p-u) + 2*p);
% dFhandle = dF(@dF4spfc,data_parameters);

umax = min(r,p);
f = zeros(1,umax+1);
df = zeros(1,umax+1);
for u = 0:umax,
    D = get_maxid(Fhandle,u,data_parameters);
    f(u+1) = Fhandle(D,u);
    df(u+1) = dof(u);
end
d = aic(f,df);
fn = f(d+1);
if d>0
    Dd = get_maxid(Fhandle,d,data_parameters);
    Wn = firsteigs(inv(Dd)*SIGMA,d);
else
    Wn = zeros(p);
end
