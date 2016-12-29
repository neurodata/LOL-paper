function Lhat_interp = lasso_interp(kk,ll,ks)

%% add a bit of noise to make interpolation work
len=length(kk);
err=rand(len,1)*0.01;
err=sort(err);
kk=kk+err;

%% actually inter
Lhat_interp=interp1(kk,ll,ks);
