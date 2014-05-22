clearvars, clc
varr=1.9125;
dim=120;
s_size=1600;
out_size=0;
rank=5;
eigens=linspace(5+rank-1,5,rank)';
variance=vertcat(eigens,(0.5/(varr*dim))*ones(dim-rank,1));
diag_p=diag(variance);
true_cov=varr*diag_p;
number_of_ouliers=4;                          %number of outliers
data=zeros(dim,s_size);
for i=1:(s_size-out_size)
    vector=rand_number(dim,'tail2');
    data(:,i)=vector.*sqrt(variance);
end
%% inserting outliers
for i=(s_size-out_size+1):s_size
    vector=40*(rand(dim,1)-1/2);
    data(:,i)=vector;
end
%% Shuffling data
% [~,r_perm]=sort(rand(1,s_size));
% data=data(:,r_perm);			% resulting data matrix