% #########################################################################
% This is the script to reproduce the example with garter snakes data in 
% Section 7 from the paper by R. D. Cook and L. Forzani: "Covariance 
% reducing models: An alternative to spectral modelling of covariance 
% matrices"; Biometrika 2008 95(4):799-812.
% Please, see the paper for details.
% #########################################################################

%------- Load conditional covariance matrices ---------%
clear all;
%setpaths;
sigma1=load('snake1.txt');
sigma2=load('snake2.txt');
p=cols(sigma1);
sigmas = zeros(2,p,p);
sigmas(1,:,:)=sigma1;
sigmas(2,:,:)=sigma2;
n1=138; n2=89;
n=[n1 n2];
h=2;

%----Computes average covariance matrix
sigmag = (n1*sigma1 + n2*sigma2)/sum(n);

%----Sets parameters for further processing.................................
pars.sigmag = sigmag;
pars.sigma = sigmas;
pars.n = n;
pars.model = 'CORE';


%----Optimizes----------------------------------------------------------
Fhandle = F(@F4core,pars);
dFhandle = dF(@dF4core,pars);
dof = @(do) (p*(p+1)/2+do*(p-do)+(h-1)*do*(do+1)/2);
dofCHI2 = @(x) (h*p*(p+1)/2 - x);
f0 = 0;
fp = Fhandle(eye(p));

f=zeros(1,p+1);
df=zeros(1,p+1);
dfchi2 = zeros(1,p+1);
for u=0:p, 
    if u==0,
        f(u+1)=f0;
    elseif u<p,
        Wo = guess4snakes(Fhandle,u,pars,1);
        [f(u+1) Wu] = sg_min(Fhandle,dFhandle,Wo,'prcg','euclidean',{1:u},'quiet');
    else
        f(u+1) = fp;
    end
    df(u+1) = dof(u); 
    dfchi2(u+1) = dofCHI2(df(u+1));
end

%%lrt
pp = zeros(1,p+1);
chic = 2*(f-fp)
for u=0:p-1,
    pp(u+1) = 1-chi2cdf(chic(u+1),dfchi2(u+1));
end
disp(strcat('The p value for d=0 is  ',num2str(pp(1))));
disp(strcat('The p value for d=1 is  ',num2str(pp(2))));
disp(strcat('The p value for d=2 is  ',num2str(pp(3))));

%%aic
daic = aic(f,df);
disp(strcat('AIC choose d=  ',num2str(daic)));

%%bic
dbic = bic(f,df,sum(n));
disp(strcat('BIC choose d=  ',num2str(dbic)));


%%

% SECOND PART OF SNAKES EXAMPLE

pars.model = 'EN_CORE';


%----Optimizes----------------------------------------------------------
FENhandle = F(@F4EN_core,pars);
dFENhandle = dF(@dF4EN_core,pars);
dof = @(do) (do*(p-do)+h*do*(do+1)/2+(p-do)*(p-do+1)/2);
dofCHI2 = @(x) (h*p*(p+1)/2 - x);
f0 = 0;
fp = FENhandle(eye(p));

f=zeros(1,p+1);
df=zeros(1,p+1);
dfchi2 = zeros(1,p+1);
for u=0:p, 
    if u==0,
        f(u+1)=f0;
    elseif u<p,
        Wo = guess4snakes(Fhandle,u,pars,0);
        [f(u+1) Wu] = sg_min(FENhandle,dFENhandle,Wo,'prcg','euclidean',{1:u},'quiet');
    else
        f(u+1) = fp;
    end
    df(u+1) = dof(u); 
    dfchi2(u+1) = dofCHI2(df(u+1));
end

%%lrt
pp = zeros(1,p);
chic = 2*(f-fp)
for u=0:p-1,
    pp(u+1) = 1-chi2cdf(chic(u+1),dfchi2(u+1));
end
disp(strcat('The p value for d=0 is  ',num2str(pp(1))));
disp(strcat('The p value for d=1 is  ',num2str(pp(2))));
disp(strcat('The p value for d=2 is  ',num2str(pp(3))));

%%aic
daic = aic(f,df);
disp(strcat('AIC choose d=  ',num2str(daic)));

%%bic
dbic = bic(f,df,sum(n));
disp(strcat('BIC choose d=  ',num2str(dbic)));


