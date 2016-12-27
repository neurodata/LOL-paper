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
nmc=40;


%%

for s=3:S
    setting=settings{s}
    D=nan(nmc,1);
    ntrain=nan(nmc,1);
    ntest=nan(nmc,1);
    for i=1:nmc
        [Lhat(i),ks{i},D(i),ntrain(i),ntest(i)]=simple(setting,algs);
        fprintf('\n trial # %d\n', i)
    end
    save([setting, '.mat'],'Lhat','ks','D','ntrain','ntrain','algs','setting')
    clear Lhat ks
end


