function [Proj, W] = LDAoPCA_train(X,Y,V)
% train Low Rank Linear Discriminant Analysis Classifier
% 
% INPUT:
%   X \in R^{D x n}: predictor matrix
%   Y \in R^n: predictee vector
%   V \in R^{d x D}: projection matrix
% 
% OUTPUT:
%   Proj \in R^{d x D}: projection matrix
%   W \in R^{2 x D}: linear classifier projector

Proj = V;
features = Proj*X;
W = LDA_train(features',Y);       % estimate LDA discriminating boundary from training data
