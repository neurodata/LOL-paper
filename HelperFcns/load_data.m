function [X,Y,task] = load_data(task)


if strcmp(task.name,'Prostate')
    data=load('../../Data/Preprocessed/prostate_data');
    X=data.X';
    Y=data.Y+1;
    [task.D, task.n] = size(X);
    task.ntest=round(task.n/3);
    task.ntrain=task.n-task.ntest;
elseif strcmp(task.name,'Colon')
    data=load('../../Data/Preprocessed/colon_data');
    X=data.X';
    Y=data.Y+1;
    [task.D, task.n] = size(X);
    task.ntest = round(task.n/3);
    task.ntrain = task.n-task.ntest;
elseif strfind(task.name,'pancreas')
    %          {'IPMNvsAll','IPMN-HvsAll','IPMN-MvsAll','IPMN-LvsAll','MCNvsAll','SCAvsAll','IPMN-HvL','IPMN-HvML','IPMN-HMvL'}
    [X,Y] = load_pancreas(task.name);
    X=X';
    Y=Y+1;
    [task.D, task.n] = size(X);
    task.ntrain = task.n-2;
    task.ntest = 2;
elseif strfind(task.name,'amen')
    [X,Y] = load_amen(task.name);    
    if size(X,2)~=length(Y), X=X'; end
    Y=Y+1;
    [task.D, task.n] = size(X);
    task.ntrain=round(task.n*.9);
    task.ntest=task.n-task.ntrain;
elseif strncmpi(task.name,'MNIST(',6)
    X =loadMNISTImages('~/Research/working/A/LOL/Data/Raw/MNIST/t10k-images.idx3-ubyte');
    Y =loadMNISTLabels('~/Research/working/A/LOL/Data/Raw/MNIST/t10k-labels.idx1-ubyte');
    lenName=length(task.name);
    label_keepers=[];
    for j=7:lenName-1
        label_keepers=[label_keepers, str2num(task.name(j))];
    end
    Yind=[];
    for j=1:length(label_keepers)
        Yind=[Yind; find(Y==label_keepers(j))];
    end
    X = X(:,Yind);
    Y = Y(Yind);
    task.classIDs=label_keepers;
elseif strcmpi(task.name,'MNIST')
    X =     loadMNISTImages('~/Research/working/A/LOL/Data/Raw/MNIST/t10k-images.idx3-ubyte');
    Y =     loadMNISTLabels('~/Research/working/A/LOL/Data/Raw/MNIST/t10k-labels.idx1-ubyte');
% elseif strcmpi(task.name,'MNIST(378)')
%     X =loadMNISTImages('~/Research/working/A/LOL/Data/Raw/MNIST/t10k-images.idx3-ubyte');
%     Y =loadMNISTLabels('~/Research/working/A/LOL/Data/Raw/MNIST/t10k-labels.idx1-ubyte');
%     Yind=[find(Y==3);find(Y==7);find(Y==8)];
%     X = X(:,Yind);
%     Y = Y(Yind);
elseif strcmp(task.name,'CIFAR-10')
    load('~/Research/working/A/LOL/Data/Raw/CIFAR-10/data_batch_1.mat')
    X=double(data);
    Y=labels;
end
Y=double(Y);


%%

%     case 'amen READINGS depression'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.READINGS';
%         Y=data.Depressed;
%         [task.D, task.n] = size(X);
%     case 'amen READINGS adhd'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.READINGS';
%         Y=data.ADHD;
%         [task.D, task.n] = size(X);
%     case 'amen READINGS gender'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.READINGS';
%         Y=data.Gender;
%         Y(Y==2)=0;
%         [task.D, task.n] = size(X);
%     case 'amen READINGS anxiety'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.READINGS';
%         Y=data.AnxietyDisorder;
%         [task.D, task.n] = size(X);
%     case 'amen READINGS dementia'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.READINGS';
%         Y=data.Dementia;
%         [task.D, task.n] = size(X);
%     case 'amen READINGS age group'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.READINGS';
%         Y=data.Age_Group;
%         [task.D, task.n] = size(X);
%     case 'amen READINGS bipolar'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.READINGS';
%         Y=data.Bipolar;
%         [task.D, task.n] = size(X);
%     case 'amen READINGS adjustment'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.READINGS';
%         Y=data.Adjustment_Disorder;
%         [task.D, task.n] = size(X);
%     case 'amen READINGS mood'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.READINGS';
%         Y=data.Mood_Disorder;
%         [task.D, task.n] = size(X);
%
%     case 'amen COGNITIVE depression'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.COGNITIVE';
%         Y=data.Depressed;
%         [task.D, task.n] = size(X);
%     case 'amen COGNITIVE adhd'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.COGNITIVE';
%         Y=data.ADHD;
%         [task.D, task.n] = size(X);
%     case 'amen COGNITIVE gender'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.COGNITIVE';
%         Y=data.Gender;
%         Y(Y==2)=0;
%         [task.D, task.n] = size(X);
%     case 'amen COGNITIVE anxiety'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.COGNITIVE';
%         Y=data.AnxietyDisorder;
%         [task.D, task.n] = size(X);
%     case 'amen COGNITIVE dementia'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.COGNITIVE';
%         Y=data.Dementia;
%         [task.D, task.n] = size(X);
%     case 'amen COGNITIVE age group'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.COGNITIVE';
%         Y=data.Age_Group;
%         [task.D, task.n] = size(X);
%     case 'amen COGNITIVE bipolar'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.COGNITIVE';
%         Y=data.Bipolar;
%         [task.D, task.n] = size(X);
%     case 'amen COGNITIVE adjustment'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.COGNITIVE';
%         Y=data.Adjustment_Disorder;
%         [task.D, task.n] = size(X);
%     case 'amen COGNITIVE mood'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.COGNITIVE';
%         Y=data.Mood_Disorder;
%         [task.D, task.n] = size(X);
%
%     case 'amen SPECT depression'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.SPECT';
%         Y=data.Depressed;
%         [task.D, task.n] = size(X);
%     case 'amen SPECT adhd'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.SPECT';
%         Y=data.ADHD;
%         [task.D, task.n] = size(X);
%     case 'amen SPECT gender'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.SPECT';
%         Y=data.Gender;
%         Y(Y==2)=0;
%         [task.D, task.n] = size(X);
%     case 'amen SPECT anxiety'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.SPECT';
%         Y=data.AnxietyDisorder;
%         [task.D, task.n] = size(X);
%     case 'amen SPECT dementia'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.SPECT';
%         Y=data.Dementia;
%         [task.D, task.n] = size(X);
%     case 'amen SPECT age group'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.SPECT';
%         Y=data.Age_Group;
%         [task.D, task.n] = size(X);
%     case 'amen SPECT bipolar'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.SPECT';
%         Y=data.Bipolar;
%         [task.D, task.n] = size(X);
%     case 'amen SPECT adjustment'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.SPECT';
%         Y=data.Adjustment_Disorder;
%         [task.D, task.n] = size(X);
%     case 'amen SPECT mood'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.SPECT';
%         Y=data.Mood_Disorder;
%         [task.D, task.n] = size(X);
%
%     case 'amen X depression'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.X';
%         Y=data.Depressed;
%         [task.D, task.n] = size(X);
%     case 'amen X adhd'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.X';
%         Y=data.ADHD;
%         [task.D, task.n] = size(X);
%     case 'amen X gender'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.X';
%         Y=data.Gender;
%         Y(Y==2)=0;
%         [task.D, task.n] = size(X);
%     case 'amen X anxiety'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.X';
%         Y=data.AnxietyDisorder;
%         [task.D, task.n] = size(X);
%     case 'amen X dementia'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.X';
%         Y=data.Dementia;
%         [task.D, task.n] = size(X);
%     case 'amen X age group'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.X';
%         Y=data.Age_Group;
%         [task.D, task.n] = size(X);
%     case 'amen X bipolar'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.X';
%         Y=data.Bipolar;
%         [task.D, task.n] = size(X);
%     case 'amen X adjustment'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.X';
%         Y=data.Adjustment_Disorder;
%         [task.D, task.n] = size(X);
%     case 'amen X mood'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.X';
%         Y=data.Mood_Disorder;
%         [task.D, task.n] = size(X);
%
%     case 'amen ACTIVATION depression'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.ACTIVATION';
%         Y=data.Depressed;
%         [task.D, task.n] = size(X);
%     case 'amen ACTIVATION adhd'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.ACTIVATION';
%         Y=data.ADHD;
%         [task.D, task.n] = size(X);
%     case 'amen ACTIVATION gender'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.ACTIVATION';
%         Y=data.Gender;
%         Y(Y==2)=0;
%         [task.D, task.n] = size(X);
%     case 'amen ACTIVATION anxiety'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.ACTIVATION';
%         Y=data.AnxietyDisorder;
%         [task.D, task.n] = size(X);
%     case 'amen ACTIVATION dementia'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.ACTIVATION';
%         Y=data.Dementia;
%         [task.D, task.n] = size(X);
%     case 'amen BASELINE dementia'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.BASELINE';
%         Y=data.Dementia;
%         [task.D, task.n] = size(X);
%     case 'amen BASELINE depression'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.BASELINE';
%         Y=data.Depressed;
%         [task.D, task.n] = size(X);
%     case 'amen CONCENTRATION dementia'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.CONCENTRATION';
%         Y=data.Dementia;
%         [task.D, task.n] = size(X);
%     case 'amen ACTIVATION age group'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.ACTIVATION';
%         Y=data.Age_Group;
%         [task.D, task.n] = size(X);
%     case 'amen ACTIVATION bipolar'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.ACTIVATION';
%         Y=data.Bipolar;
%         [task.D, task.n] = size(X);
%     case 'amen ACTIVATION adjustment'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.ACTIVATION';
%         Y=data.Adjustment_Disorder;
%         [task.D, task.n] = size(X);
%     case 'amen ACTIVATION mood'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.ACTIVATION';
%         Y=data.Mood_Disorder;
%         [task.D, task.n] = size(X);
%     case 'amen BASELINE gender'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.BASELINE';
%         Y=data.Gender;
%         Y(Y==2)=0;
%         [task.D, task.n] = size(X);
%     case 'amen CONCENTRATION gender'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.CONCENTRATION';
%         Y=data.Gender;
%         Y(Y==2)=0;
%         [task.D, task.n] = size(X);
%     case 'amen CONCENTRATION depression'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.CONCENTRATION';
%         Y=data.Depressed;
%         Y(Y==2)=0;
%         [task.D, task.n] = size(X);
%     case 'amen CR dementia'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.CR';
%         Y=data.Dementia;
%         [task.D, task.n] = size(X);
%     case 'amen CR gender'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.CR';
%         Y=data.Gender;
%         Y(Y==2)=0;
%         [task.D, task.n] = size(X);
%     case 'amen CR depression'
%         data=load('../../Data/Preprocessed/amen');
%         X=data.CR';
%         Y=data.Depressed;
%         [task.D, task.n] = size(X);