function out = get_task_stats(Yhat,Y)
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

out.Lhat    = sum(Yhat~=Y)/n;         % compute misclassification rate
out.TP      = sum((Yhat==Y) & Y==1);
out.TN      = sum((Yhat==Y) & Y==0);
out.FP      = sum((Yhat~=Y) & Y==0);
out.FN      = sum((Yhat~=Y) & Y==1);

out.sensitivity = out.TP/(out.TP+out.FN);
out.specificity = out.TN/(out.TN+out.FP);
out.accuracy    = 1-out.Lhat;
