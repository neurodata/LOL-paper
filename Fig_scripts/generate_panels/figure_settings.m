function F = figure_settings(T,F)

F.gray=0.5*[1 1 1];

for i=1:T.Nalgs
    
%     if strcmp(T.algs{i},'RF') || strcmp(T.algs{i},'treebagger')
%         F.colors{i}= 'b';           % dark blue
%         F.markers{i}='x';
%         F.markersize{i}=8;
%         F.linewidth{i}=2;
%         F.linestyle{i}='.-';
%     elseif strcmp(T.algs{i},'svm')
%         F.colors{i}= [0 0.5 0];     % dark green
%         F.markers{i}='x';
%         F.markersize{i}=8;
%         F.linewidth{i}=2;
%         F.linestyle{i}='.-';
% else
    if strcmp(T.algs{i},'QOQ')
        F.colors{i}= 'k';           % brown
        F.markers{i}='^';
        F.markersize{i}=8;
        F.linewidth{i}=2;
    elseif strcmp(T.algs{i},'LOL')
        for j=1:length(T.types)
            
%             if strcmp(T.types{j}(1),'D')
%                 F.linestyle{i+j-1}='-';
%             elseif strcmp(T.types{j}(1),'N')
%                 F.linestyle{i+j-1}='.-';
%             end
%             
%             if strcmp(T.types{j}(2),'E')
%                 F.colors{i+j-1}='c';
%             elseif strcmp(T.types{j}(2),'V')
%                 F.colors{i+j-1}='m';
%             elseif strcmp(T.types{j}(2),'R')
%                 F.colors{i+j-1}='g';
%             elseif strcmp(T.types{j}(2),'N')
%                 F.colors{i+j-1}=0.5*[1 1 1];
%             end
%             
%             if strcmp(T.types{j}(4),'L')
%                 F.markers{i+j-1}='+';
%             elseif strcmp(T.types{j}(4),'Q')
%                 F.markers{i+j-1}='o';
%             elseif strcmp(T.types{j}(4),'N')
%                 F.markers{i+j-1}='s';
%             elseif strcmp(T.types{j}(4),'S')
%                 F.markers{i+j-1}='x';
%             elseif strcmp(T.types{j}(4),'R')
%                 F.markers{i+j-1}='d';
%             end
            
            if strcmp(T.types{j},'DENL')
                F.linestyle{i+j-1}='-';
                F.colors{i+j-1}='g';
                F.markers{i+j-1}='o';
            elseif strcmp(T.types{j},'NENL')
                F.linestyle{i+j-1}='-';
                F.colors{i+j-1}='m';
                F.markers{i+j-1}='x';
            elseif strcmp(T.types{j},'DRNL')
                F.linestyle{i+j-1}='-';
                F.colors{i+j-1}='c';
                F.markers{i+j-1}='+';
            elseif strcmp(T.types{j},'DRNL')
                F.linestyle{i+j-1}='-';
                F.colors{i+j-1}='b';
                F.markers{i+j-1}='v';
            elseif strcmp(T.types{j},'NRNL')
                F.linestyle{i+j-1}='-';
                F.colors{i+j-1}='y';
                F.markers{i+j-1}='s';
            elseif strcmp(T.types{j},'NNNN')
                F.linestyle{i+j-1}='-';
                F.colors{i+j-1}=0.5*[1 1 1];
                F.markers{i+j-1}='.';
            end
                
            F.markersize{i+j-1}=8;
            F.linewidth{i+j-1}=2;

        end
    else
        F.colors{i}= 'k';           % brown
        F.markers{i}='+';
        F.markersize{i}=8;
        F.linewidth{i}=2;
    end
end