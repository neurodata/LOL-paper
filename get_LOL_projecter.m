function Proj = get_LOL_projecter(delta,V)
% 
% INPUT
%   X: R^{n x D} centered predictor matrix 
%   Y: R^n  : predictee vector 
%   k: R    : # of dimensions to embed into
% 
% OUTPUT:
%    Proj: R^{D x k} projector matrix 

    
[V_LOL, ~] = qr([delta,V(:,1:end-1)],0);           % TODO: should test for full rank
Proj = V_LOL';
