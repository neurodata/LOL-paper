function [Y,X] = getDATA(file,delimiter,Ycol,Xcols)
%
% [Y,X] = getDATA(file,delimiter,Ycol,Xcols)
%
% This function provides an utility lo read data from a file.
%
% USAGE:
% - outputs:
%     Y: response vector;
%     X: predictors;
% - inputs:
%     file: name of the file where data is stored;
%     delimiter: specifies the delimiter that separates columns in the
%     data file (i.e. ' ' for a white space or ';' for comma separated data).
%     Ycol (OPTIONAL): specifies which column of the data array is to be
%     considered as the response. If no argument is given, the first column
%     is considered as the response.
%     Xcols (OPTIONAL): specifies which columns of the data array are to be
%     considered as predictors. If no argument is given, all columns aside
%     the response are considered as predictors.
% =========================================================================

if nargin<2,
    delimiter = ' ';
end

data = loadDATA(file,delimiter);

if nargin < 3,
    Ycol = 1;
end
Yaux = data(:,Ycol);

if nargin < 4,
    data(:,Ycol) = [];
    X = data;
else
    X = data(:,Xcols);
end

Y = Yaux;
