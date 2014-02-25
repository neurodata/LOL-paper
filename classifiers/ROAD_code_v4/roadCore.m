% This function implements the ROAD
% Algorithm for the following optimization problem:
% minimize 0.5 * w' \Sigma w + \lambda |w|_1 + 1/2 \gamma (Aw-b)^T (Aw-b)
% x: n*p matrix
% y: label for the data, 0/1, or 1/2.
function [wPath, num] = roadCore(A, b, Sigma, lamList, para)
%%%%%%%%%%K: number of lambdas on the log-scale
%%%%%%%%%%epsilon: lamMin=lamMax*epsilon

iterMax = para.iterMax;
epsCon = para.epsCon;
%epsilon = para.epsilon;
K = para.K;
gamma = para.gamma;
p = para.p;

A1List = gamma*A;
cons = A1List.^2/gamma + diag(Sigma);

%%%starting the algorithm
wPath = zeros(p,K);
w0=zeros(p,1);
num = zeros(K,1);
pv = 1:p;
for i=1:K
    %     if(trace=='T' && mod(i,10)==0)
    %         disp(['i=',num2str(i),'number of nonzero coefficients:',num2str(length(find(w0(abs(w0)>0))))]);
    %     end
    lambda=lamList(i);
    
    %%%Loop once
    
    wlast = w0;
    
    
    iterInd = 1;
    for j = 1:p
        uHat = A1List(j)*b - (Sigma(:,j)+gamma*A(j)*A)'*w0 + (Sigma(j,j)+gamma*A(j)^2)*w0(j);
        w0(j) = sign(uHat)*max(0,(abs(uHat)-lambda))/cons(j);
    end
    error = sum(abs(w0-wlast));
    while(error>epsCon)
        iterInd = 1;
        S1 = find(w0);
        
        while(error > epsCon && iterInd < iterMax)
            %%%%starting coordinate-wise descent
            iterInd = iterInd+1;
            wlast = w0;
            
            for j = pv(S1)
                uHat = A1List(j)*b - (Sigma(:,j)+gamma*A(j)*A)'*w0 + (Sigma(j,j)+gamma*A(j)^2)*w0(j);
                w0(j) = sign(uHat)*max(0,(abs(uHat)-lambda))/cons(j);
            end
            error = sum(abs(w0-wlast));
 %           display(['error=',num2str(error), ' IterInd=', num2str(iterInd)]);
        end
        wlast = w0;
        for j = 1:p
            uHat = A1List(j)*b - (Sigma(:,j)+gamma*A(j)*A)'*w0 + (Sigma(j,j)+gamma*A(j)^2)*w0(j);
            w0(j) = sign(uHat)*max(0,(abs(uHat)-lambda))/cons(j);
        end
        error = sum(abs(w0-wlast));
    end
    if(iterInd == iterMax)
        display(['Unable to converge...at step', num2str(i)]);
    end
    
    wPath(:,i) = w0;
    num(i) = length(find(w0));
    % plot(wPath)
end

















