% This function implements the ROAD
% Algorithm for the following optimization problem:
% minimize 0.5 * w' \Sigma w + \lambda |w|_1 + 1/2 \gamma (Aw-b)^T (Aw-b)
% x: n*p matrix
% y: label for the data, 0/1, or 1/2.
function [fit] = road(x, y, dRoad, sRoad, para)

%%%%%%%%%%dRoad: indicator of doing diagonal-road or not.
%%%%%%%%%%sRoad: indicator of doing screening-road or not. sRoad=1: first
%%%%%%%%%%version, sRoad=2: second version.
%%%%%%%%%%K: number of lambdas on the log-scale
%%%%%%%%%%epsilon: lamMin=lamMax*epsilon
if (nargin<5)
    para.alpha=0;
    para.iterMax=100;
    para.epsCon=1e-2;
    para.epsilon=1e-3;
    para.K=100;
    para.gamma=10;
end
if (nargin<4)
    sRoad=0;
end
if (nargin<3)
    dRoad=0;
end

if (~isfield(para,'alpha'))
    para.alpha=0;
end
if (~isfield(para,'iterMax'))
    
    para.iterMax=100;
end
if(~isfield(para,'epsCon'))
    para.epsCon=1e-2;
end
if(~isfield(para,'epsilon'))
    para.epsilon=1e-3;
end
if(~isfield(para,'K'))
    para.K=100;
end
if(~isfield(para,'gamma'))
    para.gamma=10;
end


iterMax = para.iterMax;
epsCon = para.epsCon;
epsilon = para.epsilon;
K = para.K;
gamma = para.gamma;
alpha = para.alpha;
para.dRoad = dRoad;
para.sRoad = sRoad;


b = 1;
[n, p] = size(x);

para.p = p;
[mua, mud, Sigma, x1, x2, n1, n2] = stat(x, y);
if(dRoad)
    Sigma = diag(diag(Sigma));
end
if(sRoad)
    T = mud./sqrt(diag(Sigma));
    per = randperm(n);
    yper = y(per);
    [mua, mudPer, SigmaPer] = stat(x, yper);
    Tper = mudPer./sqrt(diag(SigmaPer));
    sInd = find(abs(T)>quantile(abs(Tper),1-alpha));
    
    if(sRoad==2)
        n0 = length(sInd);
        if(2*n0 >= p)
            sInd = (1:p);
        else
            index2 = sInd;
            index3 = sInd;
            tmpMat = abs(Sigma(index2,setdiff(1:p,index2)));
            index4 = setdiff(1:p,index2);
            tmpvec = reshape(tmpMat,n0*(p-n0),1);
            
            for i=1:n0
                [tmpvecmax,ind]=max(tmpvec);
                aa1 = ceil(ind/n0);
                aa2 = mod(ind,n0);
                if(aa2==0)
                    aa2=n0;
                end
                dim1 = index4(aa1);
                index3(i) = dim1;
                tmpvec((aa2-1)+1:n0:(n0*(p-n0)))=0;
                tmpvec(n0*(aa1-1)+(1:n0))=0;
            end
            sInd = [index2; index3];
        end
    end
    para.sInd = sInd;
    para.p = length(sInd);
    x = x(:,sInd);
    [mua, mud, Sigma, x1, x2, n1, n2] = stat(x, y);
end

lamMax = max(abs(gamma*mud))*(1-epsilon);
lamMin = lamMax*epsilon;
lamList = logspace(log10(lamMax), log10(lamMin), K);

A = mud;


[wPath, num] = roadCore(A, b, Sigma, lamList, para);


test1 = (x1-repmat(mua', n1, 1))*wPath >0 ;
test2 = (x2-repmat(mua', n2, 1))*wPath <0 ;
error = mean([test1;test2]);

fit.lamList=lamList;
fit.wPath = wPath;
fit.num = num;

fit.error = error;
fit.para = para;
fit.mua = mua;













