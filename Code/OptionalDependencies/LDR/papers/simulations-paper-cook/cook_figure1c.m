%%% This is Figure 1c from R. D. Cook paper: Fisher Lecture: Dimension
%%% Reduction in Regression. Statist. Sci. Volume 22, Number 1 (2007), 1-26
%
% BRIEF DESCRIPTION
% This script aims at comparing PFC to PC and OLS. Figure displays average simulation 
% angles between the estimated subspace and the true dimension reduction subspace as a 
% function of σ with n = 40, σY = 1. See the paper for details.

setpaths; % adds all directories in the LBDR package to MATLAB's path. 

nrows=40;
sigg=.1:.2:5;
sigy=1;
ncols=10; nreps=200; u=1;
ang=zeros(3,length(sigg),nreps);

for k=1:length(sigg)
    disp(['k = ' int2str(k)]);
    sig=sigg(k);
    for j=1:nreps
      Y=zeros(nrows,1);
      X=zeros(nrows,ncols);
      for hh=1:nrows
         Y(hh)=normrnd(0,sigy);
         alp = zeros(ncols,1);
         alp(1) = 1;
         t1 = mvnrnd(zeros(ncols,1),eye(ncols));
         X(hh,:)=  sig*t1'   + Y(hh)*alp;
      end
      [WX,W]=pc(X,1,'cov');
      ang(1,k,j)=subspace(W,alp)*180/pi;
      FF = get_fy(Y,1);
      [WX,W] = ldr(Y,X,'IPFC','cont',1,'fy',FF);
      ang(2,k,j)=subspace(W,alp)*180/pi;
      [W]=  regress(Y,X);
      ang(3,k,j)=subspace(W,alp)*180/pi;
    end
end
  

angmean=zeros(3,length(sigg));
for k=1:length(sigg)
   for p=1:3
     angmean(p,k) = mean(ang(p,k,:) );
   end
end

plot(sigg,squeeze(angmean(1,:)),'-',sigg,squeeze(angmean(2,:)),'-',sigg,squeeze(angmean(3,:)),'-')
title('Figure 1. (c) Angle vs sigma');
ylabel('Angle'); xlabel('\sigma');
% labels
ylim([0 80]);
legend('PC','PFC','OLS');
