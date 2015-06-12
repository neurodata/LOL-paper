function [data,header,colheaders] = loadDATA4gui(file)
% 
% function [data,header] = loadDATA4gui(file)
% 
% This function allows to read data files with arbitrary headers. Data are
% stored in matrix DATA and comments are given in output structure HEADER.
% For data files organized as labeled columns, column headers are retrieved
% upon request in a third output variable, i.e:
% [data,header,colheaders] = loadDATA(file);
%
% Notice this function is very close to the getDATA function. The only
% difference aims at reading formatted data regardless of the delimiter 
% used in the file. 
% =========================================================================

%------checking inputs
if nargin<1,
    error('Not enough input arguments');
end
if ~ischar(file),
    error('File name must be a string');
end
fid = fopen(file);
if fid==-1
  error('File not found or permission denied');
end

%-------initialization
nlines = 0;
nchars = 0;
data = [];
header = [];
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
%--------reading data
data = [data; fscanf(fid,'%f')];
fclose(fid);
eval('data = reshape(data, ncols, length(data)/ncols)'';', '');


if nargout > 2,
   colheaders = [];
   if ~isempty(header),
       aux = textscan(header(end,:),'%s'); 
       if max(size(aux{:}))==size(data,2),
           colheaders = cellstr(aux{:});
%             for j=1:size(aux,1),
%                 colheaders = strvcat(colheaders,aux{j});
%             end
       else
           colheaders = cell(size(data,2),1);
            for j=1:size(data,2),
                colheaders{j} = ['column',int2str(j)];
            end
       end
   else
       colheaders = cell(size(data,2),1);
       for j=1:size(data,2),
           colheaders{j} = ['column',int2str(j)];
       end
   end
end





    
