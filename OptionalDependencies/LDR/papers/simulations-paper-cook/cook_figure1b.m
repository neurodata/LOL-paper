%%% This is Figure 1b from R. D. Cook paper: Fisher Lecture: Dimension
%%% Reduction in Regression. Statist. Sci. Volume 22, Number 1 (2007), 1-26
%
% BRIEF DESCRIPTION
% This script aims at comparing PFC to PC and OLS. Figure displays average simulation 
% angles between the estimated subspace and the true dimension reduction subspace as a 
% function of σY with n = 40, σ = 1. See the paper for details.


clear all;
setpaths; % adds all directories in the LBDR package to MATLAB's path. 

nrows=40;
sig=1;
sigyy=[0.1:0.2:10];
ncols=10; nreps=200; u=1;
ang=zeros(3,length(sigyy),nreps);

for k=1:length(sigyy)
    disp(['k = ' int2str(k)]);
    sigy=sigyy(k);
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
  
angmean=zeros(3,length(sigyy));

for k=1:length(sigyy)
   for p=1:3
     angmean(p,k) = mean(ang(p,k,:) );
   end
end

plot(sigyy,squeeze(angmean(1,:)),'-',sigyy,squeeze(angmean(2,:)),'-',sigyy,squeeze(angmean(3,:)),'-')
title('Figure 1. (b) Angle vs sigma_Y');
ylabel('Angle'); xlabel('\sigma_{Y}');
ylim([0 80]);
 
legend('PC','PFC','OLS');
 
 
