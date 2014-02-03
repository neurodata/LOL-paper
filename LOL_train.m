function [Proj, W] = LOL_train(X,Y,delta,V)
% train Low Rank Linear Discriminant Analysis Classifier
% 
% INPUT:
%   X \in R^{D x n}: predictor matrix
%   Y \in R^n: predictee vector
%   delta \in R^D: mu_0 - mu_1
%   V \in R^{d x D}: projection matrix
% 
% OUTPUT:
%   Proj \in R^{d x D}: projection matrix
%   W \in R^{2 x D}: linear classifier projector

[V_LOL, ~] = qr([delta';V(1:end-1,:)]',0);           
Proj = V_LOL';
features = Proj*X;
W = LDA_train(features',Y);       % estimate LDA discriminating boundary from training data
