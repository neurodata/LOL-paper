function Gamma0 = mlm_Gamma0(Gamma);
% Gamma0 = mlm_Gamma0(Gamma)
% Returns Gamma0 given Gamma
% ===========================
[r,u] = size(Gamma);
QGamma = eye(r) - Gamma*inv(Gamma'*Gamma)*Gamma';
Gamma0 = firsteigs(QGamma,r-u);
