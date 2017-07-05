% #########################################################################
% This is Figure 2 from the paper by Cook, R. D. and Forzani, L. (2009). 
% Principal fitted components in regression. Statistcal Science 23 (4), 485-501.
% The simulation takes a long time since it is choosing the
% dimension of the subspace.
% #########################################################################

% BRIEF DESCRIPTION
%This is a script to assess inference about the dimension of the
%smallest dimension reduction subspace under the PFC model. Figures show
%the fraction of the runs in which the true dimension is chosen using AIC, BIC 
% and LRT, versus the size of the sample.
%--------------------------------------------------------------------------

clear all;
setpaths;
ncols=5; nreps=200;  
nrows=[10 20 30 60 100 150 200 250 300 400];
A=normrnd(0,1,ncols,ncols);
D0=A'*A;
%--- initializing results--------------------------------------------------
compang_pcf_lrt=zeros(nreps,length(nrows));
compang_pcf_aic=zeros(nreps,length(nrows));
compang_pcf_bic=zeros(nreps,length(nrows));

%--- setting alpha matrix--------------------------------------------------
alp = zeros(ncols,2);
alp(1,1)=1;
alp(2,1)=1;
alp(3,1)=-1;
alp(4,1)=-1;
alp(1,2)=1;
alp(3,2)=1;
alp(5,2)=1;
alp(:,1)=alp(:,1)/sqrt(4);
alp(:,2)=alp(:,2)/sqrt(3);

%---- computting for sigma = 0.5, 1, 2, 5----------------------------------   
% initialize
pfc_lrt=zeros(1,length(nrows));
pfc_aic=pfc_lrt;
pfc_bic=pfc_lrt;
sigmas = [.5 1 2 5];
for s =1:length(sigmas),
    s
    for k=1:length(nrows),
        for j=1:nreps,
            sig = sigmas(s);
            X = zeros(nrows(k),ncols);
            Y = normrnd(0,sig,nrows(k),1);
            v_y=[Y - mean(Y), abs(Y)-mean(abs(Y))];
            for (i=1:nrows(k)),
                ep = mvnrnd(zeros(ncols,1),D0);
                X(i,:) = alp*(v_y(i,:))' + ep';
            end
            FF = get_fy(Y,3,'abs');
            [WX,W,f,dd] = ldr(Y,X,'PFC','cont','lrt','fy',FF);
            compang_pfc_lrt(j,k)=dd;
            [WX,W,f,dd] = ldr(Y,X,'PFC','cont','aic','fy',FF);
            compang_pfc_aic(j,k)=dd;
		      [WX,W,f,dd] = ldr(Y,X,'PFC','cont','bic','fy',FF);
            compang_pfc_bic(j,k)=dd;
        end
    end 
    for k=1:length(nrows),
        pfc_lrt(k)=sum(compang_pfc_lrt(:,k)==2)/(nreps);
        pfc_aic(k)=sum(compang_pfc_aic(:,k)==2)/(nreps);
        pfc_bic(k)=sum(compang_pfc_bic(:,k)==2)/(nreps);
    end
    figure(s);
    plot(nrows,pfc_aic,'*');
    hold on;
    plot(nrows,pfc_bic,'-');
    plot(nrows,pfc_lrt,'.');
    title(strcat('\sigma_y = ',num2str(sig)));
    xlabel('n');
    ylabel('F(2)');
    legend('AIC','BIC','LRT','Location','NorthEastOutside');
    hold off;
    ylim([0 1]);
end

