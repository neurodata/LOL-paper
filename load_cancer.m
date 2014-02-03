function [X,Y,dataset] = load_cancer(dataset)


switch dataset.name
    
    case 'prostate'
        data=load('../data/base/prostate_data');
        X=data.X';
        Y=data.Y;
        [dataset.D, dataset.n] = size(X);
        dataset.ntest=round(dataset.n/3);
        dataset.ntrain=dataset.n-dataset.ntest;
    case 'colon'
        data=load('../data/base/colon_data');
        X=data.X';
        Y=data.Y;
        [dataset.D, dataset.n] = size(X);
        dataset.ntest = round(dataset.n/3);
        dataset.ntrain = dataset.n-dataset.ntest;
    otherwise
        [X,Y] = load_pancreas(dataset.name);
        X=X';
        [dataset.D, dataset.n] = size(X);
        dataset.ntrain = dataset.n-2;
        dataset.ntest = 2;
end