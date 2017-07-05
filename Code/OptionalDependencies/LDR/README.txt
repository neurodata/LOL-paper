#####################################################################################

LDR: a software package for likelihood based sufficient dimension reduction
        
                by R.D. Cook, L. Forzani and D. Tomassi
                            
                               2009
                
#####################################################################################

- DESCRIPTION
--------------------------------------------------------------------------------

This is a toolkit for sufficient dimension reduction running on MATLAB. It mainly
implements likelihood-based methods for normal models.

Available methods include:
 - Isotonic Principal Fitted Components (Cook 2007)
 - Extended Principal Fitted Components (Cook 2007)
 - Principal Fitted Components (Cook and Forzani 2009a)
 - Structured Principal Fitted Components (Cook and Forzani 2009a)
 - Covariance Reduction models (Cook and Forzani 2008)
 - Likelihood Acquired Directions (Cook and Forzani 2009b)
 - Envelope Models for Multivariate Linear Regression (Cook, Li and Chiaromonte 2009)
 
 Other dimension reduction methods are supplied for completness:
 - Principal Components
 - Partial Least Squares
 - Sliced Inverse Regression
 - Sliced Average Variance Estimator
 - Directed Regression
 



CONTENTS:
--------------------------------------------------------------------------------

-MAIN:

   - ldr.m: an interface function for command-line operation.
   - setpaths.m: a start up function to add all the folders in the package to 
   Matlab's search path. 

   # ./TOOLS: auxiliary routines used by the method-specific functions and procedures for managing data, results and plots.

   # ./TOOLBOXES: third-party toolkits used in the LDR package. It includes the 
   SG_MIN package by R. Lippert and the LIGHTSPEED toolkit by T. Minka. The supplied version of SG_MIN is slightly modified with respect to the original.

   # ./MODELS: model-specific functions including objective function, derivative 
   and methods for estimation of the dimension reduction subspace.

   # ./PAPERS: a collection of scripts to reproduce the examples for the paper in the Journal of
 Statistical Software and other reported results for likelihood-based sufficient dimension reduction.
 
   # ./GUI: functions used by the graphical user interface.


INSTALLATION:
--------------------------------------------------------------------------------
The LDR package requires installation of the LIGHTSPEED TOOLKIT. This allows for using compilled routines that speed up many computations. See installation details in the ./PAPERS/LIGHTSPEED folder. If you already have this toolkit installed in your machine, yo do not have to install it again.

After installation of LIGHTSPEED, the LDR package runs as a local folder and does not need installation.


USAGE:
--------------------------------------------------------------------------------
   - To start using the toolkit, you must run first >> setpaths
     This will make all functions in the package available at Matlab's search path. 
   - Function ldr provides the interface to run likelihood-based dimension reduction methods from the command line.

   - demo is little Graphical User Interface to run simple computations using LDR interactively.

- REFERENCES
--------------------------------------------------------------------------------
Cook, R. D. (2007). Fisher Lecture: Dimension reduction in
regression (with discussion). Statistical Science, Vol. 22, pp. 1-26.

Cook, R. D. and Forzani, L. (2008). Covariance reducing models: An alternative 
to spectral modelling of covariance matrices. Biometrika, Vol. 95(4), pp. 799-812.

Cook, R. D. and Forzani, L. (2009a). Principal fitted components in regression. 
Statistcal Science, Vol. 23(4), pp. 485-501.
 
Cook, R. D. and Forzani, L. (2009b). Likelihood-based sufficient dimension 
reduction. Journal of the American Statistical Association, Vol. 104(485), 
pp. 197-208. doi:10.1198/jasa.2009.0106. 

Cook, R. D. and Weisberg, S. (1991). Discussion of ``Sliced inverse regression" by
K. C. Li. Journal of the American Statistical Association, Vol. 86, pp. 328-332.

Li, K. C. (1991). Sliced inverse regression for dimension reduction
(with discussion). Journal of the American Statistical Association, Vol. 86, 
pp. 316-342.

Li, B. and Wang S. (2007). On directional regression for dimension reduction.
Journal of American Statistical Association, Vol. 102, pp. 997-1008.



CREDITS:
--------------------------------------------------------------------------------
LDR relies on Ross Lippert's SG_MIN toolkit to perform optimization on the Grassmann manifold. For further details about this package refer to:
     
    Lippert, R. and Edelman, A. (2000). Nonlinear eigenvalue problems with orthog-
       onality constraints. In Bai, Z., Demmel, J., Dongarra, J., Ruhe, A. and van
       der Vorst, H: Templates for the Solution of Algebraic Eigenvalue Problems:
       A Practical Guide. Philadelphia: SIAM.

LDR also uses function from tom Minka's LIGHTSPEED toolkit to speed-up 
computations in Matlab. For further details, visit:

    http://research.microsoft.com/en-us/um/people/minka/software/lightspeed/ 



REQUIREMENTS:
--------------------------------------------------------------------------------
     - MATLAB
     - Statistics toolbox
     - LIGHTSPEED: a toolkit to accelerate some computations in MATLAB.
       (http://research.microsoft.com/en-us/um/people/minka/software/lightspeed/)
     - SG_MIN: a Matlab toolkit to perform nonlinear optimization with matrix constraints. LDR uses a slightly modified version of the toolkit that is distributed with the package. The original version can be find at http://www-math.mit.edu/∼lippert/sgmin.html


VERSION: July 2010
==========================================================================================
