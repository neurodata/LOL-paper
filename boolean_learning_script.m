clear all

n=50;
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

chance=sum(Y)/length(Y);
chance=min(chance,1-chance);

ntrees=100;
options.UseParallel='on';
B = TreeBagger(200,X,Y,'OOBPred','on');

err=oobError(B);

ntest=500;
Xtest=randn(ntest,D);
Ytest=nan(ntest,1);
for i=1:ntest
   if Xtest(i,1) < 0 && Xtest(i,2) > 0
       Ytest(i) = rand > 0.1;
   else
       Ytest(i) = rand > 0.9;
   end
end

[~, scores] = predict(B,Xtest);
Ytest_hat=scores(:,1)<scores(:,2);
%%
figure(1), clf
plot(err), hold on, plot([1 ntrees],[chance chance],'k');
xlabel('number of grown trees')
ylabel('out-of-bag classification error')