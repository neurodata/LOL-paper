%%% This is Figure 2c from R. D. Cook paper: Fisher Lecture: Dimension
%%% Reduction in Regression. Statist. Sci. Volume 22, Number 1 (2007), 1-26
%
% It aims to compare likelihood-based estimates to other methods and to assess the 
% effect of initial candidates on the obtained estimate. In this subfigure,
% the PFC estimate is obtained from the PC candidate set. The average angle
% between the estimate and the true central subspace is taken as a measure
% of performance.
% We reproduce here OLS, SIR and the actual MLE in Grassmann manifold. 
% Therefore this picture it is a little different than the original one.

clear all;
setpaths; % adds all directories in the LBDR package to MATLAB's path. 

nrows=250;
sigg0=.2:.5:4.2;
sigy=1;
sig=1;
ncols=10; nreps=10; u=1;
ang=zeros(3,length(sigg0),nreps);

for k=1:length(sigg0)
    k
    sig0=sigg0(k);
    alp=zeros(ncols,1);
    alp(1)=1;
    alp0=[zeros(ncols-1,1)'
    eye(ncols-1)];
    for j=1:nreps
      Y=zeros(nrows,1);
      X=zeros(nrows,ncols);
      for hh=1:nrows
         Y(hh)=normrnd(0,sigy);
         t1 = normrnd(0,1);
         t0 = mvnrnd(zeros(ncols-1,1),eye(ncols-1));
         X(hh,:)=  (sig*alp*t1)'+(sig0*alp0*t0')'   + Y(hh)*alp';
      end
      FF = get_fy(Y,1);
      [WX,W]=SIR(Y,X,'cont',1,'nslices',8);
      ang(1,k,j)=subspace(W,alp)*180/pi;
      [W]=  regress(Y,X);
      ang(2,k,j)=subspace(W,alp)*180/pi;
      [WX,W]=ldr(Y,X,'EPFC','cont',1,'fy',FF);
      ang(3,k,j)=subspace(W,alp)*180/pi;
     end
end
  
angmean=zeros(3,length(sigg0));

for k=1:length(sigg0)
   for p=1:3
     angmean(p,k) = mean(ang(p,k,:) );
   end
end

plot(sigg0,squeeze(angmean(1,:)),'-',sigg0,squeeze(angmean(2,:)),'-',sigg0 ,squeeze(angmean(3,:)),'-')
% labels
legend('SIR','OLS','EPFC');
xlabel('\sigma_0'); ylabel('Angle');
ylim([0 53]);
title('Angle vs. \sigma_0');
