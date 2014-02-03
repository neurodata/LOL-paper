function [X,Y] = choose_cancer(which)



switch which
    case 'colon'
        load('../data/base/colon_data');
        [n, D] =size(X);
        ntest=round(n/3);
        ntrain=n-ntest;
    case 'prostate'
        load('../data/base/prostate_data');
        datasets.settings={'raw'};
        [n, D] =size(X);
        ntest=round(n/3);
        ntrain=n-ntest;
    case 'pancreas'
        load('../data/base/pancreas_data');
        datasets.settings={'IPMN-HvL';'IPMN-HvML'; 'IPMN-HMvL';'IPMNvsAll';'MCNvsAll';'SCAvsAll'};

        [n, D] = size(X);
        ntest=2;
        ntrain=n-ntest;
        
end
