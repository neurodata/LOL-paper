#####################################################################################

LDR: a software package for likelihood-based sufficient dimension reduction
        
                by R.D. Cook, L. Forzani and D. Tomassi
                            
                               2009
                
#####################################################################################

- DESCRIPTION
--------------------------------------------------------------------------------
This folder contains the main functions for dimension reduction using the methods 
available with the package. 



- CONTENTS
--------------------------------------------------------------------------------
This folder contains a subfolder with routines for each of the implemented methods:

# ./core: implementations for covariance reducing models, as proposed in Cook and 
Forzani, 2008a. Available routines include estimation of the central subspace of 
a known dimension "d" as well as inference on "d" using information criteria, 
likelihood ratio test and permutation test.

# ./epfc: implementations for extended principal fitted components, as proposed in 
Cook 2007. Available routines include estimation of the central subspace for 
a known dimension "d" as well as inference on "d" using information criteria, 
and likelihood ratio tests.

# ./ipfc: implementations for isotonic principal fitted components, as proposed in 
Cook 2007. Available routines include estimation of the central subspace for 
a known dimension "d" as well as inference on "d" using information criteria, 
and likelihood ratio tests.

# ./lad: implementations for Likelihood Acquired Directions, as proposed in Cook and Forzani, 2009b. Available routines include estimation of the central subspace of a known dimension "d" as well as inference on "d" using information criteria, 
likelihood ratio test and permutation test.

# ./pfc: implementations for principal fitted components, as proposed in Cook and 
Forzani, 2009a. Available routines include estimation of the central subspace of 
a known dimension "d" as well as inference on "d" using information criteria, 
and likelihood ratio tests.

# ./spfc: implementations for structured principal fitted components, as proposed 
in Cook and Forzani, 2009a. Available routines include estimation of the central 
subspace of a known dimension "d" as well as inference on "d" using information 
criteria, and likelihood ratio tests.

# ./etc: implementations for other dimension reduction methods given here for 
completeness. Available methods include:
   - PC: principal components
   - SIR: sliced inverse regression (Li, 1991).
   - SAVE: sliced average variance estimator (Cook and Weisberg, 1991).
   - DR: directed reductions (Li and Wang, 2007).
   - PLS: partial least squares regression
   
   
- REFERENCES
--------------------------------------------------------------------------------
Cook, R. D. (2007). Fisher Lecture: Dimension reduction in
regression (with discussion). Statistical Science, Vol. 22, pp. 1-26.

Cook, R. D. and Forzani, L. (2008a). Covariance reducing models: An alternative 
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

