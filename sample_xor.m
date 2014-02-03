function [X,Y] = sample_xor(task)

n=task.n;
D=25;

X=randn(n,D);
Y=nan(n,1);
for i=1:n
   if X(i,1) < 0 && X(i,2) > 0
       Y(i) = rand > 0.1;
   else
       Y(i) = rand > 0.9;
   end
end

