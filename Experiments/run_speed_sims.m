% generalizations figure
% clearvars, clc,
fpath = mfilename('fullpath');
findex=strfind(fpath,'/');
p = genpath(fpath(1:findex(end-2)));
addpath(p);
fname='speed_test';

%% task properties consistent across all tasks
clear task
task0.algs={'LOL'};
task0.simulation=1;
task0.percent_unlabeled=0;
task0.ntrials=10;
task0.ntrain=100;
task0.ntest=100;
task0.n=task0.ntrain+task0.ntest;
task0.name='oc';

savestuff=1;

types={ 'NENL';... PCA
        'DENL';... LOL
        'DVFQ';... QOQ
%         'DERL';... RoLOL
        'DEAL';... RaLOL
        'DEFL';... fLOL
        };

Ntypes=length(types);

ks=10:20:90;
Nks=length(ks);

Ds=[1000, 2000, 5000]; % [100, 200, 500, 1000, 2000, 5000, 10000];
NDs=length(Ds);

%% generate data

%%%%%%%%% DO NOT PARFOR THIS!!! %%%%%%%%%%%%%
learn_time=nan(Ntypes,task0.ntrials,Nks,NDs);
classify_time=nan(Ntypes,task0.ntrials,Nks,NDs);
for j=1:task0.ntrials
    for t=1:Ntypes
        for kk=1:Nks
            for d=1:NDs
                task_in=task0;
                task_in.D=Ds(d);
                task_in.ks=ks(kk);
                task_in.types=types(t);
                
                fprintf('D=%d, k=%d, type=%s, trial=%d\n',task_in.D, task_in.ks,types{t},j)
                
                [Tin,~,~,~] = get_task(task_in);       % get T details
                [task, X, Y, P] = get_task(Tin);
                Z = parse_data(X,Y,task.ntrain,task.ntest);
                
                [transformers, deciders] = parse_algs(task.types);
                tic
                [Proj, Phat] = LOL(Z.Xtrain',Z.Ytrain,transformers,max(task.ks));
                learn_time(t,j,kk,d)=toc;
                
                tic
                Xtest=Proj{1}.V*Z.Xtest;
                Xtrain=Proj{1}.V*Z.Xtrain;
                Yhat = decide(Xtest,Xtrain,Z.Ytrain,deciders{1}{1},task.ks);
                classify_time(t,j,kk,d)=toc;
                
            end
        end
    end
    
    % get stats
    mean_learn=squeeze(nanmean(learn_time,2));
    mean_class=squeeze(nanmean(classify_time,2));
    mean_total=mean_learn+mean_class;
    
    std_learn=squeeze(nanstd(learn_time,[],2));
    std_class=squeeze(nanstd(classify_time,[],2));
    std_total=std_learn+std_class;
    
    % save speed
    if savestuff
        save([fpath(1:findex(end-2)), 'Data/Results/', fname])
    end
    % load([fpath(1:findex(end-2)), 'Data/Results/', fname])
    
end




%% plot time vs. k for several D's
h=figure(2); clf, hold all

set(gcf,'DefaultAxesColorOrder',[...
    0 0 0;...
    0 0 1;...
    0 1 0;...
    0 1 1;...
    1 0 0;...
    1 0 1;...
    ])

for i=1:3
    subplot(2,3,i), hold all
    for j=1:Ntypes
        errorbar(ks, mean_total(j,:,i),std_total(j,:,i),'linewidth',2)
    end
    grid on, axis('tight')
    set(gca,'xscale','log','Xtick',ks,'yscale','log')
    title(['D=', num2str(Ds(i))])
    if i==1,
        xlabel('# of embedded dimensions'),
        ylabel('time (sec)')
    end
    set(gca,'Ytick',[0.005, 0.01, 0.02, 0.05, 0.1]) %:0.02:0.09)
    
end

%% plot time vs. D for several k's
for i=1:3
    subplot(2,3,3+i), hold all
    if i==1, ii=1; elseif i==2, ii=3; else ii=5; end
    for j=1:Ntypes
        errorbar(Ds, squeeze(mean_total(j,ii,:)),squeeze(std_total(j,ii,:)),'linewidth',2)
    end
    grid on, axis('tight')
    set(gca,'xscale','log','Xtick',Ds,'yscale','log')
    title(['k=', num2str(ks(ii))])
    if i==1,
        xlabel('# of ambient dimensions'),
        ylabel('time (sec)')
    end
    set(gca,'Ytick',[0.005, 0.01, 0.02, 0.05, 0.1]) %:0.02:0.09)
    
end

legend(types)

%% print figure
if savestuff
    H.wh=[6.5 2.5]*1.2;
    H.fname=[fpath(1:findex(end-2)), 'Figs/', fname];
    print_fig(h,H)
end

%%

% ass=squeeze(mean_total(1,:,:));
% siz=size(mean_total);
% 
% figure(2);clf;hold on
% [xx yy] = meshgrid(1:length(Ds),1:length(ks));
% colormap([0 0 1;0 1 0; 0 1 1; 1 0 0]) %red and blue
% for j=[1,3,4]
%     surf(xx,yy,squeeze(mean_total(j,:,:))-squeeze(mean_total(2,:,:)),ones(size(ass))+j); %first color (red)
% end
% view(17,22)