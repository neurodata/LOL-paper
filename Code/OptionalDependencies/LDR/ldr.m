function [WX,W,maxlik,d] = ldr(Y,X,method,morph,dim,varargin)
%
% [WX,W,L,d] = ldr(Y,X,method,morph,dim,varargin)
%
% This function implements model-based sufficient dimensionality reduction 
% for normal densities using maximum likelihood estimation. 
%
% USAGE:
%  - outputs:
%    WX: projection of the predictors onto de estimated central subspace.
%    W:  generating vectors for the estimated central subspace.
%    L:  likelihood at the optimal point.
%    d: dimension of the estimated central subspace. (This is only useful when estimating
%       the optimal dimension describing the data, though even in that case 
%       it can be infered from W.)
%  - inputs:
%    Y: response vector.
%    X: predictors matrix (each column is expected to be a different predictor).
%    method: the method to be used for dimension reduction. So far, accepted methods are:
%            'PFC': principal fitted components (Cook and Forzani, 2008-a)
%            'IPFC': isotonic principal components (Cook 2007)
%            'EPFC': extended principal components (Cook 2007)
%            'SPFC': structured principal components (Cook and Forzani,2009-a)
%            'CORE': covariance reduction (Cook and Forzani, 2008)
%            'LAD': likelihood acquired directions (Cook and Forzani, 2009b)
%
%    morph: with value 'cont', it specifies that the response Y is continuous 
%        (in which case it is a regression problem) while with value 'disc'
%        it specifies a discrete response (and a classification problem)
%    dim: dimension of the central subspace you are looking for, or criterion 
%         to find it. Available citeria are 
%         'aic', for Akaike's information criterion; 
%         'bic', for Bayes' information criterion; 
%         'lrt', for likelihood-ratio test; and
%         'perm', for permutation test.
%    varargin: group of optional arguments. group of optional arguments. They can be set 
%         in any order. They must be given as a 'ArgumentName', 'ArgumentValue' pair. 
%         Available options depend on the selected model:
%              - LAD: 
%              'nslices': to set the number of slices for continuous response slicing.	
%                       Default value is h=5.
%              'alpha': to set the confidence level for likelihood-ratio tests and 
%              permutation tests. Default value is alpha=0.05.				 
%              'npermute': to set the number of permutation  samples for permutation
%              tests. Default value is npermute=500.
%              'initval': to set an initial estimate to start optimization.
%              If no value is given, an initial estimate is guessed
%              from several computation regarding eigendecomposition of
%              conditional and marginal covariance matrices, along with estimates 
%              such as SIR, SAVE and DR (===NOTE: all combinations of eigenvectors 
%              of the marginal covariance matrix are searched for the best initial 
%              estimates by default. However, when this number of combinations is very
%              large (actually 5000 in current implementation), only the
%              first dim eigenvectors are searched for the best initial value.
%
%              other: optional arguments for Stiefel-Grassmann optimization. See SG_MIN
%              documentation for details. In addition to the original optional
%              inputs in SG_MIN, you can set the maximum number of iterations to be
%              used for estimation of the central subspace.
%              - CORE: 
%              'nslices', 'alpha', 'npermute', 'initval' and the optional inputs for the 
%              SG_MIN package, with the same meaning as above. 
%              - PFC:
%              'alpha': to set the number of samples for permutation tests.
%              Default value is alpha=0.05.
%              'fy': to set a regression matrix to estimate the fitted
%              covariance matrix. If no such matrix is given, a polynomial
%              basis of order r is used, with r=max(dim+1,3) where dim is
%              the dimension of the reduced subspace to look for.
%              - IPFC: 
%              'alpha' and 'fy', as above for PFC. 
%              - SPFC: 
%              'alpha' and 'fy', as above for PFC. 
%              - EPFC: 
%              'alpha' and 'fy', as above for PFC, and 'initval' as in LAD
%              and CORE.
%
% EXAMPLES:
%    - for regression, slicing the continous response into 10 slices, 
%      and looking for a subspace of dimension 3:
%      [WX,W,L,d] = ldr(Y,X,'LAD','cont',3,'nslices',10)
%    - same as above, but estimating the dimension by using Likelihood-ratio 
%      test with confidence level of 0.05:
%      [WX,W,L,d] = ldr(Y,X,'LAD','cont','lrt','nslices',10,'alpha',0.05)
%    - for classification,  looking for a subspace of dimension 2 and using W0 as initial value:
%      [WX,W,L,d] = ldr(Y,X,'LAD','disc',2,'initval',W0)

%  ==================================================================================

%----checking required arguments...........................................
if nargin < 5,
    error('Not enough input arguments. Type "help ldr" for details');
end

%----checking consistency of inputs........................................
dataOK = check_inputs(Y,X,method,morph,dim);

if dataOK,
    
%----reading optional input arguments and saving parameters................
    if nargin > 5
        param = read_inputs(method,varargin{:});
    else 
        param = read_inputs(method);
    end

%----Optimization----------------------------------------------------------
   if ischar(dim),
       fun = str2func([lower(dim) upper(method)]); % builds handle to model function
      [W,d,f] = fun(Y,X,morph,param); % executes function
   else
      d = dim;
      fun = str2func(lower(method));
      [W,f] = fun(Y,X,dim,morph,param);
   end
   maxlik = -f;
   WX = X*W;
   
end
