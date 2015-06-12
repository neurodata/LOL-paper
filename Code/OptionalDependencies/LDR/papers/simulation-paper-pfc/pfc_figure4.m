% #########################################################################
% Figure 4 from the paper by Cook, R. D. and Forzani, L. (2009). 
% Principal fitted components in regression. Statistcal Science 23 (4), 485-501.
% #########################################################################
%
% BRIEF DESCRIPTION
% The script is to analyze Fearn's wheat protein data using the PFC
% methodology. In the first part, inference on the dimension of the
% smallest dimension reduction subspace is performed using AIC, BIC and
% LRT. Later, PFC and standard PC are compared using their first projection
% directions.
% -------------------------------------------------------------------------
% 

clear all;
setpaths;
data=load('fearn.txt');

X=data(:,2:end);
Y=data(:,1);

%% plots to see what degree of polynomial to take in the inverse regression
figure(1);
plotmatrix(X,Y)

%% We decide that polynomial of degree 3 is ok (can be 2 too)
% Let us choose d using AIC, BIC and LRT
FF = get_fy(Y,3,'sqr');
[WX,W,f,d_aic] = ldr(Y,X,'PFC','cont','aic','fy',FF);
disp(strcat('   Selected dimension by AIC is d = ',int2str(d_aic)));

[WX,W,f,d_bic] = ldr(Y,X,'PFC','cont','bic','fy',FF);
disp(strcat('   Selected dimension by BIC is d = ',int2str(d_bic)));

[WX,W,f,d_lrt] = ldr(Y,X,'PFC','cont','lrt','fy',FF);
disp(strcat('   Selected dimension by LRT is d = ',int2str(d_lrt)));
       
%%All of them choose d=1, Now the plot of Y vs the PFC 1
figure(2);
plot(WX,Y,'*');
title('First Principal Fitted Component');
xlabel('R_1');
ylabel('Y');

%%Plot of Y vs the first principal component
[WX,W] = pc(X,1,'cov');
figure(3);
plot(WX,Y,'*');
title('First Principal Component');
xlabel('R_1');
ylabel('Y');
