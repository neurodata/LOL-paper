function Phat = estimate_parameters(X,Y,k)


Phat.mu = mean(X,2);
Phat.delta=(mean(X(:,Y==0),2)-mean(X(:,Y==1),2));
X_centered = bsxfun(@minus,X,Phat.mu);
[~,Phat.d,V] = svd(X_centered',0);
Phat.V=V(:,1:k)';
