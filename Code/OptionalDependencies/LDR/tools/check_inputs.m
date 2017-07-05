function OK = check_inputs(Y,X,method,morph,dim)
%
% OK = check_inputs(Y,X,method,morph,dim)
%
% Auxiliary function to check consistency of input arguments. It returns
% true when all is right.
%  - inputs:
%     Y: Response vector. 
%     X: Data matrix. Each row is an observation. 
%     method: a string identifying the dimension reduction method to apply.
%     morph: 'cont' for continuous responses (regression) or 'disc' for
%     discrete responses (discrimination)
%     dim: Dimension of the reduction subspace or string identifying the 
%     method to infer it ('aic', 'bic', 'lrt', 'perm'). 


%----checking data consistency.............................................
if ~isreal(Y),
    error('Response vector must be numeric');
end
[n,p] = size(X);
if length(Y) ~= n,
    error('The number of rows in Y must equate the number of rows in X');
end
if ~ischar(method),
    error('type mismatch error for input argument METHOD');
end
if ~(strcmpi(morph,'cont') || strcmpi(morph,'disc')),
    error('unknown type of response. Valid options are CONT or DISC...');
end
if ~ischar(dim)
    if ~isinZ(dim)
        error('Natural value expected to specify reduced subspace dimension.');
    else
        if dim(1) > p,
            error('Desired dimension must be smaller than current dimension');
        elseif dim(1)==0,
            error('Desired dimension must be greater than u=0')
        end
    end
end
OK = true;