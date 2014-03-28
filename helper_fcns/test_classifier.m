function [output ] = test_classifier(data, classifier)
%test_classifier tests the performance of the classifier and the interim estimations
%   data: [1] randsamp: random sample tbimodal from multivariate normal distribution
%         [2] fisheriris: fisher iris data
%         [3] mnist:    mnist data
%   classifier: [1] lda
%               [2] qda
%               [3] lol
%               [4] qol
%               [5] qoq

  % Load/Generate Data
  if strcmp(data, 'randsamp')
      %       % Generalizing the following setting for p dim
      %       mu1 = [1 -1]; Sigma1 = [.9 .4; .4 .3];
      %       X1 = mvnrnd(mu1, Sigma1, 500)'; % p = 2 x n = 500 matrix
      %       mu2 = [4 3]; Sigma2 = [.9 -.4; -.4 .3]';
      %       X2 = mvnrnd(mu2, Sigma2, 500)'; % p = 2 x n = 500 matrix
      %       X = [X1 X2]; % p = 2 x n = 1000
      %       figure; plot(X(1,:), X(2,:), 'x');
      
      p = 5; n = 8;
      mu0 = -3; mu1 = 3;
      sigma0_d = 0.5; sigma0_c = 0.1;
      sigma1_d = 0.5; sigma1_c = 0.1;
      
      
      Mu0 = mu0.*rand(p,1);
      Mu1 = mu1.*rand(p,1);
      
      % Generate two symmetric covariance matrices for two classes
      c = sigma0_c.*rand(p,1);
      Sigma0 = toeplitz(c) + sigma0_d.*eye(p); clear c;
      c = sigma1_c.*rand(p,1);
      Sigma1 = toeplitz(c) + sigma1_d.*eye(p); clear c;
      
      X0 = mvnrnd(Mu0, Sigma0, 500)'; % p = 2 x n = 500 matrix
      X1 = mvnrnd(Mu1, Sigma1, 500)'; % p = 2 x n = 500 matrix
      X = [X0 X1]; % p = 2 x n = 1000
      
  elseif strcmp(data, 'fisheriris')
      disp('The type of data is updated soon.');
  elseif strcmp(data, 'mnist')
      disp('The type of data is updated soon.');
  else
      disp('The type of data is not supported in this test function.');
  end
  
  
  
  % Test whether the covariance matrices for groups are PD, different, and
  % estimated well (if known params).
  % Test PD: Later-to-be-changed with chol function, which is faster.
  if ~all(eig(Sigma0) > 0)
      disp('Covariance matrix generated for class 0 is NOT positive definite.');
  elseif ~all(eig(Sigma1) > 0)
      disp('Covariance matrix generated for class 1 is NOT positive definite.');
  else
      disp('Covariance matrices generated are positive definite.')
  end
  
  % Test estimation performance for covariance matrices with Frobenius norm
  Phat.mu0 = mean(X0,2);
  Phat.mu1 = mean(X1,2);
  Phat.Sigma0 = cov(X0');
  Phat.Sigma1 = cov(X1');
  
  % Run the classifier
  if strcmp(classifier, 'lda')
      disp('The type of data is updated soon.'); 
  elseif strcmp(classifier, 'qda')
      [Yhat, Phat] = QDA_train_and_predict(Xtrain, Ytrain, Xtest)
  elseif strcmp(classifier, 'lol')
      disp('The type of data is updated soon.'); 
  elseif strcmp(classifier, 'qol')
      disp('The type of data is updated soon.');       
  elseif strcmp(classifier, 'qoq')
      disp('The type of data is updated soon.');       
  end
      
end

