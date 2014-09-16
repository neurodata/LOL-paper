% #########################################################################
% Figure 5 from Principial Fitted components in Regression, by R. D. Cook
% and L. Forzani, Statistica Science, 23 (4), 485-501.
% LASSO picture is not reproduced here.
% #########################################################################
%
% BRIEF DESCRIPTION
% This example shows the use of dimension reduction for visualization,
% using naphtalene data. Figure shows:
% a) The response versus the first direction provided by PFC,
% b) The response versus the fitted values from the LASSO.

%--------------------------------------------------------------------------
clear all;
setpaths;
M=importdata('nap.txt',' ',2);
X=M.data(:,[4 5 9]);
Y=M.data(:,12);
%% plots to see what degree of polynomial to take in the inverse regression
figure(1);
plotmatrix(X,Y)

%% We decide that polynomial of degree 2 is ok  
% Let us choose d using AIC, BIC and LRT
FF = get_fy(Y,2,'sqr');
[WX,W,f,d_aic] = ldr(Y,X,'PFC','cont','aic','fy',FF);
disp(strcat('   Selected dimension by AIC is d = ',int2str(d_aic)));
[WX,W,f,d_bic] = ldr(Y,X,'PFC','cont','bic','fy',FF);
disp(strcat('   Selected dimension by BIC is d = ',int2str(d_aic)));
[WX,W,f,d_aic] = ldr(Y,X,'PFC','cont','lrt','fy',FF);
disp(strcat('   Selected dimension by LRT is d = ',int2str(d_aic)));
 
%%All of them choose d=1, Now the plot of Y vs the PFC 1 and the smoothing
%using lowess
z = smooth(WX,Y,40,'lowess');
[xx,ind] = sort(WX);
figure(2);
plot(xx,Y(ind),'bs',xx,z(ind),'r-')
legend('Original Data','Smoothed Data Using ''lowess''')
xlabel('R_1');
ylabel('Y');
title('First principal fitted component');
 
