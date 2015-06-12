function [data,header,colheaders] = loadDATA(file,delim)
% 
% function [data,header] = loadDATA(file)
% 
% This function allows to read data files with headers. Data is
% stored in matrix DATA and comments are given in output structure HEADER.
% For data files organized as labeled columns, column headers are retrieved
% upon request in a third output variable, i.e:
% [data,header,colheaders] = loadDATA(file);
%
% By default, the function assumes that columns are separated by white
% spaces. If this is not the case, the actual delimiter should be given as
% an input. For example, to read a comma separated file use:
% [data,header] = loadDATA(filename,';')
% =========================================================================

%------checking inputs
if nargin<1,
    error('Not enough input arguments');
end
if ~ischar(file),
    error('File name must be a string');
end
if nargin<2,
    delim = ' ';
end
fid = fopen(file);
if fid==-1
  error('File not found or permission denied');
end

%-------initialization
nlines = 0;
nchars = 0;
header = '';
line = fgetl(fid);
if ~ischar(line),
    warning('LDR:emptyfile','file seems to be empty');
end
[data, ncols, errmsg, nxtindex] = sscanf(line, '%f');
lastline = line;

%--------reading header
while isempty(data)||(nxtindex==1),
    nlines = nlines + 1;
    nchars = max([nchars length(line)]);
    header = strvcat(header,line);
    if ~isempty(line),
        lastline = line;
    end
    line = fgetl(fid);
    if ~ischar(line),
        warning('LDR:emptyfile','file seems to be empty');
        break;
    end
    [data, ncols, errmsg, nxtindex] = sscanf(line, '%f');
end
fclose(fid);
%--------reading data
aux = importdata(file,delim,nlines);
if isstruct(aux),
    data = aux.data;
    if nargout > 2,
        aux = textscan(lastline,'%s'); 
        if length(aux)~=size(data,2),
            colheaders = aux{1};
        else
            colheaders = cell(size(data,2),1);
            for j=1:size(data,2),
                colheaders{j} = ['column' int2str(j)];
            end
        end
    end
else
    data = aux;
    colheaders = cell(size(data,2),1);
    for j=1:size(data,2),
        colheaders{j} = ['column' int2str(j)];
    end
end




    
