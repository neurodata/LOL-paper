function d = lrtloop_handle_vf(Y,X,data_parameters,simu_parameters,Ysliced,aux_datapars,auxpars)
%  d = lrtloop_handle_vf(Y,X,data_parameters,simu_parameters,Ysliced,aux_datapars,auxpars)
%
% This function performs the computation for infering the dimension of the central subspace using LRT for those methods that rely on numerical optimization using SG_MIN. Thus, it is the main auxiliary function for lrtLAD, lrtCORE and lrtEPFC.
%

%==============================================================================
if nargin<5,
  Ysliced = Y;
  aux_datapars = data_parameters;
  auxpars = simu_parameters;
end

alpha = simu_parameters.alpha;
p = cols(X);
umax = p-1;
d = @lrt;

    function dim = lrt(F,dF,F0,dof)
        fp = F(eye(p));
        for u=0:umax,
            if u==0,
                fu = F0;
            elseif u<p
               guess = get_initial_estimate(Ysliced,X,u,aux_datapars,auxpars);
               Wo = guess(F);
               if ~isempty(simu_parameters.sg),
                   fu = sg_min(F,dF,Wo,simu_parameters.sg{:},simu_parameters.maxiter);
               else
                   fu = sg_min(F,dF,Wo,'prcg','euclidean',{1:u},'quiet',simu_parameters.maxiter);
               end
            else
               fu = fp;
            end
            statistic = 2*(fu-fp);
            if (chi2cdf(statistic,(dof(p)-dof(u)))<(1-alpha))||(u==umax),
                dim = u;
                break;
            end
        end
    end

end
            
                
            
        
