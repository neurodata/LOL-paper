function [DRdir,dr] = getDR(u,p,auxmtx)
% 
% [DRdir,sir] = getDR(u,p);
% 
% This function computes the generating vectors for a reduced
% subspace R^u contained in the original space R^p according
% to the DR method.
% 
% TAKE CARE of using SETAUX before using this function.
% 
% -----------------------REFERENCES----------------------------
% Li, B. and Wang S. (2007). On directional regression for dimension reduction. 
%      Journal of American Statistical Association 102, 997–1008.
% 
% -------------------------------------------------------------

nsqrtx = auxmtx.nsqrtx;
mat1 = auxmtx.mat1;
mat2 = auxmtx.mat2;
mat3 = auxmtx.mat3;

dr = 2*mat1 + 2*mat2*mat2 + 2*mat3*mat2 - 2*eye(p);
S5 = firsteigs(dr,u);
dr = nsqrtx*S5; 
DRdir = orth(dr);


