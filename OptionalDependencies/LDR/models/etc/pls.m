function [WX,W] = pls(Y,X,dim)
% [WX,W] = pls(Y,X,dim)
%
% This function implements dimension reduction in regression using Partial Least 
% Squares.
%
% - Outputs:
%      - WX: projection of the predictors onto the dimension reduction subspace.
%      - W: basis matrix for the dimension reduction subspace.
% - Inputs:
%      - Y: response vector.
%      - X: predictor matrix.
%      - dim: dimension of the reduced subspace.

W = pls4sdr(X,Y,dim);
WX = X*W;

