function [betaem,eta,Omega,Omega0,S1,S2] = mlm_empars(Y,X,Gamma);
% [betaem,eta,Omega,Omega0,S1,S2] = mlm_empars(Y,X,Gamma)
% Returns the parameters from the fit of the envelope model.  
% The argument Gamma comes from a prior run of mlm_fit
% betaem = Gamma x eta is the estimated coefficient matrix
% Omega and Omega0 are the Omegas as in the paper.
[betafm,S,Sfit,Sres]=mlm_fmpars(Y,X);
Gamma0 = mlm_Gamma0(Gamma);
[n,p] = size(X);
eta = Gamma'*betafm;
Omega0 = Gamma0'*S*Gamma0;
Omega =  Gamma'*Sres*Gamma;
betaem = Gamma*eta;
S1 = Gamma*Omega*Gamma';
S2 =  Gamma0*Omega0*Gamma0';
