function out = get_task_stats(Yhats,Y)
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


for j=1:length(Yhats)
    siz=size(Yhats{j});
    if prod(siz)==max(siz) % check if we embedded into multiple different dimensions
        out(j,1) = get_stats(Yhats{j}',Y);
    else
        for jj=1:siz(1)
            out(j,jj) = get_stats(Yhats{j}(jj,:)',Y);
        end
    end
end