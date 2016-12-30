function plot_means(setting,F)

load(setting)
if ~isfield(F,'ddiv') F.ddiv=1; end
if ~isfield(F,'legend'), F.legend=1; end

%%
% figure(1), 
subplot(F.nrows,F.ncols,(F.row-1)*F.ncols+2)
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
