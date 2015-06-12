%%% These are the examples concerning model selection for the mussels and fearn data, 
%%% that appear in Section 6.5  of the paper by R. D. Cook paper: Fisher Lecture: Dimension
%%% Reduction in Regression. Statist. Sci. Volume 22, Number 1 (2007), 1-26



clear all;
setpaths; % adds all directories in the LBDR package to MATLAB's path. 

%analysis of Horse Mussel data (Cook and Weisberg,
%1994) 
data = load('mussels.txt'); % reads data from text file. 

Y=log(data(:,3));
X=log(data(:,[1,2,4,5]));

disp('Starting dimension reduction of mussels.txt data using EPFC');
FF = get_fy(Y,1);
[WX,W,f,d1] = ldr(Y,X,'EPFC','cont','lrt','fy',FF);      
disp(strcat('   Selected dimension by LRT is d = ',int2str(d1)));
[WX,W,f,d2] = ldr(Y,X,'EPFC','cont','aic','fy',FF);      
disp(strcat('   Selected dimension by AIC is d = ',int2str(d2)));
[WX,W,f,d3] = ldr(Y,X,'EPFC','cont','bic','fy',FF);      
disp(strcat('   Selected dimension by BIC is d = ',int2str(d3)));





%analysis of the Fearn?s (1983; see also Cook, 1998, page 175) calibration
%data
data = load('fearn.txt'); % reads data from text file. 
X=data(:,2:(size(data,2)));
Y=data(:,1);

disp('Starting dimension reduction of fearn.txt data using EPFC');
FF = get_fy(Y,1);
[WX,W,f,d1] = ldr(Y,X,'EPFC','cont','lrt','fy',FF);      
disp(strcat('   Selected dimension by LRT is d = ',int2str(d1)));
[WX,W,f,d2] = ldr(Y,X,'EPFC','cont','aic','fy',FF);      
disp(strcat('   Selected dimension by AIC is d = ',int2str(d2)));
[WX,W,f,d3] = ldr(Y,X,'EPFC','cont','bic','fy',FF);      
disp(strcat('   Selected dimension by BIC is d = ',int2str(d3)));

disp('                    ');

