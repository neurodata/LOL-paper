function [Proj, W] = LOL_train(X,Y,varargin)
% train Low Rank Linear Discriminant Analysis Classifier
% 
% INPUT:
%   X \in R^{D x n}: predictor matrix
%   Y \in R^n: predictee vector
%   varargin: two options
%   if nargin == 1, then 
%       k: projection matrix dimension
%   else nargin == 2
%       delta \in R^D: mu_0 - mu_1
%       V \in R^{d x D}: projection matrix
%   end
% 
% OUTPUT:
%   Proj \in R^{d x D}: projection matrix
%   W \in R^{2 x D}: linear classifier projector

if nargin==3
    Phat = estimate_parameters(X,Y,varargin{1});
    delta = Phat.delta;
    V = Phat.V;
else
    delta = varargin{1};
    V = varargin{2};
end

[V_LOL, ~] = qr([delta';V(1:end-1,:)]',0);           
Proj = V_LOL';
features = Proj*X;
W = LDA_train(features',Y);       % estimate LDA discriminating boundary from training data
