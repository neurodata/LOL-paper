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

end

function out = get_stats(Yhat,Y)

n=length(Y);

out.Lhat    = sum(Yhat~=Y)/n;         % compute misclassification rate
out.TP      = sum((Yhat==Y) & Y==1);
out.TN      = sum((Yhat==Y) & Y==0);
out.FP      = sum((Yhat~=Y) & Y==0);
out.FN      = sum((Yhat~=Y) & Y==1);

out.sensitivity = out.TP/(out.TP+out.FN);
out.specificity = out.TN/(out.TN+out.FP);
out.accuracy    = 1-out.Lhat;

% if Yhat is all NaN, output should be all NaN
if all(isnan(Yhat))
    names = fieldnames(out);
    for i=1:length(names)
        out.(names{i})=NaN;
    end
end

end