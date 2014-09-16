%%%This is the script to reproduce figure 2a from the paper by
%%% R. D. Cook and L. Forzani: "Likelihood-based Sufficient Dimension
%%% Reduction". To appear in JASA

%
% Brief Description
% 
% The script compares LAD and F2M methods SIR, SAVE and DR by computing the angle 
% between them and the known central subspace. The regression model for the response 
% is Y = 4*X1/a + err. Figure shows the average angle for different values of parameter 
% 'a' in the regression model. See the paper for details.
% =========================================================================


clear all; 
%setpaths;
nrows = 500;
ncols = 8;
nrep = 100;
amax = 20;

%%  
% figure 2a
h=5;
u=1;
alp = zeros(ncols,1);
alp(1,1) = 1;

angulos = zeros(nrep,amax,4);

for a=1:amax
  disp(strcat('a =',int2str(a)));
  for j=1:nrep
     X=normrnd(0,1,nrows,ncols);

     yr=4/a*(X*alp(:,1)) ;
     y=normrnd(yr,1);

    [WX, W]=ldr(y,X,'lad','cont',u,'nslices',h);
    angulos(j,a,1)=subspace(W,alp)*180/pi;

    [WX, W]=SIR(y,X,'cont',u,'nslices',h);
    angulos(j,a,2)=subspace(W,alp)*180/pi;
    
    [WX, W]=SAVE(y,X,'cont',u,'nslices',h);
    angulos(j,a,3)=subspace(W,alp)*180/pi;

    [WX, W]=DR(y,X,'cont',u,'nslices',h);    
    angulos(j,a,4)=subspace(W,alp)*180/pi;
  end
end

%meanang = zeros(amax,4);
meanang = mean(angulos,1);

plot(squeeze(meanang));
%label
title('Y=4X_1/a + \epsilon');
xlabel('a');
ylabel('ANGLE');
legend('LAD','SIR','SAVE','DR','Location','Best');
