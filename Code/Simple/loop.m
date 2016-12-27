clear, clc
fpath = mfilename('fullpath');
findex=strfind(fpath,'/');
p = genpath(fpath(1:findex(end-2)));
addpath(p);

%%

settings={...
    'rtrunk';...
    'toeplitz';...
    '3trunk4';...
    'fat_tails';...
    'xor2';...
    'outliers';...
    'prostate';...
    'colon';...
    'MNIST';...
    'CIFAR-10'};
algs={'LOL';'RRLDA';'QOQ';'LRL';'eigenfaces';'ROAD';'lasso'};

A=length(algs);
S=length(settings);
nmc=2;

save('goodstuff.mat')

%%

% ks=nan(S,nmc);
% D=nan(S,nmc);
% ntrain=nan(S,nmc);
% ntest=nan(S,nmc);
for s=1:S
    setting=settings{s}
    for i=1:nmc
        [Lhat(i),ks{i},D(i),ntrain(i),ntest(i)]=simple(setting,algs);
        fprintf('\n trial # %d\n', i)
    end
    save([setting, '.mat'],'Lhat','ks','D','ntrain','ntrain','algs','setting')
%     save('goodstuff.mat','Lhat','-append')
end


