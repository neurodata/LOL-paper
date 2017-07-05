function [Wmin,d,f] = bicLAD(Yaux,X,morph,parameters)
%[Wmin,d,f] = bicLAD(Y,X,morph,parameters);
% 
% This function estimates the dimension of the central subspace that best
% describes the data under the LAD model using Bayes information criterion.
% USAGE:
%  - outputs:
%    - Wmin: generating vectors for the central subspace of estimated
%    dimension.
%    - d: estimated dimension under BIC.
%    - f: value of the optimized function for dimension d. (perhaps this is useless)
%  - inputs: 
%    - Y: response vector;
%    - X: matrix of predictors;
%     morph: 'cont' for continuous responses or 'disc' for discrete
%     responses.
%     parameters (OPTIONAL): structure to set specific values of parameters for
%     computations. 
%           - parameters.nslices: number of slices for discretization of
%           continuous responses.
%           - parameters.sg: optional parameters for sg_min (see sg_min 
%           documentation for details)
%
% =========================================================================
%----checking type of response and slicing if needed.......................
if strcmpi(morph,'disc'),
    Y = mapdata(Yaux);
    parameters.nslices = max(Y);
else % morph = 'cont'
    if parameters.nslices==0,
        warning('MATLAB:slices','for continuous responses, a number of slices should be given. Five slices will be used');
        parameters.nslices = 5;
    end
    Y = slices(Yaux,parameters.nslices);
end


% ---- main loop............................................................
h = parameters.nslices;
[n,p] = size(X);
data_parameters = setdatapars(Y,X,h);
sigmag = data_parameters.sigmag; 
%--- get handle to objective function, derivative, dof ......................
Fhandle = F(@F4lad,data_parameters);
dFhandle = dF(@dF4lad,data_parameters);
dof = @(do) (p+(h-1)*do+do*(p-do)+(h-1)*do*(do+1)/2 + p*(p+1)/2);
f0 = n*p*(1+log(2*pi))/2 + n*logdet(sigmag)/2;

ic_choose = icloop(Fhandle,dFhandle,f0,dof,Y,X,data_parameters,parameters);
d = ic_choose('bic');

if d>0,
    [Wmin,f] = lad(Y,X,d,morph,parameters);
else
    f = f0;
    Wmin = zeros(p);
end
