function [Y,X] = findindata(Yfull,Xfull,desired)
%
% findindata(Yfull,Xfull,desired)
%
% This function extracts observations related to given values of Y from the 
% whole data arrays. It is intended to help at extracting data for specific
% populations when Y is discrete.
%
% USAGE:
%  outputs: Y,X: desired observations from Yfull and Xfull
%  inputs: Yfull,Xfull: the whole data
%          desired: vector with the populations to get from data.
%==========================================================================
Y = [];
X = [];
for k=1:length(desired),
    idx = find(Yfull == desired(k));
    Yfull(idx) = k;
    Y = [Y; Yfull(idx)];
    X = [X; Xfull(idx,:)];
end