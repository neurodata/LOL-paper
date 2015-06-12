function [Wmin,d,fmin] = permCORE(Yaux,X,morph,parameters)
%
% function [Wmin,d,f] = permLAD(Y,X,morph,parameters);
% 
% This function estimates the dimension of the reduced subspace that best
% describes the data under the CORE model using a permutation test.  
% 
% USAGE:
%  - outputs:
%    - Wmin: generating vectors for the central subespace of estimated
%    dimension.
%    - d: estimated dimension under LRT.
%    - f: value of the optimized function for dimension d. (perhaps this is useless)
%  - inputs: 
%    - Y: response vector;
%    - X: matrix of predictors;
%     morph: 'cont' for continuous responses or 'disc' for discrete
%     responses.
%     parameters (OPTIONAL): structure to set specific values of parameters for
%     computations. 
%           - parameters.nslices: number of slices for discretization of
%           continuous responses. % 5 slices are used by default.
%           - parameters.alpha: test level. Default is 0.05.
%           - parameters.npermute: number of permutations of the sample.
%           Default value is 500 permutations.
%           - parameters.sg: optional parameters for sg_min (see sg_min 
%           documentation for details).
%
%
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

% ---- main process............................................................
h = parameters.nslices;
[n,p] = size(X);
data_parameters = setdatapars(Y,X,h);

%--- get handle to objective function, derivative, dof ......................
F0handle = F(@F4core,data_parameters);
dF0handle = dF(@dF4core,data_parameters);

fpo = F0handle(eye(p));
for u=1:p-1.
    guess = get_initial_estimate(Y,X,u,data_parameters,parameters);
    Wo = guess(F0handle);
    [fno,Wu] = sg_min(F0handle,dF0handle,Wo,'prcg','euclidean',{1:u},'quiet');
    T = 2*(fno-fpo);
    [Q R] = qr(Wu); 
    Wu0 = Q(:,(u+1):p);
    Xnew = X*[Wu Wu0];
    Xrsp = zeros(n,p);
    fns = 1:nsample;
    fps = 1:nsample;
    for i=1:nsample,
        YY = randperm(n); 
        Xrsp(:,1:u) = Xnew(:,1:u);
        Xrsp(:,(u+1):p) = Xnew(YY(:),(u+1):p);
        newpars = setdatapars(Y,Xrsp(:,:),h);
        Fnew = F(@F4core,newpars);
        dFnew = dF(@dF4core,newpars);
        fps(i) = Fnew(eye(p));
        guessnew = get_initial_estimate(Y,X,u,newpars,parameters);
        Wo = guessnew(Fnew);
        fns(i) = sg_min(Fnew,dFnew,Wo,'prcg','euclidean',{1:u},'quiet',parameters.maxiter);
    end
    fnmfp = 2*(fns - fps);
    prop = sum(fnmfp > T);
    aux = prop/nsample;
    if (aux > (alpha))||(u==p-1),
        d = u;
        [Wmin,fmin] = core(Y,X,d,morph,parameters);
        break;
    end
end


