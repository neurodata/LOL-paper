task_list_name='cs5';
task.D=1000;
task.ntrain=100;
task_list = set_task_list(task_list_name);

for j=1:2
    task.name=task_list{j};
    tt=task;
    [task1, X, Y, P] = get_task(task);
    
    invSig=pinv(P.Sigma);
    BayesProj=P.del'*invSig;
    
    [u,d,v]=svd(P.Sigma);
    for k=1:1000, 
        rho(j,k)=corr(BayesProj',u(k,:)'); 
    end
    
    LOL=[P.del'; u];
    for k=1:1000, 
        rho_LOL(j,k)=corr(BayesProj',LOL(k,:)'); 
    end
    
end

%%
figure(5), clf, hold all

for j=1:2
    plot(rho_LOL(j,1:10),'linewidth',2)
    plot(rho(j,1:10),'--','linewidth',2)
end
legend('LOL:ac','LOL:trunk','PCA:ac','PCA:trunk')
