function plot_Lhat_v_dvec(setting,F)

load(setting)
if nargin<2, F=struct; end
if ~isfield(F,'ddiv') F.ddiv=1; end
if ~isfield(F,'legend'), F.legend=1; end
if ~isfield(F,'nrows'), F.nrows=1; end
if ~isfield(F,'ncols'), F.ncols=1; end
if ~isfield(F,'row'), F.row=1; end
if ~isfield(F,'ylab'), F.ylab=setting; end
if ~isfield(F,'xlab'), F.xlab='# of Embedded Dimensions'; end
if ~isfield(F,'xmax'), F.xmax=min(D(1),ntrain(1)); end
if ~isfield(F,'color')
    col=get(groot,'defaultAxesColorOrder');
    algs={'LOL';'RRLDA';'eigenfaces';'ROAD';'lasso';'LRL';'QOQ'};    
    for a=1:length(algs)
        F.color.(algs{a})=col(a,:);
    end
end

%%
% figure(1), 
subplot(F.nrows,F.ncols,(F.row-1)*F.ncols+1)
cla, hold all
Lmax=0;
Lmin=1;
A=length(algs);
nmc=length(Lhat);
for a=1:A
    alg=algs{a};
    if isfield(Lhat,alg)
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
        plot(ks{1}.('LOL'),meanL,'linewidth',2,'DisplayName',alg,'color',F.color.(alg))
        Lmax=max(Lmax,max(meanL));
        Lmin=min(Lmin,min(meanL));
    end
end
ylabel(F.ylab)
xlabel(F.xlab)
% title(['D = ', num2str(D(1)), ', n = ', num2str(ntrain(1))])
xmax=min(D(1),ntrain(1));
xlim([1,F.xmax])
ylim([Lmin,Lmax])

if F.legend
    legend('show')
end

