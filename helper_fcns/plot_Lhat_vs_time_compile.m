function [Lhats, times] = plot_Lhat_vs_time_compile(T,S,task_list_name)


h(2)=figure(2); clf, hold all
for i=1:T{1}.Nalgs
    for j=1:length(S)
        times(j,i)=S{j}.mins.mean.times(i);
        Lhats(j,i)=S{j}.mins.mean.Lhats(i);
    end
    Lhats(Lhats>1-10^-4)=NaN;
    F = figure_settings(T{j});
    plot(times(:,i),Lhats(:,i),'-','color',F.colors{i},'MarkerSize',F.markersize{i},'Marker',F.markers{i},'LineWidth',F.linewidth{i})
end
set(gca,'XScale','log')
grid('on')
xlabel('time (sec)')
ylabel('$\langle \hat{L}_n \rangle$','interp','latex')
axis('tight')
title('Performance for Varying Ambient Dimension')


%% save plots
if T{1}.savestuff
    wh=[2 2]*1.2;
    F.PaperSize=wh;
    F.PaperPosition=[0 0 wh];
    F.fname=['../../figs/', char(strcat('performance_compiled_', task_list_name))];
    print_fig(h(2),F)
end
