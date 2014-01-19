function out = LDA_accuracy(X,Y,W)
% projects onto LDA projection line and computes scores, Yhats, and Lhat
% 
% 
% INPUT:
%   X: predictors
%   Y: target
%   W: projection matrix
% 
% OUTPUT: a structure containing the following fields
%   score:          the magnitude of the test samples after being projected down onto the discriminating hyperplane
%   Yhat:           estimated classes
%   Lhat:           misclassification rate

n=length(Y);

out.score   = [ones(n,1) X] * W';               % project projected test data onto discriminating hyperplane
out.Yhat    = out.score(:,1)<out.score(:,2);  % estimate Y
out.Lhat    = sum(out.Yhat~=Y)/n;         % compute misclassification rate
out.median  = median(out.score(:,1)./out.score(:,2));
out.TP      = sum((out.Yhat==Y) & Y==1);
out.TN      = sum((out.Yhat==Y) & Y==0);
out.FP      = sum((out.Yhat~=Y) & Y==0);
out.FN      = sum((out.Yhat~=Y) & Y==1);

out.sensitivity = out.TP/(out.TP+out.FN);
out.specificity = out.TN/(out.TN+out.FP);
out.accuracy    = 1-out.Lhat;

out.Y = Y;

