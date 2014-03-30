function Phat = QDA_train(X,Y)
% learns all the parameters necessary for QDA
% note that this function supports semi-supervised learning via encoding
% NaN's into Y
% 
% INPUT:
%   X in R^{D x n}: predictor matrix
%   Y in {0,1,NaN}^n: predictee matrix
% 
% OUTPUT: Phat, a structure of parameters 

n0=sum(Y==0);
n1=sum(Y==1);
n=n0+n1;

X0 = X(:,Y==0);
X1 = X(:,Y==1);

Phat.pi0 = n0/n;
Phat.pi1 = n1/n;
Phat.lnpi0 = log(n0/n);
Phat.lnpi1 = log(n1/n);

Phat.mu0 = mean(X0,2);
Phat.mu1 = mean(X1,2);
Phat.Sigma0 = cov(X0');
Phat.Sigma1 = cov(X1'); 
% figure; imagesc(Phat.Sigma0); colorbar;
% title('Covariance of class 0')
% % hold on;
% figure;
% imagesc(Phat.Sigma1); colorbar;
% title('Covariance of class 1')

Phat.mu = (Phat.mu0+Phat.mu1)/2;            % required for classification via LDA 
Phat.del = (Phat.mu0-Phat.mu1);             
Phat.InvSig0 = pinv(Phat.Sigma0);             
Phat.InvSig1 = pinv(Phat.Sigma1);             
Phat.thresh = (Phat.lnpi0-Phat.lnpi1)/2;    % classification threshold
