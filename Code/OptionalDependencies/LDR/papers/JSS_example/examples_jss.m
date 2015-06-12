%######################################################################
% This script is to illustrate de use of the LDR package, as described in 
% the manuscript by Cook, Forzani and Tomassi: 'LDR: a software package
% for likelihood-based sufficient dimension reduction. See the paper for 
% details.

%----------------------------------------------------------------------
%% EXAMPLE WITH DIGITS DATA

setpaths; % adds all directories in the LDR package to Matlabs's path.
data = load('digits.txt'); % reads data from text file using standard Matlab function.
Y = data(:,1);  % assigns the first column of data to the response.
X = data(:,2:end);  % assigns the remaining columns to the predictors.

% We now look for subspace of dimension d=2 that retains all the
% information in X about the discrete response Y using the LAD dimension 
% reduction method
[WX,W] = ldr(Y,X,'LAD','disc',2);
% We now plot the projected predictors
plotDR(WX,Y,'disc','LAD');

% Now we assume means are the same for all populations and look for
% subspace of dimension d=1 using de CORE dimension reduction method
[WX,W,f,d] = ldr(Y,X,'CORE','disc',1)
% plot of the projected predictors for the last dimension reduction 
plotDR(WX,Y,'disc','CORE');
 
% We now assume we don't know what d is, but estimate it using Akaike's
% information criterion. The reduction for the selected dimension is also
% returned as a result.
[WX,W,f,d] = ldr(Y,X,'PFC','disc','AIC');
disp(['   Selected dimension by AIC is d = ',int2str(d)]);
 
% We now plan to use principal fitted components, but test first if teh
% covariance matrix is diagonal
 testdiag4pfc(Y,X,'disc',.05)
 
% We apply principal fitted components still assuming diagonal covariance matrices, 
% and infer the dimension of the reduced subspace using Bayes information criterion.
% The reduction for the selected dimension is also returned as a result.
 [WX,W,f,d] = ldr(Y,X,'SPFC','disc','BIC')
 disp(['   Selected dimension by BIC is d = ',int2str(d)]);
 
% Commands below apply model-free sufficient dimension reduction according to SIR, 
% SAVE and DR methods to look for a subspace of dimension d=2. 
[WX,W]=SIR(Y,X,'disc',2);
[WX,W]=SAVE(Y,X,'disc',2);
[WX,W]=DR(Y,X,'disc',2);



%% EXAMPLE WITH NAPHTALINE DATA

setpaths; % adds all directories in the LDR package to Matlabs's path.
data=load('nap.txt'); % reads data from text file.
X=data(:,[4 5 9]); % assigns the predictors.
Y=data(:,12); % assigns the response.

% looks for dimension reduction subspace of dimension d=1 using the LAD
% method, now for a continuous response Y. This response is discretized in
% 10 slices to apply the method
[WX,W,f,d]= ldr(Y,X,'LAD','cont',1,'nslices',10);
% Plot of the obtained projections
plotDR(WX,Y,'cont','LAD');
 
% now we assume we don't know d, but infer it using likelihood ratio test
% at 5% level. For this analysis, we use just 5 slices to discretize the
% response. The reduction for the selected dimension is also
% returned as a result.
[WX,W,f,d] = ldr(Y,X,'LAD','cont','lrt','nslices',5,'alpha',0.05);
% just displays the selected dimension
disp(['   Selected dimension by LRT is d = ',int2str(d)]);

% now we infer d but using a permutation test with 500 permutations of the
% sample at 5% level. The reduction for the selected dimension is also
% returned as a result.
[WX,W,f,d] = ldr(Y,X,'LAD','cont','perm','nslices',5,...
                 'alpha',0.05,'npermute',500);
% we display the selected dimension             
disp(['   Selected dimension by permutation test is d = ',int2str(d)]);

% We now change to the PFC model.
% First we form a regression basis for fitting the predictors
FY = get_fy(Y,2,'sqr');  % builds a matrix of polynomials of order 2.
% We infer d using Bayes information criterion under the PFC model. We use
% the formed regression basis for the analysis.
[WX,W,f,d] = ldr(Y,X,'PFC' ,'cont' ,'bic','fy' ,FY);
disp(['   Selected dimension by BIC is d = ',int2str(d)]);
