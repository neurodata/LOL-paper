function [Wn,d,fn] = bicPFC(Yaux,X,morph,parameters)
%[Wmin,d,f] = bicPFC(Y,X,morph,parameters);
% 
% This function estimates the dimension of the central subspace that best
% describes the data under the PFC model using Bayes information criterion.
% USAGE:
%  - outputs:
%    - Wmin: generating vectors for the central subspace of estimated
%    dimension.
%    - d: estimated dimension under BIC.
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
%----checking type of response and slicing if needed.......................
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

%--- optimization .........................................................
[n,p] = size(X); 
%--- get handle to objective function and derivative ......................
Fhandle = F(@F4pfc,data_parameters);
dof = @(do) (r*do + do*(p-do) + p*(p+3)/2);
%----

[W,vals] = firsteigs(inv(SIGMAres)*SIGMA,p);

umax = min(r,p);
f = zeros(1,umax+1);
df = zeros(1,umax+1);
for u = 0:umax,
    if u==0,
        f(u+1) = n*p/2*(1 + log(2*pi)) + n/2*logdet(SIGMA);
    else
        f(u+1) = Fhandle(vals(1:u));
    end
    df(u+1) = dof(u);
end
d = bic(f,df,n);

fn = f(d+1);
if d>0
    Wn = W(:,1:d) ;
else
    Wn = zeros(p);
end


