%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the script to reproduce figure 1 from the paper by
% R. D. Cook and L. Forzani: "Likelihood-based Sufficient Dimension
% Reduction". Journal of the American Statistical Association, Vol. 104, Nº
% 485, pp. 18-25, 2008.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Brief Description
% 
% The script compares LAD and DR estimates by computing the angle between them
% and the known central subspace. Figures show quartiles and medians for this 
% angle, for different sample sizes. See the paper for details.
% ===========================================================================    
% 

clear all;
setpaths;


% =========Parameters for simulation
nreps=100;                     % number of replications used for simulation
ncols=8;                       % number of predictors 
u=1;                           % dimension of the central subspace
nrows=[15 20 30 40 80 120];               % sample sizes

% =========Initialization of arrays
compang_lad=zeros(4,nreps,length(nrows));
compang_dr=zeros(4,nreps,length(nrows));


% ========= MAIN LOOP
for k=1:length(nrows)
  disp(nrows(k));
  % initialize predictor matrix for current sample size
  X = zeros(4,nrows(k)*3,ncols);
  for j=1:nreps
    alp = zeros(nrows(k),ncols);
    alp(:,ncols) = 1;
    
    % model parameters
    mu = [6, 4, 2];
    sig = [1, 4, 8];

 %%%%% DATA GENERATION
 % NORMAL errors
    t1 = normrnd(0,1,nrows(k)*3, ncols);
    t2uno = normrnd( 0,1,nrows(k)*3, 1);
    t2 = zeros(nrows(k)*3,ncols);
    for i=1:ncols
      t2(:,i) = t2uno;
    end
    X1 = mu(1)*alp + t1(1:nrows(k),:)  + sig(1)* t2(1:nrows(k),:).*alp;
    X2 = mu(2)*alp + t1((nrows(k)+1):2*nrows(k),:)  + sig(2)*(t2((nrows(k)+1):2*nrows(k),:) ).*alp;
    X3 = mu(3)*alp + (t1((2*nrows(k)+1):3*nrows(k),:) ) + sig(3)*(t2((2*nrows(k)+1):3*nrows(k),:) ).*alp;
    X(1,:,:) = [X1; X2; X3];
    
 % CHICUADRADO errors
    dfs = 5;
    t1 = chi2rnd(dfs, nrows(k)*3, ncols);
    t2uno = chi2rnd(dfs, nrows(k)*3, 1);
    t2 = zeros(nrows(k)*3,ncols);
    for i=1:ncols
      t2(:,i) = t2uno;
    end
    X1 = mu(1)*alp + t1(1:nrows(k),:)  + sig(1)* t2(1:nrows(k),:).*alp;
    X2 = mu(2)*alp + t1((nrows(k)+1):2*nrows(k),:)  + sig(2)*(t2((nrows(k)+1):2*nrows(k),:) ).*alp;
    X3 = mu(3)*alp + (t1((2*nrows(k)+1):3*nrows(k),:) ) + sig(3)*(t2((2*nrows(k)+1):3*nrows(k),:) ).*alp;
    X(2,:,:) = [X1; X2; X3];

 % TSTUDENT errors
    t1 = trnd(dfs, nrows(k)*3, ncols);
    t2uno = trnd(dfs, nrows(k)*3, 1);
    t2 = zeros(nrows(k)*3,ncols);
    for i=1:ncols
      t2(:,i) = t2uno;
    end
    X1 = mu(1)*alp + (t1(1:nrows(k),:))*sqrt(3/5) + sig(1)*(t2(1:nrows(k),:))*sqrt(3/5).*alp;
    X2 = mu(2)*alp + (t1((nrows(k)+1):2*nrows(k),:))*sqrt(3/5) + sig(2)*(t2((nrows(k)+1):2*nrows(k),:))*sqrt(3/5).*alp;
    X3 = mu(3)*alp + (t1((2*nrows(k)+1):3*nrows(k),:))*sqrt(3/5) + sig(3)*(t2((2*nrows(k)+1):3*nrows(k),:))*sqrt(3/5).*alp;
    X(3,:,:) = [X1; X2; X3];

 % UNIFORM errors
    t1 = unifrnd(0,1,nrows(k)*3, ncols);
    t2uno = unifrnd( 0,1,nrows(k)*3, 1);
    t2 = zeros(nrows(k)*3,ncols);
    for i=1:ncols
      t2(:,i) = t2uno;
    end
    X1 = mu(1)*alp + (t1(1:nrows(k),:)-1/2)*sqrt(12) + sig(1)*(t2(1:nrows(k),:)-1/2)*sqrt(12).*alp;
    X2 = mu(2)*alp + (t1((nrows(k)+1):2*nrows(k),:)-1/2)*sqrt(12) + sig(2)*(t2((nrows(k)+1):2*nrows(k),:)-1/2)*sqrt(12).*alp;
    X3 = mu(3)*alp + (t1((2*nrows(k)+1):3*nrows(k),:)-1/2)*sqrt(12) +sig(3)*(t2((2*nrows(k)+1):3*nrows(k),:)-1/2)*sqrt(12).*alp;
    X(4,:,:) = [X1; X2; X3];
%%%%%
    % sets labels
    Y = ones(size(squeeze(X(1,:,:)),1),1);
    Y(size(X1,1)+1:(size(X1,1)+size(X2,1)),1)=2;  
    Y(size(X1,1)+size(X2,1)+1:(size(X1,1)+size(X2,1)+size(X3,1)),1)=3;
   
    
    % ==== Subspace estimation and angle computation
    for p=1:4
      [WX,W]=ldr(Y,squeeze(X(p,:,:)),'LAD','disc',u);
      compang_lad(p,j,k)=subspace(W,alp(1,:)')*180/pi;

      [Wx,W]=DR(Y,squeeze(X(p,:,:)),'disc',u);
      compang_dr(p,j,k)=subspace(W,alp(1,:)')*180/pi;
    end
  end
end 

quant = [0.25 0.5 0.75]; % quantiles to be estimated
for p=1:4
    for k = 1:length(nrows),
        quantang_lad(p,k,:) = quantile(compang_lad(p,:,k),quant)';
        quantang_dr(p,k,:) = quantile(compang_dr(p,:,k),quant)';
    end
end


%%%%%%%%%%%%% FIGURES %%%%%%%%%%%%%%%%%%%%%%
% figure 1a: this figure shows the median and the .25 and .75 quartiles of
% the angle between the central subspace and its estimate according to LAD
% and DR for different sample sizes, when the data is normally distributed 
% conditional on Y.
figure(1);
plot(nrows,squeeze(quantang_lad(1,:,:))','-',nrows,squeeze(quantang_dr(1,:,:))','--');
title('Normal error');
xlabel('n_{y}'); ylabel('Quantiles');
legend('LAD','','','DR','','');
ylim([0 90]);


% figure 1b: this figure shows the median of the angle between the central 
% subspace and its estimate according to LAD and DR for different sample 
% sizes, when the data deviates from normality conditional on Y.

figure(2);
plot(nrows,squeeze(quantang_lad(2,:,2))','-',nrows,squeeze(quantang_lad(3,:,2))','-',nrows,squeeze(quantang_lad(4,:,2))','-',nrows,squeeze(quantang_dr(2,:,2))','--',nrows,squeeze(quantang_dr(3,:,2))','--',nrows,squeeze(quantang_dr(4,:,2))','--');
title('Other errors');
xlabel('n_y');
ylabel('Medians');
legend('LAD','','','DR','','');
ylim([0 90]);
