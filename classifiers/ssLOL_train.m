function Proj = ssLOL_train(X,Y,varargin)
% train semi-supervised Low Rank Linear Discriminant Analysis Classifier
%
% INPUT:
%   X in R^{D x n}: predictor matrix
%   Y in R^n: predictee vector
%   varargin: two options
%   if nargin == 1, then
%       k: projection matrix dimension
%   else nargin == 2
%       delta in R^D: mu_0 - mu_1
%       V in R^{d x D}: projection matrix
%   end
%
% OUTPUT: Proj in R^{d x D}: projection matrix

if nargin==3
    Phat = estimate_parameters(X,Y,varargin{1});
    delta = Phat.delta;
    V = Phat.V;
else
    delta = varargin{1};
    V = varargin{2};
end

k=size(V,1);
nl=length(find(Y==0))+length(find(Y==1));
n=length(Y);

if k<n/nl
    [V_LOL, ~] = qr([delta';V(1:end-1,:)]',0);
else
    k2=round(n/nl);
    [V_LOL, ~] = qr([V(1:k2-1);delta';V(k2:end-1,:)]',0);
end
Proj = V_LOL';