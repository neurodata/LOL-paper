function Vbeta = mlm_fmses(Y,X);
% Vbeta = mlm_fmses(Y,X)
% Returns the matrix of standard errors of the elements of 
% beta-hat from the fit of the full multivariate linear model.
% ==========================================================
[beta,S,Sfit,Sres] = mlm_fmpars(Y,X);
Sxinv = inv(get_cov(X));
r = size(Y,2);
p = size(X,2);
Ir = eye(r);
Ip = eye(p);
Vbeta = zeros(r,p);
for i=1:r
   for j=1:p
      ei = Ir(:,i);
      ej = Ip(:,j);
      ti = ei'*Sres*ei;
      tj = ej'*Sxinv*ej;
      Vbeta(i,j) = (ti*tj)^.5;
   end
end
