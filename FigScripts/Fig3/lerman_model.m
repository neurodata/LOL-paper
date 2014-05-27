function [X, V]=lerman_model(N0,N1,D,d,noise)

V=orth(rand(D,d));
X=randn(N0,d)*V';
X=[X;rand(N1,D)];
X=X+randn(size(X))*noise;
