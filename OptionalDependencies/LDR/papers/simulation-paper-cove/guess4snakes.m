function Y = guess4snakes(F,u,FParameters,opt)
% Y = guess4snakes(F,u,FParameters,opt)
%
% This is a function specially implemented to run this example. It is
% necessary due to the inputs being the covariance matrices instead of data
% matrices.
% Function returns an initial estimate of a basis matrix for a dimension
% reduction subspace that is then used by SG_MIN to find an optimal
% estiamte under the CORE model.
%

% ========================================================================

Ys = valin4snakes(u,FParameters,opt);
imax = size(Ys,1);
m = size(Ys,2);
n = size(Ys,3);
Fvalue = zeros(1,imax);
for i=1:imax,
    Fvalue(i) = F(reshape(Ys(i,:,:),m,n));
end
minIndex = argmin(Fvalue);
Y = reshape(Ys(minIndex,:,:),m,n);
% ================================================================================

function [val]= valin4snakes(u,FParameters,opt)
%----read parameters-------------------------------------------------------
sigmas = FParameters.sigma;
sigmag = FParameters.sigmag;
n=FParameters.n;
p = cols(sigmag);
h = size(sigmas,1);
W = zeros(p);
V = zeros(p);
if opt==1,
    for g=1:h,
       Wg = inv(sigmag)*(squeeze(sigmas(g,:,:)) - sigmag)*inv(sigmag);
       W = W +  Wg*Wg;
       Vg = eye(p) -  invsqrtm(sigmag)*squeeze(sigmas(g,:,:))*invsqrtm(sigmag);
       V = V +  Vg*Vg;
    end
else
    for g=1:h,
       Wg = inv(sigmag)*(squeeze(sigmas(g,:,:)) - sigmag)*inv(sigmag);
       W = W + n(g)/sum(n)*Wg*Wg;
       Vg = eye(p) - n(g)/sum(n)*invsqrtm(sigmag)*squeeze(sigmas(g,:,:))*invsqrtm(sigmag);
       V = V + n(g)/sum(n)*Vg*Vg;
    end
end
val = zeros(2,p,u);
val(1,:,:) = firsteigs(W,u);
val(2,:,:) = firsteigs(V,u);
