function [X,Y] = choose_pancreas(X,labels,which)

n=length(labels);

switch which
    case 'IPMNvsAll'
        Y=labels(1,:)';
    case 'IPMN-HvsAll'
        Y=labels(2,:)';
    case 'IPMN-MvsAll'
        Y=labels(3,:)';
    case 'IPMN-LvsAll'
        Y=labels(4,:)';
    case 'MCNvsAll'
        Y=labels(5,:)';
    case 'SCAvsAll'
        Y=labels(8,:)';
    case 'IPMN-HvL'
        XH=labels(2,:);
        XL=labels(4,:);
        Y=nan(n,1);
        Y(XL>0.1)=1;
        Y(XH>0.1)=0;
    case 'IPMN-HvML'
        XH=labels(2,:);
        XM=labels(3,:);
        XL=labels(4,:);
        Y=nan(n,1);
        Y(XM+XL>0.1)=1;
        Y(XH>0.1)=0;
    case 'IPMN-HMvL'
        XH=labels(2,:);
        XM=labels(3,:);
        XL=labels(4,:);
        Y=nan(n,1);
        Y(XL>0.1)=1;
        Y(XH+XM>0.1)=0;
    case 'fucked'
        get_labels
        Y=Y;
        Y(Y<3)=1;
        Y(Y==3)=0;
        Y=Y';
    case 'fucked2'
        get_labels
        Y=Y;
        Y(Y<3)=1;
        Y(Y==3)=0;
        Y=Y';
        Y=~Y;
end

idx=find(~isnan(Y));
Y=Y(idx);
X=X(idx,:);