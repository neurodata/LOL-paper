function simupars = read_inputs(model,varargin)
%
% read_inputs(model,varargin)
%
% This function serves as an interface function for finding optional inputs
% for the working model when calling it through the LDR function. 
%
% =========================================================================
simupars.model = model;
simupars.nslices = 0;
simupars.alpha = 0.05;
simupars.nsamples = 500;
simupars.initvalue = [];
simupars.sg = [];
simupars.maxiter = 1000;
simupars.fy = [];

idx = [];
noptarg = length(varargin);
if noptarg>0,
  for i=1:2:noptarg,
    input = varargin{i};
    if ischar(input),
        switch lower(input),
            case 'nslices',
                simupars.nslices = varargin{i+1};
				idx = [idx i i+1];
            case 'alpha',
                simupars.alpha = varargin{i+1};
				idx = [idx i i+1];
            case 'npermute',
                simupars.nsamples = varargin{i+1};
				idx = [idx i i+1];
            case 'initval',
                simupars.initvalue = varargin{i+1};
                idx = [idx i i+1];
            case 'maxiter',
                simupars.maxiter = varargin{i+1};
                idx = [idx i i+1];
            case 'fy',
                simupars.fy = varargin{i+1};
                idx = [idx i i+1];
        end
    end
  end
  varargin(idx) = [];
  if ~isempty(varargin),
      for i=1:length(varargin)
          simupars.sg{i} = varargin{i};
      end
  end
end
