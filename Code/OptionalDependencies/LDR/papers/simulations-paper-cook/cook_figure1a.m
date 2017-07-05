%%% This script is to reproduce Figure 1a from R. D. Cook paper: Fisher Lecture: Dimension
%%% Reduction in Regression. Statist. Sci. Volume 22, Number 1 (2007), 1-26
%
% BRIEF DESCRIPTION
% This script aims at comparing PFC to PC and OLS. Figure displays average simulation 
% angles between the estimated subspace and the true dimension reduction subspace as a 
% function ofsample size with σY = σ = 1. See the paper for details.


clear all;
setpaths; % adds all directories in the LBDR package to MATLAB's path. 

ncols=10; nreps=100; u=1;
nrows=12:25:250;
sig=1;
sigy=1;
ang=zeros(3,length(nrows),nreps);

for k=1:length(nrows)
     disp(['k = ' int2str(k)]);
     for j=1:nreps
         Y=zeros(nrows(k),1);
         X=zeros(nrows(k),ncols);
         for hh=1:nrows(k)
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

angmean=zeros(3,length(nrows));
  
for k=1:length(nrows)
   for p=1:3
     angmean(p,k) = mean(ang(p,k,:) );
   end
end

plot(nrows,squeeze(angmean(1,:)),'-',nrows,squeeze(angmean(2,:)),'-',nrows,squeeze(angmean(3,:)),'-')
title('Figure 1. (a) Angle vs n');
ylabel('Angle'); xlabel('n');
ylim([0 80]);
% labels
legend('PC','PFC','OLS');
 

 
