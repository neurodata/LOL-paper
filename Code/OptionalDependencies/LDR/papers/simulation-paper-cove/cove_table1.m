% #########################################################################
% This is the script to reproduce Table 1 from the paper by R. D. Cook and 
% L. Forzani: "Covariance reducing models: An alternative to spectral 
% modelling of covariance matrices"; Biometrika 2008 95(4):799-812.
% This script may take a long time since it is choosing the dimension of
% the smallest dimension reduction subspace
% #########################################################################
% 

% BRIEF DESCRIPTION
% The script assesses the accuracy of the LRT estimate of the dimension of the
% central subspace under the Covariance Reduction model. In particular, it
% gives the empirical distribution of the estimate after 200 runs of the
% experiment, for several error distributions. See the paper for details.
% -------------------------------------------------------------------------

clear all;
setpaths;

ncols=6; nreps=200; u=1;
% nrows=[15 20 30 40 100];
nrows=[15 20 30 40];
dim_lrt_norm=zeros(length(nrows),6,nreps);

for k=1:length(nrows)
    disp(['k = ' int2str(k)]);
    X = zeros(6,nrows(k)*3,ncols);
    for j=1:nreps
        alp = zeros(nrows(k),ncols);
        alp(:,ncols) = 1;
        sig = [1, 4, 8];
 % -----NORMAL-------------------------------------------------------------
        t1 = normrnd(0,1,nrows(k)*3, ncols);
        t2uno = normrnd( 0,1,nrows(k)*3, 1);
        t2 = zeros(nrows(k)*3,ncols);
        for i=1:ncols
          t2(:,i) = t2uno;
        end
        X1 =  t1(1:nrows(k),:)  + sig(1)* t2(1:nrows(k),:).*alp;
        X2 =   t1((nrows(k)+1):2*nrows(k),:)  + sig(2)*(t2((nrows(k)+1):2*nrows(k),:) ).*alp;
        X3 =  (t1((2*nrows(k)+1):3*nrows(k),:) ) + sig(3)*(t2((2*nrows(k)+1):3*nrows(k),:) ).*alp;
        X(1,:,:) = [X1; X2; X3];
    
 % -----UNIFORM------------------------------------------------------------
        t1 = unifrnd(0,1,nrows(k)*3, ncols);
        t2uno = unifrnd( 0,1,nrows(k)*3, 1);
        t2 = zeros(nrows(k)*3,ncols);
        for i=1:ncols
          t2(:,i) = t2uno;
        end
        X1 =  (t1(1:nrows(k),:)-1/2)*sqrt(12) + sig(1)*(t2(1:nrows(k),:)-1/2)*sqrt(12).*alp;
        X2 =   (t1((nrows(k)+1):2*nrows(k),:)-1/2)*sqrt(12) + sig(2)*(t2((nrows(k)+1):2*nrows(k),:)-1/2)*sqrt(12).*alp;
        X3 =   (t1((2*nrows(k)+1):3*nrows(k),:)-1/2)*sqrt(12) +sig(3)*(t2((2*nrows(k)+1):3*nrows(k),:)-1/2)*sqrt(12).*alp;
        X(2,:,:) = [X1; X2; X3];

 % -----CHICUADRADO--------------------------------------------------------
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
        X(3,:,:) = [X1; X2; X3];

 % -----TSTUDENT with 5 degrees--------------------------------------------
        t1 = trnd(dfs, nrows(k)*3, ncols);
        t2uno = trnd(dfs, nrows(k)*3, 1);
        t2 = zeros(nrows(k)*3,ncols);
        for i=1:ncols
          t2(:,i) = t2uno;
        end
        X1 =   (t1(1:nrows(k),:))*sqrt(3/5) + sig(1)*(t2(1:nrows(k),:))*sqrt(3/5).*alp;
        X2 =   (t1((nrows(k)+1):2*nrows(k),:))*sqrt(3/5) + sig(2)*(t2((nrows(k)+1):2*nrows(k),:))*sqrt(3/5).*alp;
        X3 =   (t1((2*nrows(k)+1):3*nrows(k),:))*sqrt(3/5) + sig(3)*(t2((2*nrows(k)+1):3*nrows(k),:))*sqrt(3/5).*alp;
        X(4,:,:) = [X1; X2; X3];

 % -----TSTUDENT with 7 degrees--------------------------------------------
        dfs=7;
        t1 = trnd(dfs, nrows(k)*3, ncols);
        t2uno = trnd(dfs, nrows(k)*3, 1);
        t2 = zeros(nrows(k)*3,ncols);
        for i=1:ncols
          t2(:,i) = t2uno;
        end
        X1 =   (t1(1:nrows(k),:))*sqrt(3/5) + sig(1)*(t2(1:nrows(k),:))*sqrt(3/5).*alp;
        X2 =   (t1((nrows(k)+1):2*nrows(k),:))*sqrt(3/5) + sig(2)*(t2((nrows(k)+1):2*nrows(k),:))*sqrt(3/5).*alp;
        X3 =   (t1((2*nrows(k)+1):3*nrows(k),:))*sqrt(3/5) + sig(3)*(t2((2*nrows(k)+1):3*nrows(k),:))*sqrt(3/5).*alp;
        X(5,:,:) = [X1; X2; X3];
    
% ------TSTUDENT with 10 degrees-------------------------------------------
        dfs=10;
        t1 = trnd(dfs, nrows(k)*3, ncols);
        t2uno = trnd(dfs, nrows(k)*3, 1);
        t2 = zeros(nrows(k)*3,ncols);
        for i=1:ncols
          t2(:,i) = t2uno;
        end
        X1 =   (t1(1:nrows(k),:))*sqrt(3/5) + sig(1)*(t2(1:nrows(k),:))*sqrt(3/5).*alp;
        X2 =   (t1((nrows(k)+1):2*nrows(k),:))*sqrt(3/5) + sig(2)*(t2((nrows(k)+1):2*nrows(k),:))*sqrt(3/5).*alp;
        X3 =   (t1((2*nrows(k)+1):3*nrows(k),:))*sqrt(3/5) + sig(3)*(t2((2*nrows(k)+1):3*nrows(k),:))*sqrt(3/5).*alp;
        X(6,:,:) = [X1; X2; X3];

        
        Y = ones(size(squeeze(X(1,:,:)),1),1);
        Y(size(X1,1)+1:(size(X1,1)+size(X2,1)),1)=2;  
        Y(size(X1,1)+size(X2,1)+1:(size(X1,1)+size(X2,1)+size(X3,1)),1)=3;
        for p=1:6
            [WX,W,fn,d] = ldr(Y,squeeze(X(p,:,:)),'CORE','disc','lrt','alpha',0.01,'initval','full');
            dim_lrt(k,p,j)=d;
        end
    end
end
 

for k=1:length(nrows)
    for p=1:6,
        dim_lrt_eq1(k,p) = sum(dim_lrt(k,p,:)==0)/nreps;
    end
    for p=1:6
        dim_lrt_eq2(k,p) = sum(dim_lrt(k,p,:)==1)/nreps;
    end
    for p=1:6
        dim_lrt_eq3(k,p) = sum(dim_lrt(k,p,:)==2)/nreps;
    end
    for p=1:6
        dim_lrt_eq4(k,p) = sum(dim_lrt(k,p,:)==3)/nreps;
    end
    for p=1:6
        dim_lrt_eq5(k,p) = sum(dim_lrt(k,p,:)==4)/nreps;
    end
end


% DIEGO: aca me gustaria que imprima la tabla
% ordenadamente como en el paper.

% dim_lrt_eq1
% dim_lrt_eq2
% dim_lrt_eq3
% dim_lrt_eq4

% ============Format table=================================================
table = zeros(8,6);
nrows = [15 20 30 40]';

table(1:4,1) = nrows;
%----fills column for d=0 for the standard normal model
table(1:length(nrows),2) = dim_lrt_eq1(1:4,1);
%----fills column for d=1 for the standard normal model
table(1:length(nrows),3) = dim_lrt_eq2(1:4,1);
%----fills column for d=2 for the standard normal model
table(1:length(nrows),4) = dim_lrt_eq3(1:4,1);
%----fills column for d=3 for the standard normal model
table(1:length(nrows),5) = dim_lrt_eq4(1:4,1);
%----fills column for d=4 for the standard normal model
table(1:length(nrows),6) = dim_lrt_eq5(1:4,1);
%------------------------------------------------------------
table(5,1) = 40;
%----fills column for d=0 for the uniform model
table(5,2) = dim_lrt_eq1(4,2);
%----fills column for d=1 for the uniform model
table(5,3) = dim_lrt_eq2(4,2);
%----fills column for d=2 for the uniform model
table(5,4) = dim_lrt_eq3(4,2);
%----fills column for d=3 for the uniform model
table(5,5) = dim_lrt_eq4(4,2);
%----fills column for d=4 for the uniform model
table(5,6) = dim_lrt_eq5(4,2);
%------------------------------------------------------------
table(6,1) = 40;
%----fills column for d=0 for the chisquare model
table(6,2) = dim_lrt_eq1(4,3);
%----fills column for d=1 for the chisquare model
table(6,3) = dim_lrt_eq2(4,3);
%----fills column for d=2 for the chisquare model
table(6,4) = dim_lrt_eq3(4,3);
%----fills column for d=3 for the chisquare model
table(6,5) = dim_lrt_eq4(4,3);
%----fills column for d=4 for the chisquare model
table(6,6) = dim_lrt_eq5(4,3);
%------------------------------------------------------------
table(7,1) = 40;
%----fills column for d=0 for the t10 model
table(7,2) = dim_lrt_eq1(4,6);
%----fills column for d=1 for the t10 model
table(7,3) = dim_lrt_eq2(4,6);
%----fills column for d=2 for the t10 model
table(7,4) = dim_lrt_eq3(4,6);
%----fills column for d=3 for the t10 model
table(7,5) = dim_lrt_eq4(4,6);
%----fills column for d=4 for the t10 model
table(7,6) = dim_lrt_eq5(4,6);
%------------------------------------------------------------
table(8,1) = 40;
%----fills column for d=0 for the t7 model
table(8,2) = dim_lrt_eq1(4,5);
%----fills column for d=1 for the t7 model
table(8,3) = dim_lrt_eq2(4,5);
%----fills column for d=2 for the t7 model
table(8,4) = dim_lrt_eq3(4,5);
%----fills column for d=3 for the t7 model
table(8,5) = dim_lrt_eq4(4,5);
%----fills column for d=4 for the t7 model
table(8,6) = dim_lrt_eq5(4,5);
%------------------------------------------------------------
table(:,2:end) = 100*table(:,2:end);
disp(' ');
disp('    Table 1. Empirical distribution of d in percent');
disp(' ');
disp('       n_g      d=0      d=1       d=2       d=3       d=4');
disp(table);

