function Risk = get_risk(delta,Sig)

Risk=1-normcdf(0.5*sqrt(delta'*(Sig\delta)));
