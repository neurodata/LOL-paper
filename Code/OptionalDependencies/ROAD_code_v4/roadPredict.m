% This function implements the ROAD
% Algorithm for the following optimization problem:
% minimize 0.5 * w' \Sigma w + \lambda |w|_1 + 1/2 \gamma (Aw-b)^T (Aw-b)
% x: n*p matrix
% y: label for the data, 0/1, or 1/2.
function [class, classAll,etaall] = roadPredict(xtest, fit, fitCV)
%%%%%%%%%%K: number of lambdas on the log-scale
%%%%%%%%%%epsilon: lamMin=lamMax*epsilon

mua = fit.mua;
ntest = size(xtest,1);
if(fit.para.sRoad)
    xtest = xtest(:,fit.para.sInd);
end
etaall=(xtest-repmat(mua', ntest, 1))*fit.wPath;
classAll = etaall>0;
if nargin==3,
    class    = (xtest-repmat(mua', ntest, 1))*fitCV.w>0;
else
    class = [];
end












