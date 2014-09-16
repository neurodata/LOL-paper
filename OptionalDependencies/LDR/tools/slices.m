function Y = slices(y,h)
%
% Y = slices(y,h)
% 
% This function discretizes continuous response y into h slices.
% USAGE:
%  - outputs:
%    Y: discretized, integer-valued response vector. Y takes values 1:h;
%  - inputs:
%    y: continuos response vector.
%    h: number of slices to use for response discretization.
% ------------------------------------------------------------------   
A=sort(y);
corte=floor(size(y,1)/h);
Y=h*ones(size(y));
Y(y<=A(corte))=1;
for j=1:(h-1)
   Y(y>A(j*corte) & y<=A((j+1)*corte))=j+1;
end

