function Yhat = LOL_predict(X,Proj,W)
% make predictions using LOL
% 
% INPUT:
%   X \in R^{D x ntest}: predictor matrix
%   Proj \in R^{d x D}: projection matrix
%   W \in R^{2 x d}: linear classifier projector
% 
% OUTPUT:
%   Yhat \in {0,1}^ntest: predictions
test_features = Proj*X;
Yhat = LDA_predict(test_features',W);    % predict

