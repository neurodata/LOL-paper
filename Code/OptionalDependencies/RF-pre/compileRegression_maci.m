% Script file: compileRegression_maci.m
% - create Matlab Mex versions of Regression 'Random Forest'

% Notes: you must change to the SRC directory before calling this:

mex mex_regressionRF_train.cpp reg_RF.cpp cokus.cpp -o mexRF_train -DMATLAB 
mex mex_regressionRF_predict.cpp reg_RF.cpp cokus.cpp -o mexRF_predict -DMATLAB 

