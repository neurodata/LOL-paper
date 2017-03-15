% %% plot
clear, clc

% sit='sims';
sit='real';
% sit='dead';

switch sit
    case 'sims'
        settings={...
            'rtrunk';...
            '3trunk';...
            'toeplitz';...
            'fat_tails';...
            };
        
    case 'real'
        settings={...
            'prostate';...
            'colon';...
            'MNIST';...
            'CIFAR-10';...
            };
        
    case 'dead'
        settings={...
            'r2toeplitz';...
            'xor2';...
            'outliers';...
            };
end

S=length(settings);

%%
col=get(groot,'defaultAxesColorOrder');
algs={'LOL';'RRLDA';'eigenfaces';'ROAD';'lasso';'QOQ';'LRL'};
ms = {'o';'s';'d';'v';'^';'<';'+';'x';'>';'p';'h';'*'};
for a=1:length(algs)
    F.color.(algs{a})=col(a,:);
    F.markerstyle.(algs{a})=ms{a};
end
F.color.('Bayes')=[0 0 0];
F.col=col;
if strcmp(sit,'sims')
    F.nrows=S;
    F.ncols=3;
elseif strcmp(sit,'real')
    F.ncols=2;
    F.nrows=S;
end
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
            G.xmax=60;
            G.tit='Misclassification Rate';
        case 'colon'
            G.ylab='Colon';
            G.xmax=30;
        case 'MNIST'
            G.ylab='MNIST';
            G.xmax=30;
        case 'CIFAR-10'
            G.ylab='CIFAR-10';
            G.xmax=30;
            G.xlab='# of Embedded Dimensions';
    end
    [minL, wallTime, G] = plot_Lhat_v_dvec(setting,G);
    %     if s==S, legend('show'); end
    if ~strcmp(setting,{'prostate','colon','MNIST','CIFAR-10'})
        plot_means(setting,G);
    else
        plot_timing(minL,wallTime,s,G);
    end
end


%%
H.wh=[6.5 9];
H.fname=['plot_', sit];
print_fig(h,H)
