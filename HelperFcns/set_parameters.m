function P = set_parameters(task)
% set the parameters for the simulation named in 'task' (a string)
% there are a whole bunch of simulation settings provided in here, all of
% them correspond to QDA models, that is, two classes, each with a mean and
% covariance.
%
% INPUT: task (struct): task settings
% OUTPUT:  P (struct):  parameters

if ~isfield(task,'permute'), task.permute=false; end % whether or not to permute the coordinates, this is really for debugging purposes
if ~isfield(task,'rotate'), task.rotate=false; end % ambient # of dimensions
if ~isfield(task,'D'), D=100; else D=task.D; end % ambient # of dimensions

if ~isfield(task,'P')    
    switch task.name
        
        case 'b' % for debuggin purposes
            
            D=100;
            m=0.1;
            mu1 = m*ones(D,1);
            mu0 = -mu1*0;
            Sigma = eye(D);
            
        case 'w' % wide
            
            mudelt = 8/sqrt(D);                                 % distance betwen dim 1 of means
            mu1 = [-mudelt/2; zeros(D-1,1)];                   % class 1 mean
            mu0 = [mudelt/2; zeros(D-1,1)];                     % class 2 mean
            
            sv = ones(D,1)/sqrt(D);
            sv(2)=1;
            A  = eye(D,D);
            Sigma=A*diag(sv);                            % class 1 cov
            
        case 'w1' % wide
            
            mudelt = 6/sqrt(100);                                 % distance betwen dim 1 of means
            mu1 = [-mudelt/2; zeros(D-1,1)];                   % class 1 mean
            mu0 = [mudelt/2; zeros(D-1,1)];                     % class 2 mean
            
            sd = 1;
            sv = sd/sqrt(100)*ones(D,1);
            if D>1, sv(2)=1; end
            A  = eye(D,D);
            Sigma=A*diag(sv);                            % class 1 cov
            
        case 'w2' % wide
            
            mudelt = 8/sqrt(D);                                 % distance betwen dim 1 of means
            mu1 = [-mudelt/2; zeros(D-1,1)];                   % class 1 mean
            mu0 = [mudelt/2; zeros(D-1,1)];                     % class 2 mean
            
            sd = 1;
            sv = sd/sqrt(D)*ones(D,1);
            sv(2)=1;
            A  = eye(D,D);
            
            Sigma=A*diag(sv);                            % class 2 cov
            Sigma(1,1) = 0.5;
            Sigma(1,2)=0.25;
            Sigma(2,1)=0.25;
            
            
        case 'w3' % wide
            
            D = 3;
            mudelt = 6/sqrt(100);                                 % distance betwen dim 1 of means
            mu1 = [-mudelt/2; zeros(D-1,1)];                   % class 1 mean
            mu0 = [mudelt/2; zeros(D-1,1)];                     % class 2 mean
            
            sd = 1;
            sv = sd/sqrt(100)*ones(D,1);
            sv(2)=1;
            A  = eye(D,D);
            Sigma=A*diag(sv);                            % class cov
            
        case 's' % simple
            
            mudelt = 6/sqrt(D);                                 % distance betwen dim 1 of means
            mu1 = [-mudelt/2; zeros(D-1,1)];                   % class 1 mean
            mu0 = [mudelt/2; zeros(D-1,1)];                     % class 2 mean
            
            sv = ones(D,1)/sqrt(D);
            sv(2)=1;
            A  = eye(D,D);
            Sigma=A*diag(sv);                            % class 1 cov
            
        case 'parallel cigars' % simple
            
            mudelt = 6/sqrt(D);                                 % distance betwen dim 1 of means
            mu1 = [-mudelt/2; zeros(D-1,1)];                   % class 1 mean
            mu0 = [mudelt/2; zeros(D-1,1)];                     % class 2 mean
            
            sv = ones(D,1)/sqrt(D);
            sv(2)=0.5;
            
            Sigma  = eye(D,D)*diag(sv);
            
        case 'angled cigars' % simple
            
            mudelt = 6/sqrt(D);                                 % distance betwen dim 1 of means
            mu1 = [-mudelt/2; zeros(D-1,1)];                   % class 1 mean
            mu0 = [mudelt/2; zeros(D-1,1)];                     % class 2 mean
            
            sv = ones(D,1)/sqrt(D);
            sv(2)=0.5;
            
            Sigma  = eye(D,D)*diag(sv);
            
            [Q, ~] = qr(randn(D));
            if det(Q)<-.99
                Q(:,1)=-Q(:,1);
            end
            
            Sigma(:,:,2)=Q*Sigma*Q';
            
        case 'rotated cigars' % simple angle
            
            R = eye(D);
            theta=pi/4;
            R(1,1)=cos(theta);
            R(2,2)=cos(theta);
            R(1,2)=sin(theta);
            R(2,1)=-R(1,2);
            
            mudelt = 6/sqrt(D);                                 % distance betwen dim 1 of means
            mu1 = [-mudelt/2; zeros(D-1,1)];                   % class 1 mean
            mu0 = [mudelt/2; zeros(D-1,1)];                     % class 2 mean
            
            mu1 = R*mu1;
            mu0 = R*mu0;
            
            sv = ones(D,1)/sqrt(D);
            sv(2)=0.5;
            
            A  = eye(D,D)*diag(sv);
            Sigma = R*A*R';
            
            
        case 'sa' % simple angle
            
            mudelt = 2.5;                                 % distance betwen dim 1 of means
            mu1 = [-mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            mu0 = [mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            mu1(2)=mu1(2)/3;
            mu0(2)=mu0(2)/3;
            
            sv = ones(D,1)/sqrt(D);
            sv(2)=4;
            A  = eye(D,D); %A(1:2,1:2)=[1,2;0,1];       % singular vectors
            Sigma=A*diag(sv);                            % class 2 cov
            
            Sigma(1,2) = sv(2)/2;
            Sigma(2,1) = sv(2)/2;
            
            Sigma=Sigma+eye(D);
            
        case 'sa2' % simple angle
            
            mudelt = 3.5;                                 % distance betwen dim 1 of means
            mu1 = [-mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            mu0 = [mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            mu1(2)=mu1(2)/3;
            mu0(2)=mu0(2)/3;
            
            sd = 1;
            sv = sd/sqrt(D)*ones(D,1);
            sv(2)=4;
            A  = eye(D,D); %A(1:2,1:2)=[1,2;0,1];       % singular vectors
            Sigma=A*diag(sv);                            % class 1 cov
            
            Sigma(1,2) = sv(2)/2;
            Sigma(2,1) = sv(2)/2;
            Sigma=Sigma+eye(D);
            
        case 'wa' % wide angle
            
            sd = 1;
            k = 1;                                      % # of latent dimensions with relatively high variance
            mudelt = 3;                                 % distance betwen dim 1 of means
            sv = sd/sqrt(D)*ones(D,1);
            sv(2)=2;
            A  = eye(D,D); %A(1:2,1:2)=[1,2;0,1];       % singular vectors
            mu1 = [-mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            mu0 = [mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            
            Sigma=A*diag(sv);                            % class 1 cov
            Sigma(1,2) = sv(2)/2;
            Sigma(2,1) = sv(2)/2;
            Sigma=Sigma+eye(D);
            
        case 'r' % rotated
            
            sd = 1;
            k = 1;                                      % # of latent dimensions with relatively high variance
            mudelt = 1;                                 % distance betwen dim 1 of means
            sv = sd/sqrt(D)*ones(D,1);
            
            A  = eye(D,D); %A(1:2,1:2)=[1,2;0,1];       % singular vectors
            mu1 = [-mudelt/2; zeros(D-1,1)];                   % class 1 mean
            mu0 = [mudelt/2; zeros(D-1,1)];                     % class 2 mean
            
            Sigma=nan(D,D,2);
            
            sv0=sv;
            sv0(1)=1;
            Sigma(:,:,1)=A*diag(sv0);                            % class 2 cov
            
            sv1=sv;
            sv1(2)=1;
            Sigma(:,:,2)=A*diag(sv1);                            % class 1 cov
            
        case 'wra' % wide angle
            
            sd = 1;
            k = 5;                                      % # of latent dimensions with relatively high variance
            mudelt = 8/sqrt(D);                                 % distance betwen dim 1 of means
            sv = 1*sd/sqrt(D)*ones(D,1);
            sv(2)=2;
            A  = eye(D,D); %A(1:2,1:2)=[1,2;0,1];       % singular vectors
            mu1 = [-mudelt/2*ones(k,1); zeros(D-k,1)];                   % class 1 mean
            mu0 = [mudelt/2*ones(k,1); zeros(D-k,1)];                   % class 1 mean
            
            mu1(1)=mu1(1)*2;
            mu0(1)=mu0(1)*2;
            
            mu1(2)=mu1(2)/3;
            mu0(2)=mu0(2)/3;
            
            Sigma=nan(D,D,2);
            
            Sigma(:,:,2)=A*diag(sv);                            % class 1 cov
            Sigma(:,:,1)=A*diag(sv);                            % class 2 cov
            
            Sigma(1,2,2) = sv(2)/2;
            Sigma(2,1,2) = sv(2)/2;
            
            Sigma(1,2,1) = -sv(2)/2;
            Sigma(2,1,1) = -sv(2)/2;
            
            Sigma(:,:,2)=Sigma(:,:,2)+eye(D);
            Sigma(:,:,1)=Sigma(:,:,1)+eye(D);
            
        case 'wra2' % wide angle
            
            sd = 1;
            k = 2;                                      % # of latent dimensions with relatively high variance
            mudelt = 16/sqrt(D);                                 % distance betwen dim 1 of means
            sv = 3*sd/sqrt(D)*ones(D,1);
            sv(2)=2;
            A  = eye(D,D); %A(1:2,1:2)=[1,2;0,1];       % singular vectors
            mu1 = [-mudelt/2*ones(k,1); zeros(D-k,1)];                   % class 1 mean
            mu0 = [mudelt/2*ones(k,1); zeros(D-k,1)];                   % class 1 mean
            
            mu1(1)=mu1(1)*2;
            mu0(1)=mu0(1)*2;
            
            mu1(2)=mu1(2)/3;
            mu0(2)=mu0(2)/3;
            
            Sigma(:,:,2)=A*diag(sv);                            % class 1 cov
            Sigma(:,:,1)=A*diag(sv);                            % class 2 cov
            
            Sigma(1,2,2) = sv(2)/2;
            Sigma(1,1,2) = sv(2)/2;
            
            Sigma(1,2,1) = -sv(2)/2;
            Sigma(2,1,1) = -sv(2)/2;
            
            Sigma(:,:,2)=Sigma(:,:,2)+eye(D);
            Sigma(:,:,1)=Sigma(:,:,1)+eye(D);
            
        case 'weird'
            
            sd = 1;
            sv = [0.05*sd/sqrt(D)*ones(D,1)];
            A  = eye(D,D); %A(1:2,1:2)=[1,2;0,1];
            mu1 = zeros(D,1);
            mu0 = mu1;                     % PCA good, lda ok.
            mu0(10:20)=1;
            
            Sigma=A*diag(sv);                            % class 1 cov
            
        case 'trunk'
            
            mu1=1./sqrt(1:D)';
            mu0=-mu1;
            Sigma = sqrt(D)*0.5*eye(D);
            
        case 'trunk2'
            
            mu1=2./sqrt(D:-1:1)';
            mu0=-mu1;
            
            Sigma=eye(D);
            Sigma(1:D+1:end)=100./sqrt(1:D);
            
        case ['trunk3, D=', num2str(D)]
            
            mu1=2./sqrt(D:-1:1)';
            mu0=-mu1;
            
            Sigma=eye(D);
            Sigma(1:D+1:end)=100./sqrt(1:D);
            
            
        case ['atrunk3, D=', num2str(D)]
            
            mu1=2./sqrt(D:-1:1)';
            mu0=-mu1;
            
            Sigma=eye(D);
            Sigma(1:D+1:end)=100./sqrt(1:D);
            
            [Q, ~] = qr(randn(task.D));
            if det(Q)<-.99
                Q(:,1)=-Q(:,1);
            end
            
            Sigma=Q*Sigma*Q';
            mu0=Q*mu0;
            mu1=Q*mu1;
            
        case ['trunk4']
            
            int=2;
            mu1=2./sqrt(1:int:int*D)';
            mu0=-mu1;
            
            Sigma=eye(D);
            Sigma(1:D+1:end)=100./sqrt(D:-1:1);
            
        case ['trunk4, D=', num2str(D)]
            
            int=2;
            mu1=4./sqrt(1:int:int*D)';
            mu0=-mu1;
            
            Sigma=eye(D);
            Sigma(1:D+1:end)=100./sqrt(D:-1:1);
            
            
        case ['atrunk4, D=', num2str(D)]
            
            mu1=2./sqrt(1:D)';
            mu0=-mu1;
            
            Sigma=eye(D);
            Sigma(1:D+1:end)=100./sqrt(D:-1:1);
            
            [Q, ~] = qr(randn(task.D));
            if det(Q)<-.99
                Q(:,1)=-Q(:,1);
            end
            
            Sigma=Q*Sigma*Q';
            mu0=Q*mu0;
            mu1=Q*mu1;
            

        case ['toeplitz, D=', num2str(D)]
            
            delta1=0.4; D1=10;
            
            rho=0.5;
            c=rho.^(0:D1-1);
            A = toeplitz(c);
            K1=sum(A(:));
            
            c=rho.^(0:D-1);
            A = toeplitz(c);
            K=sum(A(:));
            
            mudelt=(K1*delta1^2/K)^0.5/2;
            mu0 = ones(D,1);
            mu0(2:2:end)=-1;
            mu0=mudelt*mu0;
            mu1=-mu0;
            
            Sigma=A;
            
        case ['rtoeplitz, D=', num2str(D)]
            
            delta1=0.4; D1=10;
            
            rho=0.5;
            c=rho.^(0:D1-1);
            A = toeplitz(c);
            K1=sum(A(:));
            
            c=rho.^(0:D-1);
            A = toeplitz(c);
            K=sum(A(:));
            Sigma=A;
            
            mudelt=(K1*delta1^2/K)^0.5/2;
            mu0 = ones(D,1);
            mu0(2:2:end)=-1;
            mu0=mudelt*mu0;
            
            
            [Q, ~] = qr(randn(task.D));
            if det(Q)<-.99
                Q(:,1)=-Q(:,1);
            end
            Sigma(:,:,2)=Q*Sigma*Q';
            mu1=-Q*mu0;
            
        case ['atoeplitz, D=', num2str(D)]
            
            delta1=0.4; D1=10;
            
            rho=0.5;
            c=rho.^(0:D1-1);
            A = toeplitz(c);
            K1=sum(A(:));
            
            c=rho.^(0:D-1);
            A = toeplitz(c);
            K=sum(A(:));
            
            mudelt=(K1*delta1^2/K)^0.5/2;
            mu0 = ones(D,1);
            mu0(2:2:end)=-1;
            mu0=mudelt*mu0;
            mu1=-mu0;
            
            
            [Q, ~] = qr(randn(task.D));
            if det(Q)<-.99
                Q(:,1)=-Q(:,1);
            end
            
            Sigma=Q*A*Q';
            mu0=Q*mu0;
            mu1=Q*mu1;
            
        case ['sparse toeplitz, D=', num2str(D)]        % toeplitz with sparse delta
            
            mudelt = 2.5;                                 % distance betwen dim 1 of means
            mu1 = [-mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            mu0 = [mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            mu1(2)=mu1(2)/3;
            mu0(2)=mu0(2)/3;
            
            rho=0.5;
            c=rho.^(0:D-1);
            A = toeplitz(c);
            
            Sigma=A;
            
            
        case 'decaying'
            
            A=eye(D);
            A(1:D+1:end)=100./sqrt(1:D);
            
            mu1=1*ones(D,1);
            mu0=-mu1;
            Sigma=A;
            
        case ['model0, D=', num2str(D)]
            
            mudelt = 0.5;                                 % distance betwen dim 1 of means
            mu0=mudelt*ones(D,1);
            mu1=-mudelt*ones(D,1);
            
            rho=0.5;
            A=rho*ones(D);
            A(1:D+1:end)=1;
            
            Sigma=A;
            
        case ['model1, D=', num2str(D)]
            
            s0=10;
            mu0=zeros(D,1);
            mu1=[ones(s0,1); zeros(D-s0,1)];
            
            rho=0.5;
            A=rho*ones(D);
            A(1:D+1:end)=1;
            
            Sigma=A;
            

        case ['semisup, D=', num2str(D)]
            
            mu0=0.5*ones(D,1);
            mu1=-mu0;
            
            rho=0.5;
            A=rho*ones(D);
            A(1:D+1:end)=1;
            
            Sigma=A;

        case ['amodel1, D=', num2str(D)]
            
            s0=10;
            mu0=zeros(D,1);
            mu1=[ones(s0,1); zeros(D-s0,1)];
            
            rho=0.5;
            A=rho*ones(D);
            A(1:D+1:end)=1;
            
            [Q, ~] = qr(randn(task.D));
            if det(Q)<-.99
                Q(:,1)=-Q(:,1);
            end
            
            Sigma=Q*A*Q';
            mu0=Q*mu0;
            mu1=Q*mu1;
            
            
        case ['ROAD1, D=', num2str(D)]
            
            s0=10;
            mu0=zeros(D,1);
            mu1=[ones(s0,1); zeros(D-s0,1)];
            
            rho=0.2;
            A=rho*ones(D);
            A(1:D+1:end)=1;
            Sigma=A;
            
            
        case ['aROAD1, D=', num2str(D)]
            
            s0=10;
            mu0=zeros(D,1);
            mu1=[ones(s0,1); zeros(D-s0,1)];
            
            rho=0.2;
            A=rho*ones(D);
            A(1:D+1:end)=1;
            
            [Q, ~] = qr(randn(task.D));
            if det(Q)<-.99
                Q(:,1)=-Q(:,1);
            end
            
            
            Sigma=Q*A*Q';
            mu0=Q*mu0;
            mu1=Q*mu1;
            
            
        case ['model3, D=', num2str(D)]
            
            s0=10;
            mu0=zeros(D,1);
            mu1=[ones(s0,1); zeros(D-s0,1)];
            
            
            rho=0.8;
            c=rho.^(0:D-1);
            Sigma = toeplitz(c);
            
            
        case '1'
            ntrain=100;
            D=400;
            rho=0.5;
            c=rho.^(0:D-1);
            Sigma = toeplitz(c);
            
            mu1=zeros(D,1);
            beta=0.556*[3;1.5;0;0;2;zeros(D-5,1)];
            mu0=Sigma*beta;
            
        case '2'
            ntrain=100;
            D=400;
            rho=0.5;
            c=rho.^(0:D-1);
            A = toeplitz(c);
            
            mu1=zeros(D,1);
            beta=0.582*[3;2.5;-2.8;zeros(D-3,1)];
            mu0=A*beta;
            Sigma=A;
            
        case '3'
            ntrain=400;
            D=800;
            rho=0.5;
            A=0.5*eye(D)+0.5*ones(D);
            mu1=zeros(D,1);
            beta=0.395*[3;1.7;-2.2;-2.1;2.55;zeros(D-5,1)];
            mu0=A*beta;
            Sigma=A;
            
        case '4'
            ntrain=300;
            D=800;
            p=D/5;
            A0=0.4*eye(p)+0.6*ones(p);
            A1=eye(5);
            A=kron(A1,A0);
            beta=0.916*[1.2;-1.4;1.15;-1.64;1.5;-1;2;zeros(D-7,1)];
            mu1=zeros(D,1);
            mu0=A*beta;
            Sigma=A;
            
        case '5'
            ntrain=400;
            D=800;
            A=0.5*eye(D)+0.5*ones(D);
            beta=0.551*[3;1.7;-2.2;-2.1;2.55;(D-5)^(-1)*ones(D-5,1)];
            mu1=zeros(D,1);
            mu0=A*beta;
            Sigma=A;
            
        case '6'
            ntrain=400;
            D=800;
            A=0.5*eye(D)+0.5*ones(D);
            mu1=zeros(D,1);
            beta=0.362*[3;1.7;-2.2;-2.1;2.55;(D-5)^(-1)*ones(D-5,1)];
            mu0=A*beta;
            Sigma=A;
            
        case 'debug'
            
            D=5;
            rng('default')
            mu0=0.5*rand(D,1);
            mu1=-0.5*rand(D,1);
            
            Sigma=eye(D);
            Sigma=Sigma+0.5*ones(D);
            Sigma(1:D+1:end)=ones(D,1);
            
        case 'simple'
            
            D=5;
            mu0=0.5*ones(D,1);
            mu1=-mu0;
            
            rho=0.5;
            Sigma=rho*ones(D);
            Sigma(1:D+1:end)=1;
            
        otherwise
            error('no known parameter setting provided')
    end
    P.name=task.name;
else
    P=task.P;
end

% this took too long, so i stopped checking 
% for k=1:K % check if covariance matrices are valid covariance matrices
%     [~,p]=chol(Sigma(:,:,k));
%     if p>0
%         error('some Sigma is not positive definite')
%     end
%     if norm(Sigma(:,:,k)-Sigma(:,:,k)')>10^-4
%         error('some Sigma is not symmetric')
%     end
% end


if task.permute
    perm=randperm(D);
    Q=eye(D);
    Q=Q(perm,:);
    mu1=Q*mu1;
    mu0=Q*mu0;
    siz=size(Sigma);
    if length(siz)==3
        Sigma(:,:,1)=Q*Sigma(:,:,1)*Q';
        Sigma(:,:,2)=Q*Sigma(:,:,2)*Q';
    else
        Sigma=Q*Sigma*Q';
    end
    P.perm=perm;
end

% mubar=(mu1+mu0)/2;
% mu1=mu1-mubar;
% mu0=mu0-mubar;

P.del=mu1-mu0;
% compute risk analytically when covariances are equal
if size(Sigma,3)==1
    P.Risk=1-normcdf(0.5*sqrt(P.del'*(Sigma\P.del)));
end

P.D=D;
P.mu=[mu0 mu1];
P.Sigma=Sigma;
P.w=1/2*[1; 1];
P.Ngroups=2;
P.groups=[1 2];

if task.rotate
    
    % generate rotation matrix uniformly
    [Q, ~] = qr(randn(task.D));
    if det(Q)<-.99
        Q(:,1)=-Q(:,1);
    end
    
    % rotate means & covariances
    nclasses=size(P.mu,2);
    for i=1:nclasses
        P.mu(:,i)=Q*P.mu(:,i);
        if size(P.Sigma,3)>1
            P.Sigma(:,:,i)=Q*P.Sigma(:,:,i)*Q';
        end
    end
    if size(P.Sigma,3)==1
       P.Sigma=Q*P.Sigma*Q'; 
    end
    
end
