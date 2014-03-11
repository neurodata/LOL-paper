function [X,Y,task] = load_data(task)


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
    case {'IPMNvsAll','IPMN-HvsAll','IPMN-MvsAll','IPMN-LvsAll','MCNvsAll','SCAvsAll','IPMN-HvL','IPMN-HvML','IPMN-HMvL'}
        [X,Y] = load_pancreas(task.name);
        X=X';
        [task.D, task.n] = size(X);
        task.ntrain = task.n-2;
        task.ntest = 2;
        
    case 'amen READINGS depression'
        data=load('../../data/base/amen');
        X=data.READINGS';
        Y=data.Depressed;
        [task.D, task.n] = size(X);
    case 'amen READINGS adhd'
        data=load('../../data/base/amen');
        X=data.READINGS';
        Y=data.ADHD;
        [task.D, task.n] = size(X);
    case 'amen READINGS gender'
        data=load('../../data/base/amen');
        X=data.READINGS';
        Y=data.Gender;
        Y(Y==2)=0;
        [task.D, task.n] = size(X);
    case 'amen READINGS anxiety'
        data=load('../../data/base/amen');
        X=data.READINGS';
        Y=data.AnxietyDisorder;
        [task.D, task.n] = size(X);
    case 'amen READINGS dementia'
        data=load('../../data/base/amen');
        X=data.READINGS';
        Y=data.Dementia;
        [task.D, task.n] = size(X);
    case 'amen READINGS age group'
        data=load('../../data/base/amen');
        X=data.READINGS';
        Y=data.Age_Group;
        [task.D, task.n] = size(X);
    case 'amen READINGS bipolar'
        data=load('../../data/base/amen');
        X=data.READINGS';
        Y=data.Bipolar;
        [task.D, task.n] = size(X);
    case 'amen READINGS adjustment'
        data=load('../../data/base/amen');
        X=data.READINGS';
        Y=data.Adjustment_Disorder;
        [task.D, task.n] = size(X);
    case 'amen READINGS mood'
        data=load('../../data/base/amen');
        X=data.READINGS';
        Y=data.Mood_Disorder;
        [task.D, task.n] = size(X);
        
    case 'amen COGNITIVE depression'
        data=load('../../data/base/amen');
        X=data.COGNITIVE';
        Y=data.Depressed;
        [task.D, task.n] = size(X);
    case 'amen COGNITIVE adhd'
        data=load('../../data/base/amen');
        X=data.COGNITIVE';
        Y=data.ADHD;
        [task.D, task.n] = size(X);
    case 'amen COGNITIVE gender'
        data=load('../../data/base/amen');
        X=data.COGNITIVE';
        Y=data.Gender;
        Y(Y==2)=0;
        [task.D, task.n] = size(X);
    case 'amen COGNITIVE anxiety'
        data=load('../../data/base/amen');
        X=data.COGNITIVE';
        Y=data.AnxietyDisorder;
        [task.D, task.n] = size(X);
    case 'amen COGNITIVE dementia'
        data=load('../../data/base/amen');
        X=data.COGNITIVE';
        Y=data.Dementia;
        [task.D, task.n] = size(X);
    case 'amen COGNITIVE age group'
        data=load('../../data/base/amen');
        X=data.COGNITIVE';
        Y=data.Age_Group;
        [task.D, task.n] = size(X);
    case 'amen COGNITIVE bipolar'
        data=load('../../data/base/amen');
        X=data.COGNITIVE';
        Y=data.Bipolar;
        [task.D, task.n] = size(X);
    case 'amen COGNITIVE adjustment'
        data=load('../../data/base/amen');
        X=data.COGNITIVE';
        Y=data.Adjustment_Disorder;
        [task.D, task.n] = size(X);
    case 'amen COGNITIVE mood'
        data=load('../../data/base/amen');
        X=data.COGNITIVE';
        Y=data.Mood_Disorder;
        [task.D, task.n] = size(X);
        
    case 'amen SPECT depression'
        data=load('../../data/base/amen');
        X=data.SPECT';
        Y=data.Depressed;
        [task.D, task.n] = size(X);
    case 'amen SPECT adhd'
        data=load('../../data/base/amen');
        X=data.SPECT';
        Y=data.ADHD;
        [task.D, task.n] = size(X);
    case 'amen SPECT gender'
        data=load('../../data/base/amen');
        X=data.SPECT';
        Y=data.Gender;
        Y(Y==2)=0;
        [task.D, task.n] = size(X);
    case 'amen SPECT anxiety'
        data=load('../../data/base/amen');
        X=data.SPECT';
        Y=data.AnxietyDisorder;
        [task.D, task.n] = size(X);
    case 'amen SPECT dementia'
        data=load('../../data/base/amen');
        X=data.SPECT';
        Y=data.Dementia;
        [task.D, task.n] = size(X);
    case 'amen SPECT age group'
        data=load('../../data/base/amen');
        X=data.SPECT';
        Y=data.Age_Group;
        [task.D, task.n] = size(X);
    case 'amen SPECT bipolar'
        data=load('../../data/base/amen');
        X=data.SPECT';
        Y=data.Bipolar;
        [task.D, task.n] = size(X);
    case 'amen SPECT adjustment'
        data=load('../../data/base/amen');
        X=data.SPECT';
        Y=data.Adjustment_Disorder;
        [task.D, task.n] = size(X);
    case 'amen SPECT mood'
        data=load('../../data/base/amen');
        X=data.SPECT';
        Y=data.Mood_Disorder;
        [task.D, task.n] = size(X);
        
    case 'amen X depression'
        data=load('../../data/base/amen');
        X=data.X';
        Y=data.Depressed;
        [task.D, task.n] = size(X);
    case 'amen X adhd'
        data=load('../../data/base/amen');
        X=data.X';
        Y=data.ADHD;
        [task.D, task.n] = size(X);
    case 'amen X gender'
        data=load('../../data/base/amen');
        X=data.X';
        Y=data.Gender;
        Y(Y==2)=0;
        [task.D, task.n] = size(X);
    case 'amen X anxiety'
        data=load('../../data/base/amen');
        X=data.X';
        Y=data.AnxietyDisorder;
        [task.D, task.n] = size(X);
    case 'amen X dementia'
        data=load('../../data/base/amen');
        X=data.X';
        Y=data.Dementia;
        [task.D, task.n] = size(X);
    case 'amen X age group'
        data=load('../../data/base/amen');
        X=data.X';
        Y=data.Age_Group;
        [task.D, task.n] = size(X);
    case 'amen X bipolar'
        data=load('../../data/base/amen');
        X=data.X';
        Y=data.Bipolar;
        [task.D, task.n] = size(X);
    case 'amen X adjustment'
        data=load('../../data/base/amen');
        X=data.X';
        Y=data.Adjustment_Disorder;
        [task.D, task.n] = size(X);
    case 'amen X mood'
        data=load('../../data/base/amen');
        X=data.X';
        Y=data.Mood_Disorder;
        [task.D, task.n] = size(X);

    case 'amen ACTIVATION depression'
        data=load('../../data/base/amen');
        X=data.ACTIVATION';
        Y=data.Depressed;
        [task.D, task.n] = size(X);
    case 'amen ACTIVATION adhd'
        data=load('../../data/base/amen');
        X=data.ACTIVATION';
        Y=data.ADHD;
        [task.D, task.n] = size(X);
    case 'amen ACTIVATION gender'
        data=load('../../data/base/amen');
        X=data.ACTIVATION';
        Y=data.Gender;
        Y(Y==2)=0;
        [task.D, task.n] = size(X);
    case 'amen ACTIVATION anxiety'
        data=load('../../data/base/amen');
        X=data.ACTIVATION';
        Y=data.AnxietyDisorder;
        [task.D, task.n] = size(X);
    case 'amen ACTIVATION dementia'
        data=load('../../data/base/amen');
        X=data.ACTIVATION';
        Y=data.Dementia;
        [task.D, task.n] = size(X);
    case 'amen ACTIVATION age group'
        data=load('../../data/base/amen');
        X=data.ACTIVATION';
        Y=data.Age_Group;
        [task.D, task.n] = size(X);
    case 'amen ACTIVATION bipolar'
        data=load('../../data/base/amen');
        X=data.ACTIVATION';
        Y=data.Bipolar;
        [task.D, task.n] = size(X);
    case 'amen ACTIVATION adjustment'
        data=load('../../data/base/amen');
        X=data.ACTIVATION';
        Y=data.Adjustment_Disorder;
        [task.D, task.n] = size(X);
    case 'amen ACTIVATION mood'
        data=load('../../data/base/amen');
        X=data.ACTIVATION';
        Y=data.Mood_Disorder;
        [task.D, task.n] = size(X);
end
Y=double(Y);