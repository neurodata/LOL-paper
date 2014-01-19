function print_fig(h,wh,fname)
% h: figure handle
% fname: name of fig file & script
% wh: set paper width and height

set(h,'PaperSize',wh,'PaperPosition',[0 0 wh],'color','w');
set(h, 'InvertHardCopy', 'off');
saveas(h,['../figs/', fname],'fig')
print(h,['../figs/', fname],'-dpdf')

