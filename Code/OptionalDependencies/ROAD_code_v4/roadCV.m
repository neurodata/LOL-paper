% This function implements the ROAD
% Algorithm for the following optimization problem:
% minimize 0.5 * w' \Sigma w + \lambda |w|_1 + 1/2 \gamma (Aw-b)^T (Aw-b)
% x: n*p matrix
% y: label for the data, 0/1, or 1/2.
function [fitCV] = roadCV(x, y, fit, nfold, tracking)
%%%%%%%%%%K: number of lambdas on the log-scale
%%%%%%%%%%epsilon: lamMin=lamMax*epsilon

para = fit.para;
if (nargin<5 )
    tracking = 0;
end
if (nargin<4 )
    if(~isfield(para,'nfold'))
        nfold = 5;
    else
        nfold=para.nfold;
    end
end

K = para.K ;

dRoad = para.dRoad;
if(para.sRoad)
    x = x(:,para.sInd);
end
b = 1;
[n, p] = size(x);

if(min(y)==0)
    y = y + 1;
end

x1 = x(y==1,:);
x2 = x(y==2,:);
n1 = size(x1,1);
n2 = n-n1;


rand('state', 0);
randn('state',0);
indices1  = crossvalind('Kfold',n1, nfold);
indices2  = crossvalind('Kfold',n2, nfold);



errorMat = zeros(nfold, K);

SumDist = zeros(1,K);
SumDist2= SumDist;
for i=1:nfold
    if(tracking==1)
    display(['CV ', num2str(i), ' of ', num2str(nfold)]);
    end
    test1 = (indices1==i);
    test2 = (indices2==i);
    train1 = ~test1;
    train2 = ~test2;
    x1train = x1(train1,:);
    x2train = x2(train2,:);
    x1test = x1(test1,:);
    x2test = x2(test2,:);
    n1test = size(x1test, 1);
    n2test = size(x2test, 1);
    n1train = n1-n1test;
    n2train = n2-n2test;
    mu1 = mean(x1train)';
    mu2 = mean(x2train)';
    mua = (mu2+mu1)/2;
    mud = (mu2-mu1)/2;
    Sigma = (n1train*cov(x1train) + n2train*cov(x2train))/(n1train+n2train);
    if(dRoad)
        Sigma = diag(diag(Sigma));
    end
    
    A = mud;
    
    [wPath, num] = roadCore(A, b, Sigma, fit.lamList, para);
    
    x1T = (x1test-repmat(mua', n1test, 1));
    x2T = (x2test-repmat(mua', n2test, 1));
    
    x1Tnorm = sqrt(sum(x1T'.^2));
    x2Tnorm = sqrt(sum(x2T'.^2));
    
    x1TnormMat = repmat(x1Tnorm', 1, n1test);
    x2TnormMat = repmat(x2Tnorm', 1, n2test);
    
    
    dist1 = (x1test-repmat(mua', n1test, 1))*wPath;
    dist2 = -(x2test-repmat(mua', n2test, 1))*wPath;
    test1 = dist1 >0 ;
    test2 = dist2 >0 ;
    
    wPathnorm=sqrt(sum(wPath.^2));
    wPathnormmat1 = repmat(wPathnorm, n1test,1);
    wPathnormmat2 = repmat(wPathnorm, n2test,1);
    dist1 = dist1./wPathnormmat1;
    dist2 = dist2./wPathnormmat2;
    dist3 = dist1.^2;
    dist4 = dist2.^2;
    
    distAve = mean([dist1; dist2]);
    distAve2 = mean([dist3; dist4]);
    
    SumDist = SumDist + distAve;
    SumDist2=SumDist2+distAve2;
    
    errorMat(i,:)= errorMat(i,:)+ sum([test1;test2]);
end
fitCV.error = sum(errorMat)/n;
fitCV.lamind = find(fitCV.error==min(fitCV.error), 1, 'last' );
fitCV.w = fit.wPath(:, fitCV.lamind);
fitCV.num = sum(fitCV.w~=0);


%class = (x-repmat(fit.mua', n, 1))*fitCV.w>0;
%fitCV.error = mean(class+1~=y);






















