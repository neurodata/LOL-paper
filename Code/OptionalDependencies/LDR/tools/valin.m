function [val]= valin(X,Y,u,data_parameters,simu_parameters)
%
% val = valin(X,Y,u,h)
% 
% Auxiliary function used when looking for an initial estimate for likelihood
% maximization.
% USAGE:
%  - outputs:
%     - val: an array of initial value candidates.
%  - inputs:
%     - X: matrix of predictors
%     - Y: response vector
%     - u: desired dimension for the reduced subspace
%     - h: number of different values in Y. When Y is continuous, h is the
%     number of slides used for its discretization. When Y is discrete, h
%     is the number of different classes in the analized data.
%
% Current implementation computes the following candidates:
%   - SIR, SAVE and DR estimates
%   - PLS estimate
%   - first u eigenvectors of each conditional covariance matrix
%   - estimates based on eigendecomposition of the marginal covariance
%   matrix. If all the combinations of u eigenvectors are less than 5000,
%   all of them are given. Otherwise, just a single estimate based on the
%   first u eigenvectors is given in order to speed up computations.
%   
% =========================================================================      

sigma = data_parameters.sigma;
sigmag = data_parameters.sigmag;
sizes = data_parameters.n;
h = simu_parameters.nslices;
valin_type = simu_parameters.initvalue;
if strcmpi(valin_type,'basic'),
    val = valin_basic(X,Y,u,h,sigma,sigmag,sizes);
elseif strcmpi(valin_type,'intermediate'),
    val = valin_intermediate(X,Y,u,h,sigma,sigmag,sizes);
else
    val = valin_full(X,Y,u,h,sigma,sigmag,sizes);
end


%% valin_basic
function [val]= valin_basic(X,Y,u,h,sigma,sigmag,sizes)
    p = size(sigmag,2);
    %----initialize output val-------------------------------------------------
    val = zeros(5+h+1,p,u);
    %----compute all eigenvectors of marginal covariance matrix----------------
    [V,D] = eig(sigmag);
    %----take the first u eigenvectors of marginal covariance matrix as directions---
    [diaguD,idx] = sort(diag(D),'descend'); 
    val(1,:,:) = V(:,idx(1:u));
    %----compute additional directions based on SIR, SAVE, and DR--------------
    auxmtx = setaux(X,Y,h,p,V,D);
    val(1+1,:,:) = getSIR(u,auxmtx);
    val(1+2,:,:) = getSAVE(u,p,auxmtx);
    val(1+3,:,:) = getDR(u,p,auxmtx);
    %----compute additional directions based on conditional covariance matrices
    aux = get_more(sigma,sizes,p,h,u);
    val((1+3+1):(1+3+h),:,:) = aux(1:h,:,:);
    %----compute additional directions based on PLS
    % val((1+3+1),:,:) = pls4sdr(X,Y,u);
    val((1+3+h+1),:,:) = pls4sdr(X,Y,u);
    val((1+3+h+1+1),:,:) = val(1+1,:,:); val((1+3+h+1+1),:,u) = val(1+2,:,1);

%% valin_full
function [val]= valin_full(X,Y,u,h,sigma,sigmag,sizes)
p = size(sigmag,2);
comb = nchoosek(p,u);
%----compute all eigenvectors of marginal covariance matrix----------------
[V,D] = eig(sigmag);
%----compute additional directions based on SIR, SAVE, and DR--------------
auxmtx= setaux(X,Y,h,p,V,D);

%----initialize output val-------------------------------------------------
if comb<5000,
    val = zeros(comb+3+h+2+1+1,p,u);
    %----take any u eigenvectors of marginal covariance matrix as directions---
    val(1:comb,:,:) = get_combeig(V,p,u);
    val(comb+1,:,:) = getSIR(u,auxmtx);
    val(comb+2,:,:) = getSAVE(u,p,auxmtx);
    val(comb+3,:,:) = getDR(u,p,auxmtx);
    val((comb+3+1):(comb+3+h+2),:,:) = get_more(sigma,sizes,p,h,u);
    val((comb+3+h+2+1),:,:) = pls4sdr(X,Y,u);
    val((comb+3+h+2+1+1),:,:) = val(comb+1,:,:); val((comb+3+h+2+1+1),:,u) = val(comb+2,:,1);
else
    val = zeros(1+3+h+2+1+1,p,u);
    warning('LDR:toomany','Due to the size of p and u, a reduced number of candidates will be used for initialization');
    %----take the first u eigenvectors of marginal covariance matrix as directions---
    [diaguD,idx] = sort(diag(D),'descend'); 
    val(1,:,:) = V(:,idx(1:u));
    val(1+1,:,:) = getSIR(u,auxmtx);
    val(1+2,:,:) = getSAVE(u,p,auxmtx);
    val(1+3,:,:) = getDR(u,p,auxmtx);
    val((1+3+1):(1+3+h+2),:,:) = get_more(sigma,sizes,p,h,u);
    val((1+3+h+2+1),:,:) = pls4sdr(X,Y,u);
    val((1+3+h+2+1+1),:,:) = val(1+1,:,:); val((1+3+h+2+1+1),:,u) = val(1+2,:,1);
end


%% valin_intermediate
function [val]= valin_intermediate(X,Y,u,h,sigma,sigmag,sizes)
p = size(sigmag,2);

if u>10 
    error('I cannot apply this option for your data. Choose FULL or BASIC.');
end
pp = min(10,p);
comb = nchoosek(pp,u);

%----compute all eigenvectors of marginal covariance matrix----------------
[V,D] = eig(sigmag);
%----compute additional directions based on SIR, SAVE, and DR--------------
auxmtx= setaux(X,Y,h,p,V,D);

%----initialize output val-------------------------------------------------
val = zeros(comb+3+h+2+1+1,p,u);
%----take any u eigenvectors of marginal covariance matrix as directions---
val(1:comb,:,:) = get_combeig(V,pp,u);
val(comb+1,:,:) = getSIR(u,auxmtx);
val(comb+2,:,:) = getSAVE(u,p,auxmtx);
val(comb+3,:,:) = getDR(u,p,auxmtx);
val((comb+3+1):(comb+3+h+2),:,:) = get_more(sigma,sizes,p,h,u);
val((comb+3+h+2+1),:,:) = pls4sdr(X,Y,u);
val((comb+3+h+2+1+1),:,:) = val(comb+1,:,:);  val((comb+3+h+2+1+1),:,u) = val(comb+2,:,1);
