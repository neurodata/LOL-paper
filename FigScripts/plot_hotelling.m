function plot_hotelling(T,S,Nrows,Ncols,substart)

col{1}='g'; col{2}='g';col{3}='m';col{4}='m';col{5}='r';col{6}='r';
ls{1}='--'; ls{2}='-'; ls{3}='--';ls{4}='-'; ls{5}='-';

for t=1:length(S)
    subplot(Nrows,Ncols,substart+t), cla
    hold all
    for d=1:size(S{t}.mean_power,1)
        if d==2, dd=1;
        elseif d==1, dd=2;
        else dd=d;
        end
        errorbar(T{t}.bvec,S{t}.mean_power(dd,:),S{t}.std_power(dd,:)/sqrt(T{t}.Ntrials),'linewidth',2,'color',col{dd},'linestyle',ls{dd})
    end
    ylabel('power')
    xlabel('exponent')
    axis('tight')
    set(gca,'xscale','log')
    legendcell={'H o \delta+PCA','H o \delta+RP','H o RP','H o PCA'}; %,transformers{3}};
    if T{t}.D < T{t}.n, legendcell{end+1}='Hotelling'; legendcell{end+1}='HotellingB'; end
     
    set(gca,'XTick',[0.1, 1, 10, 100])
    if t==1
        title('Diagonal: D=200, n=100')
    elseif t==2
        title('Correlated: D=200, n=100')
        legend(legendcell,'location','Northwest')
   end
end
