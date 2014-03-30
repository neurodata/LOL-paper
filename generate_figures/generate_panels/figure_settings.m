function F = figure_settings(T,F)

F.gray=0.5*[1 1 1];

for i=1:T.Nalgs
    
    if strcmp(T.algs{i},'LDA')
        F.colors{i}='g';            % green
        F.markers{i}='.';
        F.markersize{i}=24;
        F.linewidth{i}=4;
    elseif strcmp(T.algs{i},'PDA')
        F.colors{i}='m';            % magenta
        F.markers{i}='s';
        F.markersize{i}=3;
        F.linewidth{i}=4;
    elseif strcmp(T.algs{i},'LOL')
        F.colors{i}='c';            % cyan
        F.markers{i}='v';
        F.markersize{i}=2;
        F.linewidth{i}=4;
    elseif strcmp(T.algs{i},'SLOL')
        F.colors{i}=[0.5 0 0.9];    % purple
        F.markers{i}='+';
        F.markersize{i}=2;
        F.linewidth{i}=4;
    elseif strcmp(T.algs{i},'RDA')
        F.colors{i}= 'y';           % yellow
        F.markers{i}='*';
        F.markersize{i}=8;
        F.linewidth{i}=2;
    elseif strcmp(T.algs{i},'DRDA')
        F.colors{i}= [1 0.5 0.2];   % orange
        F.markers{i}='x';
        F.markersize{i}=8;
        F.linewidth{i}=2;
    elseif strcmp(T.algs{i},'RF') || strcmp(T.algs{i},'treebagger')
        F.colors{i}= 'b';           % dark blue
        F.markers{i}='o';
        F.markersize{i}=8;
        F.linewidth{i}=2;
    elseif strcmp(T.algs{i},'svm')
        F.colors{i}= [0 0.5 0];     % dark green
        F.markers{i}='d';
        F.markersize{i}=8;
        F.linewidth{i}=2;
    elseif strcmp(T.algs{i},'NaiveB') || strcmp(T.algs{i},'naivebayes')
        F.colors{i}= [0.9 0.75 0];  % brown
        F.markers{i}='h';
        F.markersize{i}=8;
        F.linewidth{i}=2;
    elseif strcmp(T.algs{i},'QOL') 
        F.colors{i}= 'r';           % red
        F.markers{i}='^';
        F.markersize{i}=8;
        F.linewidth{i}=2;
    elseif strcmp(T.algs{i},'QOQ') 
        F.colors{i}= 'k';           % brown
        F.markers{i}='^';
        F.markersize{i}=8;
        F.linewidth{i}=2;
    elseif strcmp(T.algs{i},'QDA') 
        F.colors{i}= 'k';           % brown
        F.markers{i}='o';
        F.markersize{i}=8;
        F.linewidth{i}=2;
    elseif strcmp(T.algs{i},'lda') 
        F.colors{i}= 'k';           % brown
        F.markers{i}='+';
        F.markersize{i}=8;
        F.linewidth{i}=2;
    elseif strcmp(T.algs{i},'qda') 
        F.colors{i}= 'k';           % brown
        F.markers{i}='+';
        F.markersize{i}=8;
        F.linewidth{i}=2;
    end
end