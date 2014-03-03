function print_fig(wh,fname)
% h: figure handle
% fname: name of fig file & script
% wh: set paper width and height

set('PaperSize',wh,'PaperPosition',[0 0 wh],'color','w');
set('InvertHardCopy', 'off');
saveas(fname,'fig')
print(fname,'-dpdf')
print(fname,'-dpng','-r300')

