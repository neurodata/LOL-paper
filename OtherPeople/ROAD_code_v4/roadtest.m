clearvars, %clc
D=1000;
s0=10;
mu0=zeros(D,1);
mu1=[ones(s0,1); zeros(D-s0,1)];

rho=0.5;
A=rho*ones(D);
A(1:D+1:end)=1;
Sigma=A;

ntrain=300;
ntest=300;
n=ntrain+ntest;



%% separate x1 & x2
% display('separate x1 & x2');
display('nsplits Random Splits. Inside each split, 50 training and 50 testing.');
% x1 = se;
% x2 = [ve;vi];

nsplits=10;
road_errorlist =zeros(nsplits,1);
road_numlist = zeros(nsplits,1);
lda_errorlist = zeros(nsplits,1);
lda_numlist = zeros(nsplits,1);
for randSeed=1:nsplits
    
    
    display(randSeed)
    
    %% generate data
    
    [Q, ~] = qr(randn(D));
    if det(Q)<-.99
        Q(:,1)=-Q(:,1);
    end
    
    Sigma=Q*A*Q';
    mu0=Q*mu0;
    mu1=Q*mu1;
    
    P.mu=[mu0, mu1];
    gmm = gmdistribution(P.mu',Sigma,1/2*ones(2,1));
    
    [X,Y] = random(gmm,n);
    
    x1=X(Y==1,:);
    x2=X(Y==2,:);
    
    
    n1 = size(x1,1);
    n2 = size(x2,1);
    rand('state', randSeed);
    randn('state',randSeed);
    i1 = randperm(n1);
    i2 = randperm(n2);
    
    n1tr = round(n1/2);
    n1te = n1-n1tr;
    n2tr = round(n2/2);
    n2te = n2-n2tr;
    ind1_tr = i1(1:n1tr);
    ind1_te = setdiff(1:n1, ind1_tr);
    ind2_tr = i2(1:n2tr);
    ind2_te = setdiff(1:n2, ind2_tr);
    
    x = [x1(ind1_tr,:);x2(ind2_tr,:)];
    xtest = [x1(ind1_te,:);x2(ind2_te,:)];
    
    y = [zeros(n1tr,1);ones(n2tr,1)];
    ytest = [zeros(n1te,1);ones(n2te,1)];
    
    
    [obj] = roadBatch(x, y, xtest, ytest);
    [ldaobj] = lda(x,y,xtest,ytest);
    road_errorlist(randSeed)=obj.testError;
    road_numlist(randSeed)=obj.num;
    lda_errorlist(randSeed)=ldaobj.testError;
    lda_numlist(randSeed)=ldaobj.num;
    
    display([road_errorlist(randSeed), road_numlist(randSeed)])
    
end
display(['median classification error for road: ', num2str(median(road_errorlist))]);
display(['median nonzero number for road: ', num2str(median(road_numlist))]);
display(['median classification error for lda: ', num2str(median(lda_errorlist))]);
display(['median nonzero number for lda: ', num2str(median(lda_numlist))]);




