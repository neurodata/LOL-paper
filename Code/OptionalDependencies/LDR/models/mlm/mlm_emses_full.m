function Vbeta = mlm_emses_full(Y,X,Gamma);
% This is an alternate way to comute standard errors for the
% envelope model, which was used for checking only.
% ===========================================
[beta,S,Sfit,Sres] = mlm_fmpars(Y,X);
[betaem,eta,Omega,Omega0,S1,S2] = mlm_empars(Y,X,Gamma);
Sx = get_cov(X);
Sxinv = inv(Sx);
Gamma0 = mlm_Gamma0(Gamma);
u = size(Gamma,2);
r = size(Y,2);
p = size(X,2);
Ir = eye(r);
Ip = eye(p);
Vbeta = zeros(r,p);
HJHinv = inv(kron(eta*Sx*eta',inv(Omega0)) + kron(Omega,inv(Omega0)) + kron(inv(Omega),Omega0) - 2*eye(u*(r-u)));
for i=1:r
   for j=1:p
      ei = Ir(:,i);
      ej = Ip(:,j);
      Aj = ej'*Sxinv*ej;
      Ai = ei'*S1*ei;
      Bij = kron(eta*ej,Gamma0'*ei);
      Vbeta(i,j) = (Ai*Aj + Bij'*HJHinv*Bij)^.5;
   end
end
