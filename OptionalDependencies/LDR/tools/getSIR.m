function [SIRdir,sir] = getSIR(u,auxmtx)
% -------------------------------------------------------------
% function [SIRdir,sir] = getSIR(u,p);
% 
% This function computes the generating vectors for a reduced
% subspace R^u contained in the original space R^p according
% to the SIR method.
% 
% TAKE CARE of using SETAUX before using this function.
% 
% ------------------------REFERENCES---------------------------
% Li, K. C. (1991). Sliced inverse regression for dimension reduction (with discussion).
%      Journal of the American Statistical Association 86, 316–342.
% -------------------------------------------------------------
sir = auxmtx.mat2;
nsqrtx = auxmtx.nsqrtx;
S1 = firsteigs(sir,u);
sir = nsqrtx*S1;
SIRdir = orth(sir);
