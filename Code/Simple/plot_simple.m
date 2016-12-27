%% plot
clear, clc
load('rtrunk')


%%
figure(1), clf, hold all
Lmax=0;
Lmin=1;
ddiv=4;
A=length(algs);
nmc=length(Lhat);
for a=1:A
    if isfield(Lhat,algs{a})
        for i=1:nmc
            L(i,:)=Lhat(i).(algs{a});
        end
        meanL=mean(L);
        plot(ks{1},meanL,'linewidth',2,'DisplayName',algs{a})
        Lmax=max(Lmax,max(meanL));
        Lmin=min(Lmin,min(meanL));
    end
end
ylabel(setting)
title(['D = ', num2str(D(1)), ', n = ', num2str(ntrain(1))])
xlim([0,D(1)/ddiv])
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
