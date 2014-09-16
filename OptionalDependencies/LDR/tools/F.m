function f = F(fun_handle,FParameters)
%
% f = F(fun_handle,FParameters)
%
% Generic nested function to compute the objective function F. The function first 
% sets a handle to the specific model function and fixes the parameters from 
% the sample needed for its computation. The handle fixed with those 
% parameters is then evaluated at a given value for argument W.
%
%   fun_handle: handle to the objective function for a specific model.
%   FParameters: fixed parameters needed to evaluate the objective function.
%   W: argument for computing the derivative.
% =========================================================================

f = @evaluate_fun;
    function fval = evaluate_fun(W,varargin)
        fval = fun_handle(W,FParameters,varargin{:});
    end
end

