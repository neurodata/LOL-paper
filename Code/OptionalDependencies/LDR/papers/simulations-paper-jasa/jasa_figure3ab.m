%%%This is the script to reproduce figure 3ab from the paper by
%%% R. D. Cook and L. Forzani: "Likelihood-based Sufficient Dimension
%%% Reduction". To appear in JASA
%%% The simulation takes a long time since it is computing the dimension of
%%% the central subspace
%
% BRIEF DESCRIPTION
% The script assesses the accuracy of AIC, BIC and LRT estimates of the dimension of the
% central subspace for the LAD model, for increasing sizes of the sample. Figure
% show: i) the fraction of the runs in which the estimate is right; 
%      ii) the fraction of the runs in which the estimate is right or bigger by one
% unit, thus possibly estimating a reductions subspace slightly larger than
% necessary. The dimension of the central subspace is d=1 in this example.
% =========================================================================

clear all;
%setpaths

ncols=8; nreps=100; u=1;
nrows=[20 40 60 100 150 200 250 300];
dim_lrt=zeros(nreps,length(nrows));
dim_bic=zeros(nreps,length(nrows));
dim_aic=zeros(nreps,length(nrows));

for k=1:length(nrows)
  disp(['nrows = ' int2str(nrows(k))]);
  X = zeros(nrows(k)*3,ncols);
  for j=1:nreps
    alp = zeros(nrows(k),ncols);
    alp(:,ncols) = 1;
    mu = [6, 4, 2];
    sig = [1, 4, 8];
    % NORMAL
    t1 = normrnd(0,1,nrows(k)*3, ncols);
    t2uno = normrnd( 0,1,nrows(k)*3, 1);
    t2 = zeros(nrows(k)*3,ncols);
    for i=1:ncols
      t2(:,i) = t2uno;
    end
    X1 = mu(1)*alp + t1(1:nrows(k),:)  + sig(1)* t2(1:nrows(k),:).*alp;
    X2 = mu(2)*alp + t1((nrows(k)+1):2*nrows(k),:)  + sig(2)*(t2((nrows(k)+1):2*nrows(k),:) ).*alp;
    X3 = mu(3)*alp + (t1((2*nrows(k)+1):3*nrows(k),:) ) + sig(3)*(t2((2*nrows(k)+1):3*nrows(k),:) ).*alp;

    X = [X1; X2; X3];
    Y = ones(size(X,1),1);
    Y(size(X1,1)+1:(size(X1,1)+size(X2,1)),1)=2;  
    Y(size(X1,1)+size(X2,1)+1:(size(X1,1)+size(X2,1)+size(X3,1)),1)=3;
        
    [WX,W,fn,d] = ldr(Y,X,'LAD','disc','lrt','alpha',0.05);
    dim_lrt(j,k) = d;
    
    [WX1,W1,fn1,d1]=ldr(Y,X,'LAD','disc','aic');
   
    [WX2,W2,fn2,d2] = ldr(Y,X,'LAD','disc','bic');
    dim_aic(j,k) = d1;
    dim_bic(j,k) = d2;
  end
end

mean_eq1  = zeros(3,length(nrows));
mean_eq12 = zeros(3,length(nrows));

for k=1:length(nrows)
  mean_eq1(1,k)  = sum(dim_lrt(:,k)==1)/size(dim_lrt,1); 
  mean_eq12(1,k) = sum(dim_lrt(:,k)<3)/size(dim_lrt,1); 
  mean_eq1(2,k)  = sum(dim_aic(:,k)==1)/size(dim_aic,1); 
  mean_eq12(2,k) = sum(dim_aic(:,k)<3)/size(dim_aic,1); 
  mean_eq1(3,k)  = sum(dim_bic(:,k)==1)/size(dim_bic,1); 
  mean_eq12(3,k) = sum(dim_bic(:,k)<3)/size(dim_bic,1); 
end

% figure 3a
figure(1);
plot(nrows,mean_eq1);
title('d=1');
xlabel('n_y');
ylabel('F(1)');
ylim([0 1]);
legend('LRT','AIC','BIC','Location','Best');


% figure 3b
figure(2);
plot(nrows,mean_eq12);
title('d=1');
xlabel('n_y');
ylabel('F(1,2)');
ylim([0 1]);
legend('LRT','AIC','BIC','Location','Best');
