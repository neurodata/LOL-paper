% this script generates the simulation and plots the results for Fig 1

%% set path correctly
clearvars, clc,
fpath = mfilename('fullpath');
findex=strfind(fpath,'/');
p = genpath(fpath(1:findex(end-2)));
addpath(p);
s=rng;
% save('~/Research/working/A/LOL/Data/randstate','s')
% load([fpath(1:findex(end-2)), 'Data/randstate']);
% rng(s);

%% set up tasks
clear idx
task_list_name='regression';
task.D=100;
task.ntrain=100;
task.ks=20;
task.name='regress';
task.ntest=500;
task.rotate=false;
task.algs={'LOL'};
task.types={'DEFZ'};
task.savestuff=0;

% generate data and embed it
[task1, X, Y, P] = get_task(task);

Z = parse_data(X,Y,task1.ntrain,task1.ntest,0);

Yhats = LOL_classify(Z.Xtest',Z.Xtrain',Z.Ytrain,task);
out=get_task_stats(Yhats,Z.Ytest);


%     subplot(Nrows,Ncols,j),
% switch j
%     case 1, tit='(A) Aligned';
%     case 2, tit='(B) Orthogonal';
%     case 3, tit='(C) Rotated Orthogonal';
% end
% title(tit)

% [transformers, deciders] = parse_algs(task1.types);
% Proj = LOL(Z.Xtrain,Z.Ytrain,transformers,task1.Kmax);
% PP{2}=Proj{1};
% PP{1}=Proj{2};
% Proj=PP;

for i=1:Nrows-1
    Xtest=Proj{i}.V(1:k,:)*Z.Xtest;
    Xtrain=Proj{i}.V(1:k,:)*Z.Xtrain;
    
    set(gca,'XTickLabel',[],'YTickLabel',[],'XTick',[],'YTick',[])
end


%% save figs
if task.savestuff
    F.fname=[fpath(1:findex(end-2)), 'Figs/cigars'];
    F.wh=[2 1.5]*2.5;
    print_fig(h(1),F)
end