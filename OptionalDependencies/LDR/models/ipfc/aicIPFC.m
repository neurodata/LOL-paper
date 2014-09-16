function [Wn,d,fn] = aicIPFC(Yaux,X,morph,parameters)
%[Wmin,d,f] = aicIPFC(Y,X,morph,parameters);
% 
% This function estimates the dimension of the central subspace that best
% describes the data under the IPFC model using Akaike's information criterion.
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
%     parameters (OPTIONAL): structure to set specific values of parameters for
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


if strcmpi(morph,'cont')
    [SIGMAfit,r] = get_fitted_cov(Y,X,parameters.fy);
else
    [SIGMAfit,r] = get_average_cov(X,data_parameters);
end
SIGMA = data_parameters.sigmag;
%--- optimization .........................................................
[n,p] = size(X); 
%--- get handle to objective function and degrees of freedom ......................
Fhandle = F(@F4pfc,data_parameters);
dof = @(do) (r*do + do*(p-do) + p + 1);

%----
[Waux,valsA] = firsteigs(SIGMA,p);
[W,vals] = firsteigs(SIGMAfit,p);
umax = min(r,p);
f = zeros(1,umax+1);
df = zeros(1,umax+1);
for u = 0:umax,
    if u==0,
        f(u+1) = n*p/2*(1 + log(sum(valsA)/p)); 
    else
        f(u+1) = Fhandle(vals(1:(u+1)));
    end
    df(u+1) = dof(u);
end
d = aic(f,df);
%----

if d>0,
    Wn = W(:,1:d) ;
    fn = f(d+1);
else
    fn = f(1);
    Wn = zeros(p);
end

