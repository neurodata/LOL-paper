clearvars
clc

%% get X
filename = '/Users/jovo/Research/projects/A/SDA/data/raw/alon/X.txt';
% For more information, see the TEXTSCAN documentation.
formatSpec = '%14f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'EmptyValue' ,NaN, 'ReturnOnError', false);
fclose(fileID);
X = [dataArray{1:end-1}]';

%% get Y

filename = '/Users/jovo/Research/projects/A/SDA/data/raw/alon/Y.txt';
delimiter = '';
formatSpec = '%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
fclose(fileID);
Z = [dataArray{1:end-1}];
Y = (Z>0);

%%
save('/Users/jovo/Research/projects/A/SDA/data/base/alon.mat','X','Y');