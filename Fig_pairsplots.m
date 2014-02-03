clear, clc,

savestuff=1;
task_list_name = 'all_sims';
task_list = set_task_list(task_list_name);


for j=1:length(task_list)
    
    display(task_list{j})
    
    [task, X, Y, P] = get_task(task_list{j});
    
    
    if task.ntest < 10
        task.ntest = round(task.n/2);
        task.ntrain = task.n-task.ntest;
    end
    
    Z = parse_data(X,Y,task.ntrain,task.ntest);
    [Z,Proj,Phat,task] = embed_data(Z,task);
    
    h(j)=figure(j); clf
    
    
    if task.D > 5; % only make plots if there are enough dimensions
        
        if isstruct(P)
            for i=1:10;
                d(i)=find(P.pi==i);
            end
        else
            d=1:10;
        end
        
        nrows=task.Nalgs+1;
        dpairs=[d(1),d(2); d(1),d(3); d(2),d(3); d(3),d(4); d(4),d(5)];
        pairs=[1,2; 1,3; 2,3; 3,4; 4,5];
        Npairs=length(pairs);
        ncols=Npairs;
        
        
        for k=1:Npairs
            subplot(nrows,ncols,k), hold all
            plot(Z.Xtest(dpairs(k,1),Z.Ytest==0),Z.Xtest(dpairs(k,2),Z.Ytest==0),'r.')
            plot(Z.Xtest(dpairs(k,1),Z.Ytest==1),Z.Xtest(dpairs(k,2),Z.Ytest==1),'k.')
            %         axis([-1 1 -1 1])
            if k==1,
                ylabel('Ambient'),
                title(task.name)
            end
            set(gca,'XTick',[],'YTick',[])
            
            for i=1:task.Nalgs
                subplot(nrows,ncols,k+(Npairs)*(i)), hold all
                x01=Z.Xtest_proj{i}(pairs(k,1),Z.Ytest==0);
                x02=Z.Xtest_proj{i}(pairs(k,2),Z.Ytest==0);
                plot(x01,x02,'r.')
                
                x11=Z.Xtest_proj{i}(pairs(k,1),Z.Ytest==1);
                x12=Z.Xtest_proj{i}(pairs(k,2),Z.Ytest==1);
                plot(x11,x12,'k.')
                axis([min([x01,x11]) max([x01,x11]) min([x02,x12]) max([x02,x12])])
                if i==task.Nalgs
                    xlabel(pairs(k,1))
                    ylabel(pairs(k,2))
                end
                if k==1, ylabel(task.algs{i}), end
                set(gca,'XTick',[],'YTick',[])
            end
        end
        
        % save figs
        if task.savestuff
            wh=[task.Nalgs 4]*1.5;
            print_fig(h(j),wh,['../figs/pairsplots_', task.name])
        end
       
    else
        display(['dim too small for ', task.name, ' to make pairsplots']) 
    end
    
end

