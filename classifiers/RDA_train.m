function [Proj, W] = RDA_train(X,Y,k)
% train Low Rank Linear Discriminant Analysis Classifier
% 
% INPUT:
%   X \in R^{D x n}: predictor matrix
%   Y \in R^n: predictee vector
%   k \in R: projection matrix dimension
% 
% OUTPUT:
%   Proj \in R^{d x D}: projection matrix
%   W \in R^{2 x D}: linear classifier projector

[D, ~] = size(X);

[V_RDA, ~] = qr(randn(D,k),0);
Proj=V_RDA';
features = Proj*X;
W = LDA_train(features',Y);       % estimate LDA discriminating boundary from training data
