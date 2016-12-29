function plot_simple(setting)
% %% plot
% clear, clc
% settings={...
%     'rtrunk';...
%     'toeplitz';...
%     '3trunk4';...
%     'fat_tails';...
%     'xor2';...
%     'outliers';...
%     'prostate';...
%     'colon';...
%     'MNIST';...
%     'CIFAR-10'};

load(setting)


%%
figure(1), clf, hold all
Lmax=0;
Lmin=1;
ddiv=2;
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
        plot(ks{1}.('LOL'),meanL,'linewidth',2,'DisplayName',alg)
        Lmax=max(Lmax,max(meanL));
        Lmin=min(Lmin,min(meanL));
    end
end
ylabel(setting)
title(['D = ', num2str(D(1)), ', n = ', num2str(ntrain(1))])
xmax=min(D(1),ntrain(1));
xlim([0,xmax/ddiv])
ylim([Lmin,Lmax])
legend('show')

%%
% figure(1), clf
% for s=1:S
%     subplot(S,1,s), cla, hold all
%     Lmax=0;
%     Lmin=1;
%     for a=1:A
%         for i=1:nmc
%             L(i,:)=Lhat(s,i).(algs{a});
%         end
%         meanL=mean(L);
%         plot(ks{s,1},meanL,'linewidth',2,'DisplayName',algs{a})
%         Lmax=max(Lmax,max(meanL));
%         Lmin=min(Lmin,min(meanL));
%     end
%     ylabel(settings{s})
%     title(['D = ', num2str(D(s,1)), ', n = ', num2str(n(s,1))])
%     xlim([0,D(s,1)/4])
%     ylim([Lmin,Lmax])
% end
% legend('show')

% clf, hold all
% plot(ks,Lhat.LOL,'linewidth',2,'DisplayName','LOL')
% plot(ks,Lhat.RRLDA,'linewidth',2,'DisplayName','RR-LDA')
% plot(ks,Lhat.QOQ,'linewidth',2,'DisplayName','QOQ')
% plot(ks,Lhat.LRL,'linewidth',2,'DisplayName','LRL')
% plot(ks,Lhat.eigenfaces,'linewidth',2,'DisplayName','Eigenfaces')
% plot(ks,Lhat.ROAD,'linewidth',2,'DisplayName','ROAD')
% plot(ks,Lhat.lasso,'linewidth',2,'DisplayName','Lasso')
%
% legend('show')
