#####################################################################################

LDR: a software package for likelihood-based sufficient dimension reduction
        
                by R.D. Cook, L. Forzani and D. Tomassi
                            
                               2009
                
#####################################################################################

- DESCRIPTION

This folder contains auxiliary functions which are used internally by the LDR 
package when applying one of the dimension reduction method stored in the MODELS 
folder. They are not intended to be used directly in applications.


- CONTENTS 
--------------------------------------------------------------------------------
# aic.m: a function to infer the dimension of the central subspace using Akaike's 
information criterion.
# bic.m: a function to infer the dimension of the central subspace using Bayes 
information criterion.
# check_inputs.m: a function to check consistency of inputs arguments when calling 
to a method for dimension reduction.
# ddF.m: general function for computing the second derivative of the objective 
function for each method of dimension reduction. It calls to model specific functions.
# dF.m: general function for computing the derivative of the objective function 
for each method of dimension reduction. It calls to model specific functions.
# findindata.m: a function to extract observations from given populations from a 
whole data matrix.
# firsteigs.m: a function to compute the first k eigenvalues and eigenvectors of 
a symmetric positive definite matrix.
# F.m: general function for computing the objective function for each method of 
dimension reduction. It calls to model specific functions.
# get_average_cov.m: a function to compute the sample between-class covariance 
matrix.
# get_combeig.m: a function to obtain all the permutations of the first k 
eigenvectors of a symmetric positive definite matrix.
# get_covarray.m: a function to obtain conditional covariance matrices for each 
value of the response Y.
# get_cov.m: a function to get a bias estimate of the marginal covariance matrix.
# getDATA4gui.m: a function to load data from datafiles as used for the graphical 
user interface.
# getDATA.m: a function to extract the response Y and the vector of predictors 
from a dataset.
# getDRv2.m: an auxiliary function to obtain the estimate of the central subspace 
using the DR method.
# get_fitted_cov.m: a function to compute the covariance matrix of the fitted 
values from the regression of the centered predictors onto a vector valued function 
of the response.
# get_fy.m: a function to build a regression basis matrix as a function of the 
response Y.
# get_initial_estimate.m: a function to compute an initial estimate when carrying 
out numerical optimization to find the central subspace.
# get_maxid.m: an auxiliary function to use within the stricture principal fitted 
componentes model for dimension reduction.
# get_meanvar.m: a function to compute the mean of sample conditional covariance 
matrices.
# get_more.m: an auxiliary function used when computing candidates for the initial 
estimate prior to numerical optimization.
# get_pars.m: a function to get basic statistics from the sample, as conditional 
means and covariance matrices, sample size, marginal covariance matrix.
# get_perm_handle.m: a function to perform th erepetitive computations when 
inferring the dimension oif the central subspace using permutation tests.
# get_regress.m: a function to regress a a vector onto a basis matrix.
# getSAVEv2.m: an auxiliary function to obtain the estimate of teh central 
subspace using the SAVE method.
# getSIRv2.m: an auxiliary function to obtain the estimate of the central subspace 
using the SIR method.
# icloop.m: a function to perform the repetitive computations when infering the 
dimension of the central subspace using an information criterion such as AIC or BIC.
# invsqrtm.m: a function to compute theinverse of the squared root of a matrix.
# isinZ.m: a function to check for integer data.
# load2var.m: a function to load labeledl candidates to be data to different fields 
of a structure retaiing the labels as the name of teh variables.
# lrtloop_handle_vf.m: a function to perform repetitive computation swhen infering 
the dimension of the central subspace using likelihood-ratio tests.
# mapdata.m: a function to map discrete responses to the range Y=1,2,...,h.
# plotDR.m: a function to plot projected data.
# pls4sdr.m: an auxiliary function for partial least squares regression.
# read_input_nldr.m
# read_inputs.m: a function to read optional input argumenst when calling to 
function LDR.
# setaux_v2.m: a function to perform intermediate computations used by SIR, SAVE 
and DR.
# setdatapars_v2.m: a function to build a structe of parmeters from basic statistics 
of the sample.
# slices.m:a function to discretize a continuous response Y into h bins.
# sqrm.m: square of a matrix.
# testdiag4pfc.m: a function to test the PFC model over the SPFC model.
- valin_v2.m: a function to obtain several candidates for the best initial estimate 
to start numerical optimization.


- REQUIREMENTS
--------------------------------------------------------------------------------
Aside from the LIGHTSPEED package by Tom Minka and the SG_MIN package by Lippert, 
some of these functions require the STATISTICS toolbox from MATHWORKS to complement the basic MATLAB software.
