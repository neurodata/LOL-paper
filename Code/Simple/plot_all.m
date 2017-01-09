 % %% plot
clear, clc
settings={...
    'rtrunk';...
    '3trunk';...
    'toeplitz';...
    'fat_tails';...
    'r2toeplitz'};%...
%     'xor2';...
%     'outliers'};
%     'prostate';...
%     'colon';...
%     'MNIST';...
%     'CIFAR-10';...
% };

S=length(settings);

%%
col=get(groot,'defaultAxesColorOrder');
algs={'LOL';'RRLDA';'eigenfaces';'ROAD';'lasso';'QOQ';'LRL'};

for a=1:length(algs)
    F.color.(algs{a})=col(a,:);
end
F.color.('Bayes')=[0 0 0];
F.col=col;
F.nrows=S;
F.ncols=3;
F.xlab=[];
F.xmax=1;
F.legend=false;

%%
h=figure(1); clf
for s=1:S
    setting=settings{s};
    F.row=s;
    G=F;
    switch setting
        case 'rtrunk'
            G.ylab='Trunk-2';
            G.xmax=30;
            G.legend=false;
            G.algs=algs(1:4);
        case 'toeplitz'
            G.ylab='Toeplitz';
            G.xmax=90;
            G.algs=algs(1:4);
        case '3trunk'
            G.ylab='Trunk-3';
            G.xmax=30;  
        case 'xor2'
            G.ylab='XOR';
            G.xmax=30;  
        case 'r2toeplitz'
            G.ylab='QDA';
            G.xmax=30;  
        case 'outliers'
            G.ylab='Outliers';
            G.xmax=70;  
            G.ymax=0.3;
        case 'fat_tails'
            G.ylab='Fat Tails (D=1000)';
            G.xmax=30;  
        case 'prostate'
            G.ylab='Prostate';
            G.xmax=20;  
        case 'colon'
            G.ylab='Colon';
            G.xmax=20;  
        case 'MNIST'
            G.ylab='MNIST';
            G.xmax=20;  
        case 'CIFAR-10'
            G.ylab='CIFAR-10';
            G.xmax=20;  
            G.xlab='# of Embedded Dimensions';
    end
    plot_Lhat_v_dvec(setting,G);
%     if s==S, legend('show'); end

    plot_means(setting,F);
end


%%
H.wh=[6.5 9];
H.fname=['plot_all'];
print_fig(h,H)
