function [WX,W] = pc(X,u,var)
% [WX,W] = pc(X,u,var)
% This function performs dimensionality reduction by principal components.
% USAGE:
%   - outputs:
%     WX: projection of the predictors onto the central subspace.
%     W: generating vectors for the central subspace.
%   - inputs:
%     X: predictors matrix.
%     u: desired dimension for the central subspace.
%     var: argument used to choose between covariance-matrix principal 
%          components and correlation-matrix principal components. Allowed 
%          values are:
%           'cov': for covariance principal components,
%           'cor': for correlation principal components.
% 
% =========================================================================
if strcmpi(var,'cov'),
    sigma = get_cov(X);
    [W] = firsteigs(sigma,u);
elseif strcmpi(var,'cor'),
    sigma = get_cov(X);
    diagsigma = diag(diag(sigma));
    invsqrtsigma = invsqrtm(diagsigma);
    Xcent = zeros(size(X));
    for j=1:size(X,2),
        Xcent(:,j) = X(:,j) - mean(X(:,j));
    end
    Z = Xcent*invsqrtsigma;
    sigma = get_cov(Z);
    [V] = firsteigs(sigma,u);
    W = invsqrtsigma*V;
else
    error('Unknown third argument in pc.m');
end
WX = X*W;
    
    
    
    