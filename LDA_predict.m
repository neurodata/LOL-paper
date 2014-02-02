function Yhat = LDA_predict(X,W)

[n, ~] =size(X);

score   = [ones(n,1) X] * W';               % project projected test data onto discriminating hyperplane
Yhat    = score(:,1) < score(:,2);  % estimate Y
