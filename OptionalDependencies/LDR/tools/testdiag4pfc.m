function isdiagonal = testdiag4pfc(Yaux,X,morph,aa,FF)
% function isdiagonal = testdiag4pfc(Y,X,morph,r,aa)
%  USAGE:
%   - Output:
%      isdiagonal: boolean set to TRUE when a diagonal structure is more 
%      probable.
%   - Inputs:
%       Y: response vector;
%       X: array of predictors;
%       morph: 'cont' or 'disc' to indicate a continuous or a discrete
%       response Y.
%       aa: confidence vale for testing;
%       FF: a basis matrix for regression
% =========================================================================
% 
if nargin < 3,
    error('not enough input arguments');
end
if nargin < 4,
    aa = 0.05;
end
if nargin < 5,
    parameters.fy = [];
else
    parameters.fy = FF;
end
    

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
    

%--- get handle to objective function ......................
F_pfc = F(@F4pfc,data_parameters);
F_spfc = F(@F4spfc,data_parameters);

p = cols(X);
s = min(r,p);

%-----------------------------------------------------------
% likelihood from PFC:
[A,vals] = firsteigs(inv(SIGMAres)*SIGMA,s);
fpfc = F_pfc(vals); 
% likelihood from spfc
[D fspfc] = get_maxid(F_spfc,s,data_parameters);

T = 2*(fspfc - fpfc);
df = p*(p-1)/2;
if chi2cdf(T,df) < (1-aa)
    isdiagonal = true;
else
    isdiagonal = false;
end
     
