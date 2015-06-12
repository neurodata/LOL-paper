function [Wmin,d,f] = aicEPFC(Yaux,X,morph,parameters)
%[Wmin,d,f] = aicEPFC(Y,X,morph,parameters);
% 
% This function estimates the dimension of the central subspace that best
% describes the data under the EPFC model using Akaike's information criterion.
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
[n,p] = size(X);
umax = p-1;
% sliced response for initial estimate computation
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


if strcmpi(morph,'cont')
    [SIGMAfit,r] = get_fitted_cov(Y,X,parameters.fy);
else
    [SIGMAfit,r] = get_average_cov(X,data_parameters);
end
SIGMA = data_parameters.sigmag;
SIGMAres = SIGMA - SIGMAfit;
data_parameters.Afit = SIGMAfit;
data_parameters.B = SIGMAres;

%--- get handle to objective function and derivative ......................
Fhandle = F(@F4epfc,data_parameters);
dFhandle = dF(@dF4epfc,data_parameters);
dof = @(u)(r*u + p*(p+3)/2);
f0 = n*p/2 + n*p/2*log(2*pi);

ic_choose = icloop(Fhandle,dFhandle,f0,dof,Y,X,...
                    data_parameters,parameters,...
                    Ysliced,aux_datapars,auxpars);
d = ic_choose('aic');

if d>0,
    [Wmin,f] = epfc(Y,X,d,morph,parameters);
else
    f = f0;
    Wmin = zeros(p);
end
