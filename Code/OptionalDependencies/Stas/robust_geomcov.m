function [robust_geom_mean,geometric_median_cov,elementwise_median_cov,sample_cv]=robust_geomcov(data,group_size,mode)
% Robust covariance/principal components estimation.
%% This is a beta-version
%% Usage:
%   Input parameters:
%   'data_filename' - name of the file with data, e.g. 'my_data.txt'
%   'group_size' - size of the groups that the data is partitioned into
%                  (depending on the number of principal components we want to evaluate,
%                  the size of each group should usually be at least 2 times the number of relevant principal components)
%   'mode'       - takes numerical values 1 and 2; affects the method of
%                  centering the data
%                  1 - (standard) centering inside each group by in-group mean
%                  2 - centring by the "geometric median" of the in-group means

%% Output:
%   'data' - data matrix from file
%   'geometric_median_cov' - resulting estimator of the covariance matrix
%                            obtained via the geometric median
%
%   'elementwise_median_cov' - another covariance estimator, median computed elementwise (sometimes shows
%                              better results in simulated data)
%
%   'sample_cv' - usual sample covariance, for comparison
%   'robust_geom_mean' - a version of robust mean of the data
%
%% Extra parameters

threshold=0.4;              %parameter for hard thresholding the coefficients in the expansion of geom. median;
%takes values in (0,1), larger means harder
%thresholding
% data=data_from_file(data_filename);     % obtaining data from file
[dim, s_size]=size(data);

%% Main code
%%
n_of_groups=ceil(s_size/group_size);
%%
%% Usual sample covariance
sample_cv=zeros(dim,dim);
centering=mean(data,2);
data_temp=data-repmat(centering,1,s_size);
sample_cv=(data_temp*data_temp')./s_size;
%% Evaluating elementwise median covariance
%%
resampling_rate=1;
permut_covar=zeros(dim*dim,resampling_rate);
for q=1:resampling_rate
    %% Shuffling data
    [~,r_perm]=sort(rand(1,s_size));
    data=data(:,r_perm);
    %%
    ind=[0:group_size:s_size];
    if ceil(s_size/group_size)>s_size/group_size
        ind=horzcat(ind,s_size);
    end
    cov=zeros(dim*dim,n_of_groups);
    %% In-group means
    center=zeros(dim,n_of_groups);
    for j=1:(length(ind)-1)
        center(:,j)=mean(data(:,ind(j)+1:ind(j+1)),2);
    end
    %% Robust geometric mean
    robust_mean_coordinatewise=median(center,2);
    %
    weight=zeros(1,n_of_groups);
    remainder=zeros(dim,1); remainder(1)=Inf;
    robust_geom_mean=mean(center,2);
    iter=0;
    while norm(remainder)>0.1
        weight=1./sqrt(sum((center-repmat(robust_geom_mean,1,n_of_groups)).^2,1));
        new_approx=(center*weight')./sum(weight);
        remainder=new_approx-robust_geom_mean;
        robust_geom_mean=new_approx;
        iter=iter+1;
    end
    %% Thresholding small weights
    weight_s=weight./sum(weight);
    for j=1:length(weight_s)
        if (weight_s(j)>(1/n_of_groups)*threshold)
            weight_threshold(j)=weight_s(j);
        else
            weight_threshold(j)=0;
        end
    end
    robust_geom_mean=(center*weight_threshold')./sum(weight_threshold);
    %% Evaluating in-group covariances
    
    %% Centering by the in-group sample means (standard)
    if (mode==1)
        for j=1:(length(ind)-1)
            temp=(data(:,ind(j)+1:ind(j+1))-repmat(center(:,j),1,ind(j+1)-ind(j)))*...
                (data(:,ind(j)+1:ind(j+1))-repmat(center(:,j),1,ind(j+1)-ind(j)))'./(ind(j+1)-ind(j));
            cov(:,j)=temp(:);
        end
    end
    
    %% Centering by 'geometric median' mean estimator
    if (mode==2)
        for j=1:(length(ind)-1)
            temp=(data(:,ind(j)+1:ind(j+1))-repmat(robust_geom_mean,1,ind(j+1)-ind(j)))*...
                (data(:,ind(j)+1:ind(j+1))-repmat(robust_geom_mean,1,ind(j+1)-ind(j)))'./(ind(j+1)-ind(j));
            cov(:,j)=temp(:);
        end
    end
end

%% Evaluating 'elementwise median' sample covariance
elementwise_median_cov=reshape(median(cov,2),dim,dim);

%% Evaluating "geometric median" covariance
%%
weight=zeros(1,n_of_groups);
geometric_median_vec=permut_covar(:,1);
remainder=zeros(dim*dim,1); remainder(1)=Inf;
iter=0;
new_approx=zeros(dim*dim,1);
while norm(remainder)>0.1
    weight=1./sqrt(sum((cov-repmat(geometric_median_vec,1,n_of_groups)).^2,1));
    new_approx=(cov*weight')./sum(weight);
    remainder=new_approx-geometric_median_vec;
    geometric_median_vec=new_approx;
    iter=iter+1;
end
%% Thresholding small weights
weight_s=weight./sum(weight);
for j=1:length(weight_s)
    if (weight_s(j)>(1/n_of_groups)*threshold)
        weight_threshold(j)=weight_s(j);
    else
        weight_threshold(j)=0;
    end
end
%weight_threshold=weight_threshold./sum(weight_threshold);
geometric_median_vec=(cov*weight_threshold')./sum(weight_threshold);
%geometric_median_cov=reshape(geometric_median_vec,dim,dim); %final estimator
%vesa=weight_threshold./sum(weight_threshold)
%% Evaluating final estimators


%% Geometric median
geometric_median_cov=reshape(geometric_median_vec,dim,dim);
end
