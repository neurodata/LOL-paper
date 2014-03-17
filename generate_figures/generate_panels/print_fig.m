function print_fig(h,wh,fname,renderer)
% h: figure handle
% fname: name of fig file & script
% wh: set paper width and height
if nargin==3, renderer='painters'; end

set(h,'PaperSize',wh,'PaperPosition',[-0.7 0 wh(1) wh(2)],'color','w');
set(h, 'InvertHardCopy', 'off');
set(h,'renderer',renderer)
saveas(h,fname,'fig')
print(h,fname,'-dpdf')
print(h,fname,'-dpng','-r300')

