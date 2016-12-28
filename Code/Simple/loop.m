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
algs={'LOL';'RRLDA';'eigenfaces';'ROAD';'lasso'};

A=length(algs);
S=length(settings);



%%

Svec=[5:S];
nmc=40;
savestuff=1;

for s=Svec
    setting=settings{s}
    D=nan(nmc,1);
    ntrain=nan(nmc,1);
    ntest=nan(nmc,1);
    clear Lhat ks
    for i=1:nmc
        [Lhat(i),wt(i),ks{i},D(i),ntrain(i),ntest(i)]=simple(setting,algs);
        fprintf('\n trial # %d\n', i)
    end
    if savestuff==1
        save([setting, '.mat'],'Lhat','ks','D','ntrain','ntrain','algs','setting')
    end
end


