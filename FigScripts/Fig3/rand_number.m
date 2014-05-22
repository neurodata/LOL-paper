function X=rand_number(size,mode)
% Generates heavy-tail centered random vector of size 'size' (iid entries)
% Each component has variance 1.9125
q=2.0; % number of moments is q-eps
alpha=500^(-1); % outlier weight in a mixture
%%
inv=@(z)(1./z-1).^(1/q);
inv2=@(z)tan((pi/2).*z);
inv3=@(z)(1./(1-z)-1).^(1/1);
%%
if (strcmp(mode,'cube'))
    X_1=inv(rand(size,1));
    X_2=inv(rand(size,1));
    X=X_1-X_2;
end
%%
if (strcmp(mode,'tail2'))
    X_1=inv3(rand(size,1));
    X_2=inv3(rand(size,1));
    X=X_1-X_2;
end
%%
if (strcmp(mode,'sphere'))
    r=sqrt(size)*(inv(rand(1,1)));
    Z=randn(size,1);
    X=(r/norm(Z))*Z;
end
%%
if (strcmp(mode,'cauchy'))
   X=inv2(rand(size,1));
end
if (strcmp(mode,'mixture'))
    z=(rand(size,1)<alpha);  
    X=(ones(size,1)-z).*randn(size,1)+z.*sign(randn(size,1)).*alpha^(-1);
    %X=(ones(size,1)-z).*randn(size,1)+z.*randn(size,1).*alpha^(-1);
end
