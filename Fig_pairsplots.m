clear, clc,

savestuff=1;
dataset_list_name = 'all_sims';
dataset_list = set_dataset_list(dataset_list_name);


for j=1:length(dataset_list)
    
    display(dataset_list{j})
    
    [dataset, X, Y, P] = get_dataset(dataset_list{j});
    
    
    if dataset.ntest < 10
        dataset.ntest = round(dataset.n/2);
        dataset.ntrain = dataset.n-dataset.ntest;
    end
    
    Z = parse_data(X,Y,dataset.ntrain,dataset.ntest);
    [Z,Proj,Phat,dataset] = embed_data(Z,dataset);
    
    h(j)=figure(j); clf
    
    
    if dataset.D > 5; % only make plots if there are enough dimensions
        
        if isstruct(P)
            for i=1:10;
                d(i)=find(P.pi==i);
            end
        else
            d=1:10;
        end
        
        nrows=dataset.Nalgs+1;
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
                title(dataset.name)
            end
            set(gca,'XTick',[],'YTick',[])
            
            for i=1:dataset.Nalgs
                subplot(nrows,ncols,k+(Npairs)*(i)), hold all
                x01=Z.Xtest_proj{i}(pairs(k,1),Z.Ytest==0);
                x02=Z.Xtest_proj{i}(pairs(k,2),Z.Ytest==0);
                plot(x01,x02,'r.')
                
                x11=Z.Xtest_proj{i}(pairs(k,1),Z.Ytest==1);
                x12=Z.Xtest_proj{i}(pairs(k,2),Z.Ytest==1);
                plot(x11,x12,'k.')
                axis([min([x01,x11]) max([x01,x11]) min([x02,x12]) max([x02,x12])])
                if i==dataset.Nalgs
                    xlabel(pairs(k,1))
                    ylabel(pairs(k,2))
                end
                if k==1, ylabel(dataset.algs{i}), end
                set(gca,'XTick',[],'YTick',[])
            end
        end
        
        % save figs
        if dataset.savestuff
            wh=[dataset.Nalgs 4]*1.5;
            print_fig(h(j),wh,['../figs/pairsplots_', dataset.name])
        end
       
    else
        display(['dim too small for ', dataset.name, ' to make pairsplots']) 
    end
    
end

