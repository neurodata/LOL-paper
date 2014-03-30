function [ACC_QDA, timing_QDA, l1, l0] = QDA_MNIST(NofPts_train, NofPts_test)
% QDA_MNIST runs QDA on the MNIST data for a binary classification problem

% Add the data directory to search path
addpath(genpath('/home/collabor/yb8/data/mnist/derived'));

% Add the algorithm directory to search path
addpath(genpath('/home/collabor/yb8/LOL'));

% Load MNIST data
dummy = load('img_test.mat');
Xtest = dummy.images_test;
dummy = load('img_train.mat');
Xtrain = dummy.images_train;
dummy = load('labels_test.mat');
Ytest = dummy.labels_test;
dummy = load('labels_train.mat');
Ytrain = dummy.labels_train;
clear dummy

whos Xtest Xtrain Ytest Ytrain
% Sampling with the input: Nopts
if nargin == 2
    % Use randperm if you want to change the idx every trials
    Xtrain = Xtrain(1:NofPts_train);
    Ytrain = Ytrain(1:NofPts_train);
    Xtest = Xtest(1:NofPts_test);
    Ytest = Ytest(1:NofPts_test);
    % If you want to sample specific number of each digits, use:
    % [X, vLabels]=Generate_MNIST(100.*ones(1,10), struct('Sampling', 'RandN', 'QueryDigits', 0:9, 'ReturnForm', 'vector')); % Xtrain: n = 1000 x p = 784/ Ytrain: n = 1000 x p = 1
    % [Xtrain, Ytrain]=Generate_MNIST(50.*ones(1,10), struct('Sampling', 'RandN', 'QueryDigits', 0:9, 'ReturnForm', 'vector')); % Xtrain: n = 500 x p = 784/ Ytrain: n = 500 x p = 1
end

% Convert Y to binary classification problem
Ytrain(Ytrain<5) = 0; Ytrain(Ytrain>=5) = 1;
Ytest(Ytest<5) = 0; Ytest(Ytest>=5) = 1;
Ytrain(1:10)

% Run classifier
tic;
[Yhat_QDA, l1, l0] = QDA_train_and_predict(Xtrain, Ytrain, Xtest);
timing_QDA = toc;
ACC_QDA = 1 - sum(Ytest~=Yhat_QDA')/(sum(Ytest==Yhat_QDA') + sum(Ytest~=Yhat_QDA'))

end
