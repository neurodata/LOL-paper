clear,
clc

n0=1000;
n1=n0;
n=n0+n1;

dataset.name='model3_100';

P = get_parameters(dataset);
Risk = get_risk(P.mu0-P.mu1,P.Sig0);


D=length(P.mu0);
L=cholcov(P.Sig0);

X0 = bsxfun(@plus,randn(n0,D)*L,P.mu0')';
X1 = bsxfun(@plus,randn(n1,D)*L,P.mu1')';


%%
X=[X0, X1];
Y=[zeros(n0,1); ones(n1,1)];
P.pi0=n0/n;
P.pi1=n1/n;
P.invSig0=pinv(P.Sig0);
P.invSig1=pinv(P.Sig1);

Yhat = QDA(X,P);
BayesError=sum(Yhat~=Y)/n;

% [Yhat, BayesError] = FisherDiscriminant(X,Y,P);

%%

Phat.mu0=mean(X0,2);
Phat.mu1=mean(X1,2);

% X0_centered = bsxfun(@minus,X0,P.mu0);
% X1_centered = bsxfun(@minus,X1,P.mu1);

Phat.Sig0=cov(X0');
Phat.Sig1=cov(X1');

Phat.invSig0=pinv(Phat.Sig0);
Phat.invSig1=pinv(Phat.Sig0);

Phat.pi0=P.pi0;
Phat.pi1=P.pi1;

X0test = bsxfun(@plus,randn(n0,D)*L,P.mu0')';
X1test = bsxfun(@plus,randn(n1,D)*L,P.mu1')';
Xtest=[X0test, X1test];

Yhat = QDA(X,Phat);
QDAError=sum(Yhat~=Y)/n;

% 
% [Yhat, ErrXP] = FisherDiscriminant(X,Y,P);
% [Yhat, ErrXtestP] = FisherDiscriminant(Xtest,Y,P);
% [Yhat, ErrXPhat] = FisherDiscriminant(X,Y,Phat);
% [Yhat, ErrXtestPhat] = FisherDiscriminant(Xtest,Y,Phat);
% 
% fprintf('\n XP=%4.2f, XtestP=%4.2f XPhat=%4.2f, XtestPhat=%4.2f \n\n' ,ErrXP*100,ErrXtestP*100,ErrXPhat*100,ErrXtestPhat*100)


%% other LDA

W = LDA(X',Y);
score   = [ones(n,1) Xtest'] * W';               % project projected test data onto discriminating hyperplane
Yhat    = score(:,1)<score(:,2);  % estimate Y
LDAError2 = sum(Yhat~=Y)/n;


%%

% fprintf('\n Risk=%4.2f, BayesError=%4.2f, LDAError=%4.2f, LDAError2=%4.2f \n\n' ,Risk*100,BayesError*100,LDAError*100,LDAError2*100)


%% plot some stuff

figure(1), clf, hold on
plot(P.mu0,'k-')
plot(P.mu1,'r-')

plot(Phat.mu0,'k-.')
plot(Phat.mu1,'r-.')

figure(2)
subplot(221), imagesc(P.Sig0), title('Sig0'), colorbar
subplot(222), imagesc(Phat.Sig0), title('Sig0hat'), colorbar

subplot(223), imagesc(P.Sig1), title('Sig0'), colorbar
subplot(224), imagesc(Phat.Sig1), title('Sig1hat'), colorbar

