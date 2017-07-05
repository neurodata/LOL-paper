function dim = icloop(F,dF,F0,dof,Y,X,data_parameters,parameters,Ysliced,aux_datapars,auxpars)
% dim = icloop(F,dF,F0,dof,Y,X,data_parameters,parameters,Ysliced,aux_datapars,auxpars)
%
% This function returns the dimension of the reduction subspace that
% minimizes the Akaike or the Bayes information criteria. As these criteria
% differ only in their penalization for complexity of the model but share all 
% the main computations, a loop is first carried out which computes the
% log-likelihood and the degrees of freedom for a sequence of dimensions
% u=0,1,...,p using Stieffel-Grassmann optimization. The best dimension is 
% then chosen according to the specified criterion, AIC, or BIC.
%
% Inputs:
%   - F: handle to the objective function for the assessed model.
%   - dF: handle to the derivative of F.
%   - F0: value of F for u=0.
%   - Y: response vector.
%   - X: predictor matrix.
%   - data_parameters: structure with basic statistics from the sample, like 
%     conditional means and covariance matrices, sample size for each value 
%     of Y and marginal covariance matrix.
%   - parameters: optional parameters for optimization.
%   - Ysliced (optional): version of Y for initial value computation prior
%   to numerical optimization. This can be different from Y when the method
%   does not require to discretize the response but computation of initial
%   value actually does.
%   - aux_datapars (optional): as data_parameters, but for initial value
%   computations only.
%   - auxpars (optionakl): as parameters, but for initial value
%   computations only.
%==========================================================================

if nargin < 9,
    Ysliced = Y;
end
if nargin < 10
    aux_datapars = data_parameters;
end
if nargin < 11,
    auxpars = parameters;
end
%--- get sample statistics ................................................
[n,p] = size(X);
%--- main loop
fu = zeros(p+1,1);
dofu = zeros(p+1,1);
% stores values from d=0 to d=p
for u=0:p,
    if u==0,
       fu(u+1) = F0;
    elseif u==p
       fu(u+1) = F(eye(p));
    else
       guess = get_initial_estimate(Ysliced,X,u,aux_datapars,auxpars);
       Wo = guess(F);
       if ~isempty(parameters.sg),
           fu(u+1) = sg_min(F,dF,Wo,parameters.sg{:},parameters.maxiter);
       else
           fu(u+1) = sg_min(F,dF,Wo,'prcg','euclidean',{1:u},'quiet',parameters.maxiter);
       end
    end
    dofu(u+1) = dof(u);
end
dim = @evaluateic;

    function d = evaluateic(criterion)
        if strcmpi(criterion,'aic'),
            d = argmin(2*(fu + dofu));
            d = d-1;
        elseif strcmpi(criterion,'bic'),
            d = argmin(2*fu + log(n)*dofu);
            d = d-1;
        else
            error('unknown method for model selection')
        end
        
    end

end