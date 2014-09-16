function parameters = read_input_nldr(varargin)
%
% parameters = read_input_nldr(varargin)
%
% This function is used to read optional parameters for fnctions SIR, SAVE
% and DR. They must be given as a string-number pair in which the string specifies 
% the optional parameter and the following input sets its value.
% Available options are limited to:
%     - 'nslices': to set the number of slices to be used to discretize continuous 
%       responses.
%     - 'setmtx': boolean flag used to specify if the computation will rely on previous
%       auxiliary results. This is useful when SIR, SAVE and DR are tested simultaneously. 
%       These methods share procedures that can be performed before computation to speed 
%       up the process. As a flag, allowed values are:
%       - true or 1: to use auxiliary results stored in a global variable by 
%                    using function SETAUX.
%       - false or 0: to perform all computations.

% =========================================================================

parameters.nslices = 0;
parameters.auxhandle = [];

for i=1:2:length(varargin)
    input = varargin{i};
    switch input
        case 'nslices',
            parameters.nslices = varargin{i+1};
        case 'auxmtx',
            parameters.auxhandle = varargin{i+1};
    end
end
            