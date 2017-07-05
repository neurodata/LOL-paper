% #########################################################################
% This is Figure 1 from the paper by Cook, R. D. and Forzani, L. (2009). 
% Principal fitted components in regression. % Statistcal Science 23 (4), 
% 485-501. Lasso picture is not reproduce here.
% #########################################################################
%
% BRIEF DESCRIPTION
% 
% The figure shows boxplots of the angle between the smallest 
% sufficient dimension reduction subspace and each of eight estimates. 
% These estimates are obtained under various choices of the regression 
% basis to fit the centered predictors in the PFC model.
% See the paper for details.
%--------------------------------------------------------------------------


clear all;
setpaths;
ncols=20; nreps=100; u=1;
nrows=200;
compang_pcf=zeros(nreps,7);
alp = ones(ncols,1); alp = alp/sqrt(20);
sig = 1;
    
for j=1:100
    Y=unifrnd(0,4,nrows,1);
    for i=1:nrows
        v_y(i)=exp(Y(i));
        eps=mvnrnd(zeros(ncols,1),eye(ncols));
        X(i,:)=v_y(i) *alp + eps';
    end
    for k=1:6
        FF = get_fy(Y,k,'sqr');
        [WX,W,f] = ldr(Y,X,'PFC','cont',1,'fy',FF);
        compang_lad(j,k)=subspace(W,alp)*180/pi;
    end
    FF=exp(Y)-mean(exp(Y));
    [WX,W,f] = ldr(Y,X,'PFC','cont',1,'fy',FF);
    compang_lad(j,7)=subspace(W,alp)*180/pi;
end
quant = [0.25 0.5 0.75];
quantang_lad = quantile(compang_lad,quant)';
% plot, with labels
lab = {'y','y^2','y^3','y^4','y^5','y^6','exp^y'};
boxplot(compang_lad,'labels',lab);
xlabel('f_y');
ylabel('Angle');
title('Figure 1');
