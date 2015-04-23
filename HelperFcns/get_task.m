function [task,X,Y,P] = get_task(task_in)
% this function generates everything necessarty to analyze a specific task
%
% INPUT: task_name: a string, naming the task
% OUTPUT:
%   task: a structure containing meta-data for the task
%   X:      a matrix of predictors
%   Y:      a vector of predictees
%   P:      a structure of parameters

task = set_task(task_in);
P = []; if ~isfield(task,'D'), task.D=[]; end
if task.simulation
    
    % the 'otherwise' case is any gaussian mixture model, 
    % the other cases are NOT that, for one reason or another
    switch task.name
        case 'regress'
            [X,Y] = sample_regress(task);
        case  'DRL'
            [X,Y] = sample_DRL(a);
        case strcmp(task.name,'xor')
            [X,Y] = sample_xor(task);
        case 'gms'
                        
            Ninlier=task.n/2; 
            n0=Ninlier/2;
            n1=n0;
            Noutlier=task.n-Ninlier;
            task.D=200;
            d=round(task.D/10);
            noise=0.1;
            offset=0.5;
            V=orth(rand(task.D,d));
            X0=randn(n0,d)*V';
            X1=randn(n1,d)*V'+offset;
            X=[X0;X1; randn(Noutlier,task.D)];
            X=X+randn(size(X))*noise;

            P.mu(:,1)=mean(X0);
            P.mu(:,2)=mean(X1);
            P.Sigma=V*V';
            P.w=1/2*[1,1];
            
            Y=[zeros(n0,1); ones(n1,1); rand(Noutlier,1)>0.5]+1;
            
            task.QDA_model=0;
            P.del=diff(P.mu')';

        case ['fat tails, D=', num2str(task.D)]
            
            s0=10;
            mu0=zeros(task.D,1);
            mu1=[ones(s0,1); zeros(task.D-s0,1)];
            
            rho=0.2;
            A=rho*ones(task.D);
            A(1:task.D+1:end)=1;
            
            if task.rotate==true;
                [Q, ~] = qr(randn(task.D));
                if det(Q)<-.99
                    Q(:,1)=-Q(:,1);
                end
            else
                Q=eye(task.D);
            end
            
            P.Sigma=Q*A*Q';
            mu0=Q*mu0;
            mu1=Q*mu1;
            
            P.mu=[mu0, mu1];
            P.w=1/2*ones(2,1);
            gmm = gmdistribution(P.mu',P.Sigma,P.w);
            [X0,Y0] = random(gmm,task.n*0.8);
            
            gmm = gmdistribution(P.mu',P.Sigma*15,P.w);
            [X1,Y1] = random(gmm,task.n*0.2);
            
            X=[X0;X1];
            Y=[Y0;Y1];
            
            P.del=diff(P.mu')';
            P.diag=diag(P.Sigma);
            
        case ['xor, D=', num2str(task.D)]

            
            mu0=zeros(task.D,1);
            mu1=repmat([1;0],task.D/2,1);
            Sigma=sqrt(task.D/4)*eye(task.D);
            
            gmm = gmdistribution([mu0,mu1]',Sigma,[0.5,0.5]);
            [X0,Y0] = random(gmm,task.n*0.5);

            P.Sigma=Sigma;
            P.w=1/2*[1,1];
            P.mu=[mu0,mu1];

            mu0=ones(task.D,1);
            mu1=repmat([0;1],task.D/2,1);
            gmm = gmdistribution([mu0,mu1]',Sigma,[0.5,0.5]);
            [X1,Y1] = random(gmm,task.n*0.5);
            
            X=[X0;X1];
            Y=[Y0;Y1];

            P.mu=[P.mu, mu0,mu1];
            P.diag=diag(P.Sigma);

            
        otherwise % simulation each class is a gaussian
            P = set_parameters(task);
            gmm = gmdistribution(P.mu',P.Sigma,P.w);
            [X,Y] = random(gmm,task.n);
    end
else
    [X,Y,task] = load_data(task);
end

[D, n]=size(X);

if D==length(Y)
    X=X';
    task.D = n;
    task.n = D;
else
    task.D = D;
    task.n = n;
end

k_max=min(task.ntrain,min(task.D,task.Kmax));
task.ks=task.ks(task.ks<=k_max);
task.Nks=length(task.ks);
task.Kmax=max(task.ks);

[~, ~,types] = parse_algs(task.types);
task.types=types;