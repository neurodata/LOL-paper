function [X,Y,task] = load_cancer(task)


switch task.name
    
    case 'prostate'
        data=load('../data/base/prostate_data');
        X=data.X;
        Y=data.Y;
        [task.n, task.D] = size(X);
        task.ntest=round(task.n/3);
        task.ntrain=task.n-task.ntest;
    case 'colon'
        data=load('../data/base/colon_data');
        X=data.X;
        Y=data.Y;
        [task.n, task.D] = size(X);
        task.ntest = round(task.n/3);
        task.ntrain = task.n-task.ntest;
    otherwise
        [X,Y] = load_pancreas(task.name);
        [task.n, task.D] = size(X);
        task.ntrain = task.n-2;
        task.ntest = 2;
end

%         load('../data/base/pancreas_data');
%         tasks.settings={'IPMN-HvL';'IPMN-HvML'; 'IPMN-HMvL';'IPMNvsAll';'MCNvsAll';'SCAvsAll'};
% 
%         [n, D] = size(X);
%         ntest=2;
%         ntrain=n-ntest;
% 
% if strfind(task,'pancreas')
% else
%     [X,Y]=choose_cancer(task.name);
%     [task.n, task.D]=size(X);
%     task.ntrain=round(task.n*2/3);
%     task.ntest=task.n-task.ntrain;
%     P=[]; % output empty parameter structure if data are real
% end