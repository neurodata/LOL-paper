function initval = get_initial_estimate(Yaux,X,u,data_parameters,simu_parameters)
% initval = get_initial_estimate(Y,X,u,data_parameters,simu_parameters)
%
% This function gives an initial estimate to start numerical optimization.
% The function first computes several candidates regardless of any specific
% model, and then chooses the best candidate according to a given model.
%
% Output:
%   - initval: orthogonal basis matrix for a dimension reduction subspace
%   that minimizes the objective function FUN_HANDLE among several computed
%   candidates.
% Inputs:
%   - Y: response vector (should be discretized in order to compute estimates 
%   based on SIR, SAVE, etc).
%   - X: matrix of predictors.
%   - u: dimension of the reduction subspace being looked for.
%   - data_parameters: structure with basic statistics from the sample
%   (means, conditional covariance matrices, marginal covariance matrix,
%   sample size for each value of Y)
%   - simu_parameters: structure with specific settings for computations

% =========================================================================

Ys = valin(X,Yaux,u,data_parameters,simu_parameters);
initval = @get_guess;
    function Y = get_guess(fun_handle)
        imax = size(Ys,1);
        m = size(Ys,2);
        n = size(Ys,3);
        Fi = zeros(imax,1);
        for i=1:imax
            Fi(i) = fun_handle(reshape(Ys(i,:,:),m,n));
        end
        % the Y given the minimum value is our guess
        minIndex = argmin(Fi);
        Y = reshape(Ys(minIndex,:,:),m,n);
    end
end
        
