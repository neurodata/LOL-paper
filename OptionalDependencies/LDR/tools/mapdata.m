function [newY] = mapdata(Y)
% [newY] = mapdata(Y)
% 
% This function offsets the response vector Y to make it start at Y=1.
% =========================================================================
%.... checking Y is discrete
if ~isinZ(Y),
   error('this function is valid for discrete Y only');
end
%.... mapping Y to 1..h range
newY = zeros(size(Y));
minY = min(Y); 
maxY = max(Y);
newidx = 1;
for idx = minY:maxY,
    newY(Y==idx) = newidx;
    newidx = newidx+1;
end
