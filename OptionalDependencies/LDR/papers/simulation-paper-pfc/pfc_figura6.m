%%This is Figure 6 from the paper by R. D. Cook and L. Forzani: Principal Fitted 
% Components for Dimension Reduction in Regression. Statistica Science, 23 (4), 485-501.
%
% BRIEF DESCRIPTION
% This scripts aims to test if the covariance matrix is diagonal. The
% figure shows the fraction of runs the null hypothesis cannot be rejected
% as a function of the sample size. See the paper for details.

%-------------------------------------------------------------------------
clear all;
setpaths;
ncols=6; nreps=500; u=1;
nrows=[40:40:200];

tes6=zeros(nreps,length(nrows));
tes3=zeros(nreps,length(nrows));
tes1=zeros(nreps,length(nrows));

alp = ones(ncols,1);
    alp = alp/sqrt(ncols);
    Del=zeros(ncols,ncols);
    for hh=1:ncols
        Del(hh,hh)=10^(hh-1);
    end
    
for k=1:length(nrows)
    k
    for j=1:nreps
      Y=zeros(nrows(k),1);
      X=zeros(nrows(k),ncols);
      for hh=1:nrows(k)
         Y(hh) =normrnd(0,1);
         t1 = mvnrnd(zeros(ncols,1),Del);
         X(hh,:)=  t1'   + Y(hh)*alp;
      end
      FF = get_fy(Y,6);
	   tes6(j,k)=testdiag4pfc(Y,X,'cont',.05,FF);
	   FF = get_fy(Y,3);	
	   tes3(j,k)=testdiag4pfc(Y,X,'cont',.05,FF);
      FF = get_fy(Y,1);
      te1(j,k)=testdiag4pfc(Y,X,'cont',.05,FF);
	end
end 

te6=zeros(length(nrows),1);
te3=zeros(length(nrows),1);
te1=zeros(length(nrows),1);
for k=1:length(nrows)
    te6(k)=sum(tes6(:,k)==1)/nreps;
    te3(k)=sum(tes3(:,k)==1)/nreps;
    te1(k)=sum(tes1(:,k)==1)/nreps;    
end

plot(nrows,te1,'-',nrows,te3,'-',nrows,te6,'-')

xlabel('n');
ylabel('P');
title('Test of a Diagonal');
ylim([0.8 1])
legend('r=1','r=3','r=6','Location','SouthEast');
