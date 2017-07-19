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
%             'prostate';...
            'colon';...
            'MNIST';...
%             'CIFAR-10';...
            'MRN';...
            };
        
    case 'dead'
        settings={...
            'r2toeplitz';...
            'xor2';...
            'outliers';...
            'CIFAR-10';...
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
    F.ncols=S;
    F.nrows=1;
end
F.xlab=[];
F.xmax=1;
F.legend=false;
F.sit=sit;
F.xticks=[5:5:500];

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
            G.ylab='(A) Prostate; K=2';
            G.xmax=20;
            G.ymax=0.5;
            G.tit='Misclassification Rate';
        case 'colon'
            G.ylab='(A) Colon; K=2';
            G.xticks=[10:10:500];
            G.xmax=20;
            G.ymax=0.5;
        case 'MNIST'
            G.ylab='(B) MNIST; K=10';
            G.xticks=[10:10:500];
            G.xmax=30;
            G.ymax=1.0;
        case 'CIFAR-10'
            G.ylab='CIFAR-10; K=2';
            G.xmax=30;
            G.xticks=[10:10:500];
            G.xlab='# of Embedded Dimensions';
        case 'MRN'
            G.ylab='(C) MRN; K=2';
            G.xmax=100;
            G.xticks=[25:25:500];
            G.xlab='# of Embedded Dimensions';
    end
    if ~strcmp(setting,'MRN')
        [minL, wallTime, G] = plot_Lhat_v_dvec(setting,G);
    else
        subplot(F.nrows,F.ncols,F.ncols);
        plot_mrn2
    end
    %     if s==S, legend('show'); end
    if ~strcmp(setting,{'prostate','colon','MNIST','CIFAR-10','MRN'})
        plot_means(setting,G);
    else
        %         plot_timing(minL,wallTime,s,G);
    end
end


%%
if strcmp(sit,'sims')
    H.wh=[6.5 9];
else
    H.wh=[10,2];
    legend({'LOL','PCA','PCA''','ROAD','Lasso'},'Position', [0.46 0.3 1 0.2]) ; % [left bottom width height] 'location','bestoutside')
    legend('boxoff')
end
H.fname=['plot_', sit];
print_fig(h,H)
