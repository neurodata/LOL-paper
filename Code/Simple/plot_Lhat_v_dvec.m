function plot_Lhat_v_dvec(setting,F)

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
if ~isfield(F,'color')
    col=get(groot,'defaultAxesColorOrder');
    algs={'LOL';'RRLDA';'eigenfaces';'ROAD';'lasso';'LRL';'QOQ'};
    for a=1:length(algs)
        F.color.(algs{a})=col(a,:);
    end
    F.color.('Bayes')=[0 0 0];
end


%%
% figure(1),
h=subplot(F.nrows,F.ncols,(F.row-1)*F.ncols+1);
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
            end
            meanL=mean(L);
            plot(ks{1}.('LOL'),meanL,'linewidth',2,'DisplayName',alg,'color',F.color.(alg),'LineStyle',ls)
            Lmax=max(Lmax,max(meanL));
            Lmin=min(Lmin,min(meanL));
        end
    end
end
%%

% F.ylab=[{F.ylab};{['n=', num2str(ntrain(1)), ', D=', num2str(D(1))]}];
if F.row==F.nrows, F.xlab=xlab; end
ylabel(F.ylab)
xlabel(F.xlab)
% title(['D = ', num2str(D(1)), ', n = ', num2str(ntrain(1))])
xmax=min(D(1),ntrain(1));
xlim([1,F.xmax])
if isfield(F,'ymax'), Lmax=F.ymax; end
if isfield(Lhat,'Bayes')
    if ~isnan(Lhat(1).Bayes)
        plot([1:F.xmax],meanL*ones(F.xmax,1),'k','linewidth',2)
    end
end
ylim([Lmin,Lmax])
set(gca,'XTick',round(linspace(F.xmax/3,F.xmax,3)))
if F.legend
    legend('show')
end
if F.row==1, title([{'Misclassification Rate'};{'D=100, n=100'}]), end