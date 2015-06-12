function diff = dF(dfun_handle,FParameters)
%
% diff = dF(dfun_handle,FParameters)
%
% Generic nested function to compute the derivative of F. The function first sets
% a handle to the specific derivative and fixes the parameters from the
% sample needed for its computation. The handle fixed with those parameters
% is then evaluated at a given value for argument W.
%
%   dfun_handle: handle to the function derivative for a specific model.
%   FParameters: fixed parameters needed to compute the derivative.
%   W: argument for computing the derivative.
% =========================================================================
diff = @evaluate_diff;
    function diffval = evaluate_diff(W)
        diffval = dfun_handle(W,FParameters);
    end
end

