function [task,T,S,P,Pro,Z] = run_MNIST(rootDir,task)

%% task properties consistent across all tasks

if ~isfield(task,'savestuff'), task.savestuff=1; end
if ~isfield(task,'algs'), task.algs={'LOL';'GLM'};  end
if ~isfield(task,'types'), task.types={'DENL'}; end
task.simulation=0;
task.percent_unlabeled=0;
task.name='MNIST(378)';
task.ntrain=300;
task.ntrials=10; %if <2, plotting will barf
task.Nks=25;
task.ks=unique(round(logspace(0,log10(task.ntrain),task.Nks)));
task1=task;
[T{1},S{1},P{1},Proj{1}] = run_task(task);

task.algs={'LOL'}; 
task.types={'NENL'};
task2=task;
[T{2},S{2},P{2},Proj{2}] = run_task(task);


%% fix T and Pro

T{1}.types={task1.types{:};task2.types{:}};
Pro{1}=Proj{1}{1};
Pro{2}=Proj{2}{1};

%% get GLM proj
[TT,X,Y,PP] = get_task(T{1});       % get T details
Z = parse_data(X,Y,TT.ntrain,TT.ntest,TT.percent_unlabeled);
[out, GLM_num, fit] = run_GLM(Z,task);
ijk=1; nl=0;
while nl<4,
    
    idx1=[find(abs(fit.beta{1}(:,ijk))>1e-4)];
    idw1=[fit.beta{1}(idx1,ijk)];
    
    idx2=[find(abs(fit.beta{2}(:,ijk))>1e-4)];
    idw2=[fit.beta{2}(idx2,ijk)];
    
    idx3=[find(abs(fit.beta{3}(:,ijk))>1e-4)];
    idw3=[fit.beta{3}(idx3,ijk)];
    
    idx=[idx1; idx2; idx3];
    [id, foo]=unique(idx);
    nl=numel(id);
    ijk=ijk+1;
end
idw=[idw1; idw2; idw3];
idw=idw/norm(idw);
ln=length(idw);
Pro{3}.V=zeros(ln,784);
for ijk=1:ln
    Pro{3}.V(ijk,idx(ijk))=idw(ijk);
end
Pro{3}.name='GLM';

%% save stuff
if task.savestuff
    save([rootDir, '../Data/Results/mnist.mat'],'task','T','S','P','Pro','Z')
end
