function [SAVEdir,Save] = getSAVE(u,p,auxmtx)
% -------------------------------------------------------------
% function [SAVEdir,Save] = getSAVE(u,p)
% 
% This function computes the generating vectors for a reduced
% subspace R^u contained in the original space R^p according
% to the SAVE method.
% 
% TAKE CARE of using SETAUX before using this function.
% 
% -------------------------- REFERENCES ----------------------
% Cook, R. D. and Weisberg, S. (1991). Discussion of 'Sliced inverse regression' by
%    K. C. Li. Journal of the American Statistical Association 86, 328--332.
% -------------------------------------------------------------

mat1 = auxmtx.mat1;
mat2 = auxmtx.mat2;
mat4 = auxmtx.mat4;
mat5 = auxmtx.mat5;
nsqrtx = auxmtx.nsqrtx;

Save = mat1 - eye(p) - mat4 - mat4' + 2*mat2 + mat5;
S3 = firsteigs(Save,u);
Save = nsqrtx*S3;
SAVEdir = orth(Save);
