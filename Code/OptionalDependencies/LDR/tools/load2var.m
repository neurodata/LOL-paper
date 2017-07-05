function [dataobj,header] = load2var(filename)
% 
% [dataobj,header] = load2var(filename)
% 
% This function allows to read data files with headers and store them in 
% separate fields of structure DATAOBJ, which can be used then as separate 
% variables. Text comments are given in output structure HEADER.
% As an example, suppose the file stores values for variables 
% 'size', 'weight' and 'age', and that those names appear in a header line 
% above numeric data. Using this function as above you will get three fields 
% in DATAOBJ named: dataobj.size, dataobj.wieght and dataobj.age wich are
% column vectors with the corresponding data.
%       
% Notice this function should be used only when labels for different
% variables are provided in the data file. Otherwise, default names such as 
% 'dataobj.column1', 'dataobj.column2' and so on will be returned.
% =========================================================================

%------checking inputs
if nargin<1,
    error('Not enough input arguments');
end
if ~ischar(filename),
    error('filename must be a string');
end
fid = fopen(filename);
if fid==-1
  error('File not found or permission denied');
end

%-------initialization
nlines = 0;
nchars = 0;
dataobj = [];
header = [];
line = fgetl(fid);
if ~ischar(line),
    warning('LDR:emptyfile','file seems to be empty');
end
[data, ncols, errmsg, nxtindex] = sscanf(line, '%f');


%--------reading header
while isempty(data)||(nxtindex==1),
    nlines = nlines + 1;
    nchars = max([nchars length(line)]);
    header = strvcat(header,line);
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


%-------setting labels for columns
   if ~isempty(header),
       aux = textscan(header(end,:),'%s'); 
       if max(size(aux{:}))==size(data,2),
           aux = cellstr(aux{:});
           colheaders = cell(size(aux,1),1);
            for j=1:size(aux,1),
                colheaders{j} = aux{j};
            end
       else
           colheaders = cell(size(data,2),1);
            for j=1:size(data,2),
                colheaders{j} = ['column',int2str(j)];
            end
       end
   else %----default names for variables....
       colheaders = cell(size(data,2),1);
       for j=1:size(data,2),
            colheaders{j} = ['column',int2str(j)];
       end
   end

   
%------ creating variables named as the labels....
for col = 1:length(colheaders),
    eval(strcat('dataobj.',colheaders{col}, ' = data(:,col);'));
end





    
