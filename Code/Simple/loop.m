clear, clc
fpath = mfilename('fullpath');
findex=strfind(fpath,'/');
p = genpath(fpath(1:findex(end-2)));
addpath(p);

%%

settings={...
%     'rtrunk';...
%     'toeplitz';...
%     '3trunk';...
%     'fat_tails100';...
%     'r2toeplitz';...
%     'xor2';...
%     'fat_tails';...
%     'outliers';...
    'prostate';...
%     'colon';...
%     'MNIST';...
%     'CIFAR-10';...
    };%...

algs={'LOL';'RRLDA';'eigenfaces';'QOQ';'ROAD'};%'lasso';'LRL';'QOQ'};

A=length(algs);
S=length(settings);

%%

Svec=1:S;
nmc=40;
savestuff=1;

for s=Svec
    setting=settings{s}
    switch setting
        case {'rtrunk','toeplitz'}
            algs={'LOL';'RRLDA';'eigenfaces';'QOQ';'ROAD'};
        case {'3trunk','3trunk4'}
            algs={'LOL';'RRLDA';'eigenfaces';'QOQ';'lasso'};
        case {'fat_tails','fat_tails100'}
            algs={'LOL';'RRLDA';'eigenfaces';'QOQ';'ROAD'};
        case {'xor2','r2toeplitz'}
            algs={'LOL';'RRLDA';'eigenfaces';'QOQ';'ROAD'};
        case 'outliers'
            algs={'LOL';'RRLDA';'eigenfaces';'QOQ';'ROAD';'LRL'};
        case {'CIFAR-10','MNIST'}
            algs={'LOL';'RRLDA';'eigenfaces';'QOQ';'lasso'};
        case {'colon','prostate'}
            algs={'LOL';'RRLDA';'eigenfaces';'QOQ';'ROAD';'lasso'};
    end
    
    D=nan(nmc,1);
    ntrain=nan(nmc,1);
    ntest=nan(nmc,1);
    clear Lhat ks
    for i=1:nmc
        [Lhat(i),wt(i),ks{i},D(i),ntrain(i),ntest(i)]=simple(setting,algs);
        fprintf('\n trial # %d\n', i)
    end
    if savestuff==1
        save([setting, '.mat'],'Lhat','wt','ks','D','ntrain','ntrain','algs','setting')
    end
end

%%
F.algs=algs;
plot_Lhat_v_dvec(setting,F)
