function [X,Y,task] = load_cancer(task)


switch task.name
    
    case 'prostate'
        data=load('../../data/base/prostate_data');
        X=data.X';
        Y=data.Y;
        [task.D, task.n] = size(X);
        task.ntest=round(task.n/3);
        task.ntrain=task.n-task.ntest;
    case 'colon'
        data=load('../../data/base/colon_data');
        X=data.X';
        Y=data.Y;
        [task.D, task.n] = size(X);
        task.ntest = round(task.n/3);
        task.ntrain = task.n-task.ntest;
    otherwise
        [X,Y] = load_pancreas(task.name);
        X=X';
        [task.D, task.n] = size(X);
        task.ntrain = task.n-2;
        task.ntest = 2;
end
Y=double(Y);