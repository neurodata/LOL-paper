%%%This is the script to reproduce Table 1 from the paper by
%%% R. D. Cook and L. Forzani: "Likelihood-based Sufficient Dimension
%%% Reduction". To appear in JASA
%
% 
% BRIEF DESCRIPTION
% The script compares LRT and Permutation Tests estimates of the dimension of the
% central subspace for the LAD model, when the sample deviates from
% normallity. Uniform, chi-squared and t-student errors are considered.
% =========================================================================

clear all;
setpaths;

tic;
ncols=8; nreps=200; u=1;
 
nrows=40;
dim_pt=zeros(4,nreps);
dim_lrt=zeros(4,nreps);

for k=1:length(nrows)
  disp(strcat('k =',int2str(k)));
  X = zeros(4,nrows(k)*3,ncols);
  for j=1:nreps
  disp(['j = ' int2str(j)]);
    alp = zeros(nrows(k),ncols);
    alp(:,ncols) = 1;
    mu = [6, 4, 2];
    sig = [1, 4, 8];

 %%%%%
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

    X(1,:,:) = [X1; X2; X3];
    
 % UNIFORM
    t1 = unifrnd(0,1,nrows(k)*3, ncols);
    t2uno = unifrnd( 0,1,nrows(k)*3, 1);
    t2 = zeros(nrows(k)*3,ncols);
    for i=1:ncols
      t2(:,i) = t2uno;
    end

    X1 = mu(1)*alp + (t1(1:nrows(k),:)-1/2)*sqrt(12) + sig(1)*(t2(1:nrows(k),:)-1/2)*sqrt(12).*alp;
    X2 = mu(2)*alp + (t1((nrows(k)+1):2*nrows(k),:)-1/2)*sqrt(12) + sig(2)*(t2((nrows(k)+1):2*nrows(k),:)-1/2)*sqrt(12).*alp;
    X3 = mu(3)*alp + (t1((2*nrows(k)+1):3*nrows(k),:)-1/2)*sqrt(12) +sig(3)*(t2((2*nrows(k)+1):3*nrows(k),:)-1/2)*sqrt(12).*alp;
    X(2,:,:) = [X1; X2; X3];

 % CHICUADRADO
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
    X(3,:,:) = [X1; X2; X3];

 % TSTUDENT
    t1 = trnd(dfs, nrows(k)*3, ncols);
    t2uno = trnd(dfs, nrows(k)*3, 1);
    t2 = zeros(nrows(k)*3,ncols);
    for i=1:ncols
      t2(:,i) = t2uno;
    end

    X1 = mu(1)*alp + (t1(1:nrows(k),:))*sqrt(3/5) + sig(1)*(t2(1:nrows(k),:))*sqrt(3/5).*alp;
    X2 = mu(2)*alp + (t1((nrows(k)+1):2*nrows(k),:))*sqrt(3/5) + sig(2)*(t2((nrows(k)+1):2*nrows(k),:))*sqrt(3/5).*alp;
    X3 = mu(3)*alp + (t1((2*nrows(k)+1):3*nrows(k),:))*sqrt(3/5) + sig(3)*(t2((2*nrows(k)+1):3*nrows(k),:))*sqrt(3/5).*alp;
    X(4,:,:) = [X1; X2; X3];

%%%%%

    Y = ones(size(squeeze(X(1,:,:)),1),1);
    Y(size(X1,1)+1:(size(X1,1)+size(X2,1)),1)=2;  
    Y(size(X1,1)+size(X2,1)+1:(size(X1,1)+size(X2,1)+size(X3,1)),1)=3;
    
    for p=1:4
      [WX,W,fn,d] = ldr(Y,squeeze(X(p,:,:)),'LAD','disc','perm','npermute',500,'alpha',0.05);
      dim_pt(p,j)=d;
      [WX,W,fn,d] = ldr(Y,squeeze(X(p,:,:)),'LAD','disc','lrt','alpha',0.05);
      dim_lrt(p,j)=d;
    end
  end
end 

for p=1:4
  dim_pt_eq1(p) = sum(dim_pt(p,:)==1)/size(dim_pt,2);
  dim_lrt_eq1(p) = sum(dim_lrt(p,:)==1)/size(dim_lrt,2);
end

toc;
