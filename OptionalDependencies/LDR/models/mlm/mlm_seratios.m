function V = mlm_seratios(Y,X,Gamma);
% V = mlm_seratios(Y,X,Gamma)
% Returns the matrix of ratios of standard errors 
% of the elements of beta-hat.  The ratios are 
% (full modes se's)/(envelope model se's).
% Gamma comes from a prior run of mlm_fit.
%============================================
[n,p] = size(X);
R = rand(n,1);
Vbeta = mlm_fmses(Y,X);
Vbetaem = mlm_emses(Y,X,Gamma);
V= Vbeta./Vbetaem;
