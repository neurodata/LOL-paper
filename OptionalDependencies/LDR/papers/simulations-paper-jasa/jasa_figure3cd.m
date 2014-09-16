%%%This is the script to reproduce figure 3cd from the paper by
%%% R. D. Cook and L. Forzani: "Likelihood-based Sufficient Dimension
%%% Reduction". To appear in JASA
%%% THe simulation takes a long time since it is computing the dimension of
%%% the central subspace
%
% BRIEF DESCRIPTION
% The script assesses the accuracy of AIC, BIC and LRT estimates of the dimension of the
% central subspace for the LAD model, for increasing sizes of the sample. Figure
% show: i) the fraction of the runs in which the estimate is right; 
%      ii) the fraction of the runs in which the estimate is right or bigger by one
% unit, thus possibly estimating a reductions subspace slightly larger than
% necessary. The dimension of the central subspace is d=2 in this example.
% =========================================================================


clear all;
%setpaths;


%%
ncols=8; nreps=100;
nrows=[10 30 50 70 100 150 200 250 300];
dim_lrt=zeros(nreps,length(nrows));
dim_bic=zeros(nreps,length(nrows));
dim_aic=zeros(nreps,length(nrows));
%%
% for X
mu = [6, 4, 2; 2, 4, 6];
A = zeros(2,2,3);
A(:,:,1) = [1,0; 0,3];
A(:,:,2) = [4,1; 1,2];
A(:,:,3) = [8,1; 1,2];
sqrtA = zeros(2,2,3);
for p=1:3
  sqrtA(:,:,p)=A(:,:,p)^0.5;
end

%%
for k=1:length(nrows)
  disp(['nrows = ' int2str(nrows(k))]);
  X = zeros(nrows(k)*3,ncols);
  alp = zeros(ncols,2);
  alp(1,1) = 1;
  alp(2,2) = 1;
  for j=1:nreps
    %%%%%
    % NORMAL
    X1 = zeros(nrows(k),ncols);
    X2 = zeros(nrows(k),ncols);
    X3 = zeros(nrows(k),ncols);

    for i=1:nrows(k)
      X1(i,:) = mu(:,1)'*alp' + normrnd(0,1,1,ncols) + (alp*sqrtA(:,:,1)*normrnd(0,1,2,1))';
      X2(i,:) = mu(:,2)'*alp' + normrnd(0,1,1,ncols) + (alp*sqrtA(:,:,2)*normrnd(0,1,2,1))';
      X3(i,:) = mu(:,3)'*alp' + normrnd(0,1,1,ncols) + (alp*sqrtA(:,:,3)*normrnd(0,1,2,1))';
    end
    
    X = [X1; X2; X3];
    Y = ones(size(X,1),1);
    Y(size(X1,1)+1:(size(X1,1)+size(X2,1)),1)=2;  
    Y(size(X1,1)+size(X2,1)+1:(size(X1,1)+size(X2,1)+size(X3,1)),1)=3;
        
    [WX,W,fn,d] = ldr(Y,X,'LAD','disc','lrt','alpha',0.05);
    dim_lrt(j,k) = d;
    
    [WX1,W1,fn1,d1]= ldr(Y,X,'LAD','disc','aic');
    [WX2,W2,fn2,d2] =ldr(Y,X,'LAD','disc','bic');
  
    dim_aic(j,k) = d1;
    dim_bic(j,k) = d2;
  end
end

mean_eq2  = zeros(3,length(nrows));
mean_eq23 = zeros(3,length(nrows));

for k=1:length(nrows)
  mean_eq2(1,k)  = sum(dim_lrt(:,k)==2)/size(dim_lrt,1); 
  mean_eq23(1,k) = sum(dim_lrt(:,k)==2 | dim_lrt(:,k)==3)/size(dim_lrt,1); 
  mean_eq2(2,k)  = sum(dim_aic(:,k)==2)/size(dim_aic,1); 
  mean_eq23(2,k) = sum(dim_aic(:,k)==2 | dim_aic(:,k)==3)/size(dim_aic,1); 
  mean_eq2(3,k)  = sum(dim_bic(:,k)==2)/size(dim_bic,1); 
  mean_eq23(3,k) = sum(dim_bic(:,k)==2 | dim_bic(:,k)==3)/size(dim_bic,1); 
end

% figure 3c
 figure(1);
 plot(nrows,mean_eq2);
 title('d=2');
 xlabel('n_y');
 ylabel('F(2)');
 legend('LRT','AIC','BIC','Location','Best');
% figure 3d
figure(2);
 plot(nrows,mean_eq23);
  title('d=2');
 xlabel('n_y');
 ylabel('F(2,3)');
 legend('LRT','AIC','BIC','Location','Best');