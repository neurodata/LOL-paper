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