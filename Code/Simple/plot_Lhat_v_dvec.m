function [minL, wallTime, F] = plot_Lhat_v_dvec(setting,F)

% run('colorbrewer.m')
load(setting)
xlab='# of Embedded Dimensions';
if nargin<2, F=struct; end
if ~isfield(F,'ddiv') F.ddiv=1; end
if ~isfield(F,'legend'), F.legend=1; end
if ~isfield(F,'nrows'), F.nrows=1; end
if ~isfield(F,'ncols'), F.ncols=1; end
if ~isfield(F,'row'), F.row=1; end
if ~isfield(F,'ylab'), F.ylab=setting; end
if ~isfield(F,'xlab'), F.xlab=xlab; end
if ~isfield(F,'xmax'), F.xmax=min(D(1),ntrain(1)); end
if ~isfield(F,'algs'), F.algs=algs; end
if ~isfield(F,'xticks'), F.xticks=round(linspace(F.xmax/3,F.xmax,3)); end
if ~isfield(F,'savestuff'), F.savestuff=0; end
if ~isfield(F,'tit'), F.tit=[{'Misclassification Rate'};{'D=100, n=100'}]; end
if ~isfield(F,'color')
    col=get(groot,'defaultAxesColorOrder');
    algs={'LOL';'PCA''';'PCA';'ROAD';'lasso';'LRL';'QOQ'};
    ms = {'o';'+';'d';'v';'^';'x';'s';'<';'>';'p';'h';'*'};
    for a=1:length(algs)
        F.color.(algs{a})=col(a,:);
        F.markerstyle.(algs{a})=ms{a};
    end
    F.color.('Bayes')=[0 0 0];
end


%%
g=figure(1);
if F.nrows>F.ncols
    h=subplot(F.nrows,F.ncols,(F.row-1)*F.ncols+1);
else
    h=subplot(F.nrows,F.ncols,F.row);
end

cla, hold all
Lmax=0;
Lmin=1;
A=length(F.algs);
if isfield(Lhat,'Bayes'), A=A+1; F.algs{A}='Bayes'; end
nmc=length(Lhat);
for a=1:A
    ls='-';
    alg=F.algs{a};
    if strcmp(alg,'QOQ')
        ls='--';
        F.color.(alg)=F.color.('LOL');
    end
    if isfield(Lhat,alg)
        if ~strcmp(alg,'Bayes')
            L=[];
            for i=1:nmc
                if strcmp(alg,'lasso')
                    LL=lasso_interp(ks{i}.(alg),Lhat(i).(alg),ks{i}.('LOL'));
                else
                    LL=Lhat(i).(alg);
                end
                L(i,:)=LL;
                if exist('wt'), wallTime(a,i)=wt(i).(alg); else, wallTime=[]; end
            end
            meanL=nanmean(L);
            minL(a)=min(meanL);
            maxL=max(meanL);
            plot(ks{1}.('LOL'),meanL,'linewidth',2,'DisplayName',alg,'color',F.color.(alg),'LineStyle',ls)
            Lmax=max(Lmax,maxL);
            Lmin=min(Lmin,minL(a));
        end
    end
end

algs=F.algs;

%%

% F.ylab=[{F.ylab};{['n=', num2str(ntrain(1)), ', D=', num2str(D(1))]}];
if F.row==F.nrows, F.xlab=xlab; end
if F.row==1, title([{'Misclassification'}, {'Rate'}]), end

if strcmp(F.sit,'real')
    t=title([{[ F.ylab]}; {['D = ',num2str(median(D)), ', n = ', num2str(median(ntrain))]}]); 
    set(t, 'horizontalAlignment', 'left')
    set(t, 'units', 'normalized')
    set(t, 'position', [0.1 0.8 0])
    if F.row==1, ylabel('Misclassification Rate'); end
else
    ylabel(F.ylab) %, 'horizontalAlignment', 'right')
%     if F.row==1, title(F.ylab), end
end
xlabel(F.xlab)
% title(['D = ', num2str(D(1)), ', n = ', num2str(ntrain(1))])
xmax=min(D(1),ntrain(1));
xlim([1,F.xmax])
if isfield(F,'ymax'), Lmax=F.ymax; end
if isfield(Lhat,'Bayes')
    %     if ~isnan(Lhat(1).Bayes)
    %         plot([1:F.xmax],meanL*ones(F.xmax,1),'k','linewidth',2)
    %     end
end


ylim([Lmin,Lmax])
set(gca,'XTick',F.xticks)
if strcmp(setting,'toeplitz')
    Lmin=floor(Lmin*10)/10; 
    set(gca,'YTick',0:0.1:1)
end
if F.legend
    legend('show')
end

if F.savestuff
    F.fname=setting;
    F.wh=[6, 3.5];
    print_fig(g,F)
end