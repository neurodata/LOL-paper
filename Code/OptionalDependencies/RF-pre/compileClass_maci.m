% Script file: compileClass_maci.m
% - create Matlab Mex versions of 'Random Forest'

% Notes: you must change to the SRC directory before calling this

% cokus:
fprintf('Compiling Cokus (random number generator)...\n');
system('g++ -fno-common -no-cpp-precomp -c cokus.cpp -o cokus.o;');

% rfsub:
fprintf('Compiling rfsub.f (fortran subroutines)...\n');
system('/usr/local/bin/gfortran -DMX_COMPAT_32 -fno-common -c rfsub.f -o rfsub.o;');

% rfutils:
fprintf('Compiling rfutils.cpp...\n');
system('g++ -fno-common -no-cpp-precomp -c rfutils.cpp -o rfutils.o;');

% classTree:
fprintf('Compiling classTree.cpp...\n');
system('g++ -fno-common -no-cpp-precomp -c classTree.cpp -o classTree.o;');

% classRF:
fprintf('Compiling classRF.cpp...\n');
system('g++ -fno-common -no-cpp-precomp -c classRF.cpp -o classRF.o;');


% Mex Training function:
fprintf('Building RF training function...\n');
mex mex_ClassificationRF_train.cpp classRF.cpp classTree.o rfutils.o rfsub.o...
   cokus.o -o mexClassRF_train -lgfortran -lm -DMATLAB -g


% Mex Prediction function:
fprintf('Building RF prediction function...\n');
mex mex_ClassificationRF_predict.cpp classRF.cpp classTree.o rfutils.o rfsub.o...
   cokus.o -o mexClassRF_predict -lgfortran -lm -DMATLAB -g
