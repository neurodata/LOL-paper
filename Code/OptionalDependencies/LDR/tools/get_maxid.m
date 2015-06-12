function [D L] = get_maxid(F,u,FParameters)
%
% [D L] = get_maxid(F,u,FParameters)
%
% This is an auxiliary function for iterative estimation of the central
% subspace under the Structured Principal Fitted Components (SPFC) model.
%
% D: estimate of marginal covariance matrix.
% L: minus the log likelihood of the SPFC model for given matrix D and
% dimension u.
%
% Inputs:
%   - F: handle to objective function for the SPFC model.
%   - u: dimension of the desired reduced subspace.
%   - FParameters: structure with basic statistics from the sample being
%   used to fit the model:
%           - FParameters.sigmag: sample marginal covariance matrix.
%           - FParameters.Afit: covariance matrix of teh fitted values from
%           the regression of the predictors onto a basis fy.
% 
% =========================================================================
   r = FParameters.r; 
   sig = FParameters.sigmag;
   sigf = FParameters.Afit;
   p = cols(sigf);
   if u > p,
       error('You are trying to find a subspace bigger than the original one!!');
   end
   if u==0,
       D = diag(diag(sig));
       L = F(D,u);
   else
       sigr = sig-sigf;
       D=diag(diag(sigr));
       L = F(D,u);
       deltaL = 0.1;
       mblock = @(mtx)(mtx((u+1):min(r,p),(u+1):min(r,p)));
       vblock = @(vec)(vec(:,(u+1):min(r,p)));
       if r~=u,
        while deltaL > 0.01,
           L0 = L;
           D2 = sqrtm(D);
           DD2 = invsqrtm(D);
           Auxx = sigf;
           Aux = DD2*Auxx*DD2;
           [uu l] = firsteigs(Aux); l=diag(l);
           uu = vblock(uu);
           l = mblock(l);
           D = diag(diag(sigr + D2*((uu)*l)*(uu)'*D2));
           L = F(D,u);
           deltaL = abs((L-L0)/L0);
        end
       end
   end
