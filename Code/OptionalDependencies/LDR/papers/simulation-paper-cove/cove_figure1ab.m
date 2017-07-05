% #########################################################################
% This is the script to reproduce figure 1ab from the paper by R. D. Cook 
% and L. Forzani: "Covariance reducing models: An alternative to spectral 
% modelling of covariance matrices"; Biometrika 2008 95(4):799-812.
% #########################################################################

% BRIEF DESCRIPTION
% The script assesses the accuracy of the estimator of the central
% subspace under the Covariance Reduction model. It shows the median and quartiles
% of the cosine of the angle between the central subspace and the estimate, for 
% increasing size of the sample. Figure a) shows the case when errors are
% normal, whereas Figure b) shows the case for other errors.
% =========================================================================


clear all;
setpaths;

ncols=6; nreps=100; u=1;
nrows=[15 20 30 40 80 120];
compang_cove=zeros(4,nreps,length(nrows));


for k=1:length(nrows)
  disp(nrows(k));
  X = zeros(4,nrows(k)*3,ncols);
  for j=1:nreps
    alp = zeros(nrows(k),ncols);
    alp(:,ncols) = 1;
    sig = [1, 4, 8];

 
    % -------- NORMAL------------------------------------------------------
    t1 = normrnd(0,1,nrows(k)*3, ncols);
    t2uno = normrnd( 0,1,nrows(k)*3, 1);
    t2 = zeros(nrows(k)*3,ncols);
    for i=1:ncols
      t2(:,i) = t2uno;
    end
    X1 =   t1(1:nrows(k),:)  + sig(1)* t2(1:nrows(k),:).*alp;
    X2 =  t1((nrows(k)+1):2*nrows(k),:)  + sig(2)*(t2((nrows(k)+1):2*nrows(k),:) ).*alp;
    X3 =  (t1((2*nrows(k)+1):3*nrows(k),:) ) + sig(3)*(t2((2*nrows(k)+1):3*nrows(k),:) ).*alp;
    X(1,:,:) = [X1; X2; X3];
    
    % ---------CHICUADRADO-------------------------------------------------
    dfs = 5;
    t1 = chi2rnd(dfs, nrows(k)*3, ncols);
    t2uno = chi2rnd(dfs, nrows(k)*3, 1);
    t2 = zeros(nrows(k)*3,ncols);
    for i=1:ncols
      t2(:,i) = t2uno;
    end
    X1 =   t1(1:nrows(k),:)  + sig(1)* t2(1:nrows(k),:).*alp;
    X2 =   t1((nrows(k)+1):2*nrows(k),:)  + sig(2)*(t2((nrows(k)+1):2*nrows(k),:) ).*alp;
    X3 =   (t1((2*nrows(k)+1):3*nrows(k),:) ) + sig(3)*(t2((2*nrows(k)+1):3*nrows(k),:) ).*alp;
    X(2,:,:) = [X1; X2; X3];

    % ---------T STUDENT---------------------------------------------------
    t1 = trnd(dfs, nrows(k)*3, ncols);
    t2uno = trnd(dfs, nrows(k)*3, 1);
    t2 = zeros(nrows(k)*3,ncols);
    for i=1:ncols
      t2(:,i) = t2uno;
    end
    X1 = (t1(1:nrows(k),:))*sqrt(3/5) + sig(1)*(t2(1:nrows(k),:))*sqrt(3/5).*alp;
    X2 =  (t1((nrows(k)+1):2*nrows(k),:))*sqrt(3/5) + sig(2)*(t2((nrows(k)+1):2*nrows(k),:))*sqrt(3/5).*alp;
    X3 =   (t1((2*nrows(k)+1):3*nrows(k),:))*sqrt(3/5) + sig(3)*(t2((2*nrows(k)+1):3*nrows(k),:))*sqrt(3/5).*alp;
    X(3,:,:) = [X1; X2; X3];

    % ----------UNIFORM----------------------------------------------------
    t1 = unifrnd(0,1,nrows(k)*3, ncols);
    t2uno = unifrnd( 0,1,nrows(k)*3, 1);
    t2 = zeros(nrows(k)*3,ncols);
    for i=1:ncols
      t2(:,i) = t2uno;
    end
    X1 =   (t1(1:nrows(k),:)-1/2)*sqrt(12) + sig(1)*(t2(1:nrows(k),:)-1/2)*sqrt(12).*alp;
    X2 =   (t1((nrows(k)+1):2*nrows(k),:)-1/2)*sqrt(12) + sig(2)*(t2((nrows(k)+1):2*nrows(k),:)-1/2)*sqrt(12).*alp;
    X3 =   (t1((2*nrows(k)+1):3*nrows(k),:)-1/2)*sqrt(12) +sig(3)*(t2((2*nrows(k)+1):3*nrows(k),:)-1/2)*sqrt(12).*alp;
    X(4,:,:) = [X1; X2; X3];
%%%%%

    Y = ones(size(squeeze(X(1,:,:)),1),1);
    Y(size(X1,1)+1:(size(X1,1)+size(X2,1)),1)=2;  
    Y(size(X1,1)+size(X2,1)+1:(size(X1,1)+size(X2,1)+size(X3,1)),1)=3;
    
    for p=1:4
      [WX,W]=ldr(Y,squeeze(X(p,:,:)),'core','disc',u);
      compang_cove(p,j,k)=subspace(W,alp(1,:)')*180/pi;
    end
  end
end 

quant = [0.25 0.5 0.75];
for p=1:4
    for k=1:length(nrows)
        quantang_cove(p,:,k) = quantile(squeeze(cos(compang_cove(p,:,k)*pi/180)),quant)';
    end
end

% figure 1a
figure(1);
plot(nrows,squeeze(quantang_cove(1,:,:))','-');
title('Figure 1. (a) Quartile vs n_g for normal errors');
ylabel('Quartile'); xlabel('n_g');
ylim([.5 1]);

% figure 1b
figure(2);
plot(nrows,squeeze(quantang_cove(2,2,:))','-',nrows,squeeze(quantang_cove(3,2,:))','-',nrows,squeeze(quantang_cove(4,2,:))','-');
title('Figure 1. (b) Median vs n_g for other errors');
ylabel('Median'); xlabel('n_g');
