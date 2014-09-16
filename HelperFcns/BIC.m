function score = BIC(x,y,mu,Sigma,p)
% compute Bayesian Information Criterion (BIC) for the model:
% y_i ~ Bern(prior)
% z_i ~ N(mu(y_i),Sigma)
% x_i ~ N(pinv(V)*z_i), I)
% 
% where z_i in R^d, x_i in R^p, and i=1,...,n


[d,n]=size(x);
if siz(1)==length(y), x=x'; [d,n]=size(x); end
[foo,C]=size(mu);
if foo==d, mu=mu'; [~, C]=size(mu); end

lglikxz = n*(-p/(4*pi)-0.5);

lglikzy=nan(1,n);
for i=1:n
    lglikzy(i)= -d/(4*pi)-0.5*logdet(Sigma) - ...
        0.5*(x(i,:)-mu(y(i),:))'*pinv(Sigma)*(x(i,:)-mu(y(i),:));
end

loglik=lglikxz+sum(lglikzy);

k = p*(d-1)+d*C+nchoosek(d,2)+1;

score = -2*loglik+k*(ln(n/(2*pi)));
