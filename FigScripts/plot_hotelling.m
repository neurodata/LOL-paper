function plot_hotelling(T,S,Nrows,Ncols,substart)

col{1}='g'; col{2}='g';col{3}='m';col{4}='m';col{5}='r';col{6}='r';
ls{1}='--'; ls{2}='-'; ls{3}='--';ls{4}='-'; ls{5}='-';

for t=1:length(S)
    subplot(Nrows,Ncols,substart+t), cla
    hold all
    for d=1:size(S{t}.mean_power,1)
        errorbar(T{t}.bvec,S{t}.mean_power(d,:),S{t}.std_power(d,:)/sqrt(T{t}.Ntrials),'linewidth',2,'color',col{d},'linestyle',ls{d})
    end
    ylabel('power')
    xlabel('exponent')
    axis('tight')
    set(gca,'xscale','log')
    legendcell={'H o \delta+RP','H o \delta+PCA','H o RP','H o PCA'}; %,transformers{3}};
    if T{t}.D < T{t}.n, legendcell{end+1}='Hotelling'; legendcell{end+1}='HotellingB'; end
     
    set(gca,'XTick',[0.1, 1, 10, 100])
    if t==1
        title('Trunk: D=100, n=50')
    elseif t==2
        title('Dense Toeplitz: D=100, n=50')
        legend(legendcell,'location','Northwest')
   end
end
