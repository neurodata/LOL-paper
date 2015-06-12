% #########################################################################
% This is Figure 3 from the paper by Cook, R. D. and Forzani, L. (2009). 
% Principal fitted components in regression. Statistcal Science 23 (4), 485-501.
% #########################################################################
%
% BRIEF DESCRIPTION
% This script aims at studying inference on the dimension of the smallest
% dimension reduction subspace under the PFC model as a function of the
% number of predictors p and the choice of regression basis to fit the
% centered predictors. See the paper for details.
% -------------------------------------------------------------------------


ncols=[5 10 15 20 30 40 50 60 70 80]; nreps=100;
nrows=200;
compang_pfc_lrt=zeros(nreps,length(ncols),2);
compang_pfc_aic=zeros(nreps,length(ncols),2);
compang_pfc_bic=zeros(nreps,length(ncols),2);

for pp=1:length(ncols)
    pp
	 alp = zeros(ncols(pp),2);
    alp(1,1)=1;
    alp(2,1)=1;
    alp(3,1)=-1;
	 alp(4,1)=-1;
	 alp(1,2)=1;
	 alp(3,2)=1;
	 alp(5,2)=1;
	 alp(:,1)=alp(:,1)/sqrt(4);
	 alp(:,2)=alp(:,2)/sqrt(3);
	 r=[3 10];
 
    for j=1:nreps
		A=normrnd(0,1,ncols(pp),ncols(pp));
		D0=A'*A;
      sig=2;
		X=zeros(nrows,ncols(pp));
		Y=normrnd(0,sig,nrows,1);
		v_y=[Y - mean(Y), abs(Y)-mean(abs(Y))];
		for (i=1:nrows)
			ep=mvnrnd(zeros(ncols(pp),1),D0);
			X(i,:)=alp*(v_y(i,:))' + ep';
		end
		for hh=1:2	
            FF = get_fy(Y,r(hh),'abs');
            [WX,W,f,dd] = ldr(Y,X,'PFC','cont','lrt','fy',FF);
            compang_pfc_lrt(j,pp,hh)=dd;
	   		[WX,W,f,dd] = ldr(Y,X,'PFC','cont','aic','fy',FF);
            compang_pfc_aic(j,pp,hh)=dd;
		   	[WX,W,f,dd] = ldr(Y,X,'PFC','cont','bic','fy',FF);
            compang_pfc_bic(j,pp,hh)=dd;
		end
	end
end 

pfc_lrt=[]
pfc_aic=[]
pfc_bic=[]
% --------------------------Figure 3a--------------------------------------
for k=1:length(ncols)
   pfc_lrt(k)=sum(compang_pfc_lrt(:,k,1)==2)/(nreps);
	pfc_aic(k)=sum(compang_pfc_aic(:,k,1)==2)/(nreps);
	pfc_bic(k)=sum(compang_pfc_bic(:,k,1)==2)/(nreps);
end
figure(1);
plot(ncols,pfc_aic,'*')
hold on
plot(ncols,pfc_bic,'-')
plot(ncols,pfc_lrt,'.')
title('r=3');
xlabel('p');
ylabel('F(2)');
legend('AIC','BIC','LRT','Location','NorthEastOutside');
hold off

% -------------------------Figure 3c---------------------------------------
figure(2);
for k=1:length(ncols)
    pfc_lrt(k)=(sum(compang_pfc_lrt(:,k,1)==2)+sum(compang_pfc_lrt(:,k,1)==3))/(nreps);
    pfc_aic(k)=(sum(compang_pfc_aic(:,k,1)==2)+sum(compang_pfc_aic(:,k,1)==3))/(nreps);
    pfc_bic(k)=(sum(compang_pfc_bic(:,k,1)==2)+sum(compang_pfc_bic(:,k,1)==3))/(nreps);
end
plot(ncols,pfc_aic,'*')
hold on
plot(ncols,pfc_bic,'-')
plot(ncols,pfc_lrt,'.')
title('r=3');
xlabel('p');
ylabel('F(2,3)');
legend('AIC','BIC','LRT','Location','NorthEastOutside');
hold off

% -------------------------Figure 3b---------------------------------------
for k=1:length(ncols)
    pfc_lrt(k)=sum(compang_pfc_lrt(:,k,2)==2)/(nreps);
    pfc_aic(k)=sum(compang_pfc_aic(:,k,2)==2)/(nreps);
    pfc_bic(k)=sum(compang_pfc_bic(:,k,2)==2)/(nreps);
end
figure(3);
plot(ncols,pfc_aic,'*')
hold on
plot(ncols,pfc_bic,'-')
plot(ncols,pfc_lrt,'.')
title('r=10');
xlabel('p');
ylabel('F(2)');
legend('AIC','BIC','LRT','Location','NorthEastOutside');
hold off

% -------------------------Figure 3 d--------------------------------------
for k=1:length(ncols)
    pfc_lrt(k)=(sum(compang_pfc_lrt(:,k,2)==2)+sum(compang_pfc_lrt(:,k,2)==3)+sum(compang_pfc_lrt(:,k,2)==4))/(nreps);
    pfc_aic(k)=(sum(compang_pfc_aic(:,k,2)==2)+sum(compang_pfc_aic(:,k,2)==3)+sum(compang_pfc_aic(:,k,2)==4))/(nreps);
    pfc_bic(k)=(sum(compang_pfc_bic(:,k,2)==2)+sum(compang_pfc_bic(:,k,2)==3)+sum(compang_pfc_bic(:,k,2)==4))/(nreps);
end
figure(4);
plot(ncols,pfc_aic,'*')
hold on
plot(ncols,pfc_bic,'-')
plot(ncols,pfc_lrt,'.')
title('r=10');
xlabel('p');
ylabel('F(2,3,4)');
legend('AIC','BIC','LRT','Location','NorthEastOutside');
hold off
