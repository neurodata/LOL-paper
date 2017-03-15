function plot_timing(minL,wallTime,s,F)

% if ~isfield(F,'markerstyle')
%     ms = {'o';'+';'d';'v';'^';'*';'x';'s';'<';'>';'p';'h'};
%     for a=1:length(F.algs)
% %         F.color.(algs{a})=col(a,:);
%         F.markerstyle.(F.algs{a})=ms{a};
%     end
% end
F.markersize=5;
F.linewidth=2;
F.xlim=[0,20]; %[minx, max(S{s}.time(:))]
F.xtick=10.^[-1:10];
F.ylim=[0,0.2];
F.ytick=[0:0.1:1];
minx=0.01;
miny=0;

subplot(F.nrows,F.ncols,(F.row-1)*F.ncols+2)
hold all

mwt=mean(wallTime');
F.xlim=[min(mwt), max(mwt)];
F.ylim=[max(0,min(minL)-(max(minL)-minL(1))),max(minL)];
% if s~=4
%     minx=0.01; %miny=0.01;
% else
%     minx=0.01;
%     F.ylim(1)=0.65;
    %         F.xtick=logspace(-1,4,5);
%     F.xlim=[0.1, 100];
%     F.ytick=0:0.1:1;
% end
% if s>2
%     F.colors={'g';'m';orange;'b'};
%     F.markerstyle = {'o';'+';'d';'^'};
% else
%     F.ylim(1)=0.05;
%     F.ytick=[0:0.05:1];
% end
if s==1
    F.xlim(1)=0.01; 
end
if s==2
    F.xlim(1)=0.01;
%     F.ylim(1)=0.1;
    %     F.ytick=[0.05:0.1:1]; 
end
if s==3
%     F.ytick=[0:0.2:1]; 
    F.ytick=[0:0.05:1];
    F.xtick=[0.1,10];
%     F.ylim(1)=0.25;
end
if s==4
    F.xtick=[1,30];
end


rectangle('Position',[minx,miny,mean(wallTime(1,:))-minx,minL(1)-miny],'FaceColor',0.6*[1 1 1],'EdgeColor','none')
rectangle('Position',[mean(wallTime(1,:)),minL(1),1000,1],'FaceColor',0.9*[1 1 1],'EdgeColor','none')
% plot([minx,100],mean(S{s}.Lchance)*[1 1],'--k')
for a=1:length(F.algs)-1
    plot(mean(wallTime(a,:)),minL(a),'.','color',F.color.(F.algs{a}),'marker',F.markerstyle.(F.algs{a}),'markersize',F.markersize,'LineWidth',F.linewidth)
end
xticklabel=(F.xtick);
set(gca,'Xlim',F.xlim,'Ylim',F.ylim,'Xtick',F.xtick,'Ytick',F.ytick,'XTickLabel',xticklabel)
if s==1, ylabel('min error rate'), end
set(gca,'Xscale','log','Yscale','linear')
if s==4
    xlabel(['time (sec)']);
end
