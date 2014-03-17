function print_fig(h,F)
% h: figure handle
% fname: name of fig file & script
% wh: set paper width and height
if ~isfield(F,'renderer'), F.renderer='painters'; end

set(h,'PaperSize',F.PaperSize,'PaperPosition',F.PaperPosition,'color','w');
set(h, 'InvertHardCopy', 'off');
set(h,'renderer',F.renderer)
saveas(h,F.fname,'fig')
print(h,F.fname,'-dpdf')
print(h,F.fname,'-dpng','-r300')

