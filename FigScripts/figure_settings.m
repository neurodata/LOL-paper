function F = figure_settings(T,F)

F.gray=0.5*[1 1 1];

for i=1:length(T.types)
    
    if strcmp(T.types{i},'DENL')
        F.linestyle{i}='-';
        F.colors{i}='g';
        F.markers{i}='o';
    elseif strcmp(T.types{i},'NENL')
        F.linestyle{i}='-';
        F.colors{i}='m';
        F.markers{i}='x';
    elseif strcmp(T.types{i},'DRNL')
        F.linestyle{i}='-';
        F.colors{i}='c';
        F.markers{i}='+';
    elseif strcmp(T.types{i},'DRNL')
        F.linestyle{i}='-';
        F.colors{i}='b';
        F.markers{i}='v';
    elseif strcmp(T.types{i},'NRNL')
        F.linestyle{i}='-';
        F.colors{i}='y';
        F.markers{i}='s';
    elseif strcmp(T.types{i},'NNNN')
        F.linestyle{i}='-';
        F.colors{i}=0.5*[1 1 1];
        F.markers{i}='.';
        
        
    elseif strcmp(T.types{i},'DENQ')
        F.linestyle{i}='--';
        F.colors{i}='c';
        F.markers{i}='x';
    elseif strcmp(T.types{i},'DVNL')
        F.linestyle{i}='--';
        F.colors{i}='m';
        F.markers{i}='x';
    elseif strcmp(T.types{i},'DVNQ')
        F.linestyle{i}='--';
        F.colors{i}='b';
        F.markers{i}='x';
        
    else
        F.linestyle{i}='-';
        F.colors{i}='k';
        F.markers{i}='x';
    end
    
    F.markersize{i}=8;
    F.linewidth{i}=2;
    
end
