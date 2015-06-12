function [WX,W,auxmtx] = DR(Yaux,X,morph,dim,varargin)
% function [WX,W] = DR(Y,X,morph,u,varargin)
%
% This function implements the DR procedure for sufficient dimensionality 
% reduction. See references for details.
% 
% USAGE:
%   - outputs:
%     WX: projection of the predictors onto the dimension reduction subspace.
%     W: generating vectors of the dimension reduction subspace.
%     auxmtx: an auxiliary matrix with partial computations that can be
%     used to compute SAVE and SIR reductions.
%   - inputs:
%     Y: response vector.
%     X: predictors matrix.
%     morph: with value 'cont', specifies that the response Y is continuous 
%     (in which case it is a regression problem) while with value 'disc' it
%     specifies a discrete response (and a classification problem).
%     u: dimension for the reduced subspace.
%     varargin: optional arguments. They must be given as a 'OptionName', 'OptionValue' 
%     pair. Available options are limited to:
%     - 'nslices': to set the number of slices to be used to discretize continuous 
%       responses.
%     - 'auxmtx': to pass an auxiliary matrix computed with function
%     SETAUX, from which the DR reduction can be easily extracted. This is
%     useful when DR is used along with SAVE and SIR, as they share some
%     partial computations.


% =========================================================================

%----checking required arguments...........................................
if nargin < 4,
    error('Not enough input arguments. Type >>help ldr for details');
end
% .........................................................................

%----checking data consistency.............................................
if size(Yaux,1)~=size(X,1),
    error('The number of rows in Y must equate the number of rows in X');
end
if ~strcmpi(morph,'cont') && ~strcmpi(morph,'disc'),
    error('unknown type of response. Valid options are CONT or DISC...');
end
if ~ischar(dim) && ~isinZ(dim),
    error('Natural value expected to specify reduced subspace dimension.');
end
if ~isreal(Yaux),
    error('Response vector must be numeric');
end

%----reading optional input arguments and saving parameters................
parameters = read_input_nldr(varargin{:});

%----checking type of response and slicing if needed.......................
if strcmpi(morph,'disc'),
    Y = mapdata(Yaux);
    parameters.nslices = max(Y);
else % morph = 'cont'
    if parameters.nslices==0,
        warning('MATLAB:slices','for continuous responses, a number of slices should be given. Five slices will be used');
        parameters.nslices = 5;
    end
    Y = slices(Yaux,parameters.nslices);
end        

sigmag = get_cov(X);
p = size(sigmag,2);
[V,D] = eig(sigmag);
if isempty(parameters.auxhandle),
    parameters.auxhandle = setaux(X,Y,parameters.nslices,p,V,D);
end
auxmtx = parameters.auxhandle;
DRdir = getDR(dim,p,auxmtx);

%-----Write results------------------------
W = DRdir(:,1:dim);
WX = X*W;
    
    
