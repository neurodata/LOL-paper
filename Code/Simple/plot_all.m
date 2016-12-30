 % %% plot
clear, clc
settings={...
    'rtrunk';...
    'toeplitz';...
    '3trunk';...
    'xor2';...
    'fat_tails';...
    'outliers'};
% ;...
%     'prostate';...
%     'colon';...
%     'MNIST';...
%     'CIFAR-10';...
% };

S=length(settings);

%%
col=get(groot,'defaultAxesColorOrder');
algs={'LOL';'RRLDA';'eigenfaces';'ROAD';'lasso';'LRL';'QOQ'};

for a=1:length(algs)
    F.color.(algs{a})=col(a,:);
end
F.nrows=S;
F.ncols=3;
%%
F.xlab=[];
F.xmax=1;
h=figure(1); clf
for s=1:S
    setting=settings{s};
    F.row=s;
    switch setting
        case 'rtrunk'
            F.ylab='Trunk';
            F.xmax=20;
            F.legend=false;
        case 'toeplitz'
            F.ylab='Toeplitz';
            F.xmax=50;
        case '3trunk'
            F.ylab='3-Trunk';
            F.xmax=20;  
        case 'xor2'
            F.ylab='XOR';
            F.xmax=20;  
        case 'outliers'
            F.ylab='Outliers';
            F.xmax=70;  
        case 'fat_tails'
            F.ylab='Fat Tails';
            F.xmax=25;  
        case 'prostate'
            F.ylab='Prostate';
            F.xmax=20;  
        case 'colon'
            F.ylab='Colon';
            F.xmax=20;  
        case 'MNIST'
            F.ylab='MNIST';
            F.xmax=20;  
        case 'CIFAR-10'
            F.ylab='CIFAR-10';
            F.xmax=20;  
            F.xlab='# of Embedded Dimensions';
    end
    plot_Lhat_v_dvec(setting,F);
    if s==S, legend('show'); end

    plot_means(setting,F);
end


%
H.wh=[6 10];
H.fname=['plot_all'];
print_fig(h,H)
