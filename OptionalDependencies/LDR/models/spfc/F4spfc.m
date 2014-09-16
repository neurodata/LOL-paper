function f = F4spfc(D,FParameters,u)
%
% f = F4spfc(D,FParameters,u)
%
% This function computes the negative of the log-likelihood for the SPFC
% model. 
%
% Inputs:
%    - D: structured model for the covariance matrix.
%    - FParameters: structure of parameters computed from the sample. It
%    contains:
%          - FParameters.sigmag = marginal covariance matrix
%          - FParameters.n: sample size for each value of teh response Y.
%          - FParameters.Afit: covariance matrix of the fitted values of
%          the regression of the centered predictors onto a regression
%          basis fy.
%          - FParameters.r: number of columns in regression basis fy.
%     - u: dimension of the reduced subspace.
%
%==========================================================================
r = FParameters.r;
A = FParameters.sigmag;
n = sum(FParameters.n);
p = cols(A);
Afit = FParameters.Afit;
B = FParameters.B;
invsqrtm_D = invsqrtm(D);
auxr = invsqrtm_D*B*invsqrtm_D;
auxf = invsqrtm_D*Afit*invsqrtm_D;
if u==r,
    [vaur,aur] = firsteigs(auxr,p);      
    f = n*p/2*log(2*pi) + n/2*(logdet(D) + sum(aur));            
elseif u==0,
      [vecs,vals] = firsteigs(inv(D)*A,p);
      f = n*p/2*log(2*pi) + n/2*(logdet(D) + sum(vals));    
else
    [vau,au] = firsteigs(auxf,p);
    [vaur,aur] = firsteigs(auxr,p); 
    f = n*p/2*log(2*pi) + n/2*(logdet(D) + sum(aur) + sum(au((u+1):min(r,p))));
end
