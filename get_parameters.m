function P = get_parameters(sim)
% get the parameters for the simulation named in 'sim' (a string)
% there are a whole bunch of simulation settings provided in here, all of
% them correspond to QDA models, that is, two classes, each with a mean and
% covariance.
%
% INPUT: the name of of simulation
% OUTPUT:  P structure containing parameters


if ~isfield(sim,'sd'), sd=1; else sd=sim.sd; end
if ~isfield(sim,'permute'), sim.permute=0; end
if ~isfield(sim,'D'), D=100; else D=sim.D; end
if ~isfield(sim,'n'), n=550; else n=sim.n; end

if ~isfield(sim,'P')
    
    switch sim.name
        
        case 'a' % for debuggin purposes
            
            D=100;
            m=0.1;
            mu1 = m*ones(D,1);
            mu0 = -mu1*0;
            A = eye(D);
            Sig1 = A;
            Sig0 = A;
            
        case 'w' % wide
            
            mudelt = 6/sqrt(D);                                 % distance betwen dim 1 of means
            mu1 = [-mudelt/2; zeros(D-1,1)];                   % class 1 mean
            mu0 = [mudelt/2; zeros(D-1,1)];                     % class 2 mean
            
            sv = sd/sqrt(D)*ones(D,1);
            sv(2)=1;
            A  = eye(D,D);
            Sig1=A*diag(sv);                            % class 1 cov
            Sig0=A*diag(sv);                            % class 2 cov
            
        case 'w2' % wide
            
            D = 3;
            mudelt = 6/sqrt(100);                                 % distance betwen dim 1 of means
            mu1 = [-mudelt/2; zeros(D-1,1)];                   % class 1 mean
            mu0 = [mudelt/2; zeros(D-1,1)];                     % class 2 mean
            
            sv = sd/sqrt(100)*ones(D,1);
            sv(2)=1;
            A  = eye(D,D);
            Sig1=A*diag(sv);                            % class 1 cov
            Sig0=A*diag(sv);                            % class 2 cov

        case 's' % simple
            
            mudelt = 3/sqrt(D);                                 % distance betwen dim 1 of means
            mu1 = [-mudelt/2; zeros(D-1,1)];                   % class 1 mean
            mu0 = [mudelt/2; zeros(D-1,1)];                     % class 2 mean
            
            sv = sd/sqrt(D)*ones(D,1);
            sv(2)=1;
            A  = eye(D,D);
            Sig1=A*diag(sv);                            % class 1 cov
            Sig0=A*diag(sv);                            % class 2 cov
            
        case 'sa' % simple angle
            
            mudelt = 2.5;                                 % distance betwen dim 1 of means
            mu1 = [-mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            mu0 = [mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            mu1(2)=mu1(2)/3;
            mu0(2)=mu0(2)/3;
            
            sv = sd/sqrt(D)*ones(D,1);
            sv(2)=4;
            A  = eye(D,D); %A(1:2,1:2)=[1,2;0,1];       % singular vectors
            Sig1=A*diag(sv);                            % class 1 cov
            Sig0=A*diag(sv);                            % class 2 cov
            
            Sig1(1,2) = sv(2)/2;
            Sig1(2,1) = sv(2)/2;
            Sig0(1,2) = sv(2)/2;
            Sig0(2,1) = sv(2)/2;
            
            Sig1=Sig1+eye(D);
            Sig0=Sig0+eye(D);
            
        case 'sa2' % simple angle
            
            mudelt = 3.5;                                 % distance betwen dim 1 of means
            mu1 = [-mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            mu0 = [mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            mu1(2)=mu1(2)/3;
            mu0(2)=mu0(2)/3;
            
            sv = sd/sqrt(D)*ones(D,1);
            sv(2)=4;
            A  = eye(D,D); %A(1:2,1:2)=[1,2;0,1];       % singular vectors
            Sig1=A*diag(sv);                            % class 1 cov
            Sig0=A*diag(sv);                            % class 2 cov
            
            Sig1(1,2) = sv(2)/2;
            Sig1(2,1) = sv(2)/2;
            Sig0(1,2) = sv(2)/2;
            Sig0(2,1) = sv(2)/2;
            
            Sig1=Sig1+eye(D);
            Sig0=Sig0+eye(D);        case 'wa' % wide angle
            
            k = 1;                                      % # of latent dimensions with relatively high variance
            mudelt = 3;                                 % distance betwen dim 1 of means
            sv = sd/sqrt(D)*ones(D,1);
            sv(2)=2;
            A  = eye(D,D); %A(1:2,1:2)=[1,2;0,1];       % singular vectors
            mu1 = [-mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            mu0 = [mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            
            Sig1=A*diag(sv);                            % class 1 cov
            Sig0=A*diag(sv);                            % class 2 cov
            
            Sig1(1,2) = sv(2)/2;
            Sig1(2,1) = sv(2)/2;
            Sig0(1,2) = sv(2)/2;
            Sig0(2,1) = sv(2)/2;
            
            Sig1=Sig1+eye(D);
            Sig0=Sig0+eye(D);
            
        case 'r' % rotated
            
            k = 1;                                      % # of latent dimensions with relatively high variance
            mudelt = 1;                                 % distance betwen dim 1 of means
            sv = sd/sqrt(D)*ones(D,1);
            
            A  = eye(D,D); %A(1:2,1:2)=[1,2;0,1];       % singular vectors
            mu1 = [-mudelt/2; zeros(D-1,1)];                   % class 1 mean
            mu0 = [mudelt/2; zeros(D-1,1)];                     % class 2 mean
            
            sv1=sv;
            sv1(2)=1;
            Sig1=A*diag(sv1);                            % class 1 cov
            
            sv0=sv;
            sv0(1)=1;
            Sig0=A*diag(sv0);                            % class 2 cov
            
            
        case 'wra' % wide angle
            
            k = 1;                                      % # of latent dimensions with relatively high variance
            mudelt = 8/sqrt(D);                                 % distance betwen dim 1 of means
            sv = 3*sd/sqrt(D)*ones(D,1);
            sv(2)=2;
            A  = eye(D,D); %A(1:2,1:2)=[1,2;0,1];       % singular vectors
            mu1 = [-mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            mu0 = [mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            
            mu1(1)=mu1(1)*2;
            mu0(1)=mu0(1)*2;
            
            mu1(2)=mu1(2)/3;
            mu0(2)=mu0(2)/3;
            
            Sig1=A*diag(sv);                            % class 1 cov
            Sig0=A*diag(sv);                            % class 2 cov
            
            Sig1(1,2) = sv(2)/2;
            Sig1(2,1) = sv(2)/2;
            
            Sig0(1,2) = -sv(2)/2;
            Sig0(2,1) = -sv(2)/2;
            
            Sig1=Sig1+eye(D);
            Sig0=Sig0+eye(D);
        case 'wra2' % wide angle
            
            k = 1;                                      % # of latent dimensions with relatively high variance
            mudelt = 16/sqrt(D);                                 % distance betwen dim 1 of means
            sv = 3*sd/sqrt(D)*ones(D,1);
            sv(2)=2;
            A  = eye(D,D); %A(1:2,1:2)=[1,2;0,1];       % singular vectors
            mu1 = [-mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            mu0 = [mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            
            mu1(1)=mu1(1)*2;
            mu0(1)=mu0(1)*2;
            
            mu1(2)=mu1(2)/3;
            mu0(2)=mu0(2)/3;
            
            Sig1=A*diag(sv);                            % class 1 cov
            Sig0=A*diag(sv);                            % class 2 cov
            
            Sig1(1,2) = sv(2)/2;
            Sig1(2,1) = sv(2)/2;
            
            Sig0(1,2) = -sv(2)/2;
            Sig0(2,1) = -sv(2)/2;
            
            Sig1=Sig1+eye(D);
            Sig0=Sig0+eye(D);
        case 'pca'
            
            k = 2;
            sv = [ones(k,1);sd/sqrt(D)*ones(D-k,1)];
            A  = eye(D,D);
            A(1:2,1:2)=[1,2;0,1];
            mu1 = zeros(D,1);
            mu0 = [2;zeros(D-1,1)];                     % PCA good, lda ok.
            
            Sig1=A*diag(sv);                            % class 1 cov
            Sig0=A*diag(sv);                            % class 2 cov
            
        case 'lda'
            
            k = 2;
            sv = [ones(k,1);2*sd/sqrt(D)*ones(D-k,1)];
            A  = eye(D,D); A(1:2,1:2)=[1,2;2,1];
            mu1 = zeros(D,1);
            mu0 = 0.5*[zeros(k,1);1;zeros(D-k-1,1)];        % PCA screws up, lda kaboom!, SDA kaboon!
            
            Sig1=A*diag(sv);                            % class 1 cov
            Sig0=A*diag(sv);                            % class 2 cov
            
            Sig1=Sig1+eye(D);
            Sig0=Sig0+eye(D);
            
        case 'lda2'
            
            k = 2;
            sv = [ones(k,1);sd/sqrt(D)*ones(D-k,1)];
            A  = eye(D,D); %A(1:2,1:2)=[1,2;0,1];
            mu1 = zeros(D,1);
            mu0 = 0.5*[zeros(k,1);1;zeros(D-k-1,1)];        % PCA screws up, lda kaboom!, SDA kaboon!
            
            Sig1=A*diag(sv);                            % class 1 cov
            Sig0=A*diag(sv);                            % class 2 cov
            
            Sig1=Sig1+eye(D);
            Sig0=Sig0+eye(D);
            
        case 'weird'
            
            %         k = 2;
            sv = [0.05*sd/sqrt(D)*ones(D,1)];
            A  = eye(D,D); %A(1:2,1:2)=[1,2;0,1];
            mu1 = zeros(D,1);
            mu0 = mu1;                     % PCA good, lda ok.
            mu0(10:20)=1;
            
            Sig1=A*diag(sv);                            % class 1 cov
            Sig0=A*diag(sv);                            % class 2 cov
            
        case 'trunk'
            
            mu1=2./sqrt(1:D)';
            mu0=-mu1;
            A = sqrt(D)*0.5*eye(D);
            Sig1 = A;
            Sig0 = A;
            
        case 'trunk2'
            
            mu1=12./sqrt(D:-1:1)';
            mu0=-mu1;
            
            A=eye(D);
            A(1:D+1:end)=100./sqrt(1:D);
            Sig1=A;
            Sig0=A;
            
        case 'toeplitz'
            rho=0.5;
            A=nan(D);
            for a=1:D
                for b=1:D
                    A(a,b)=rho^abs(a-b);
                end
            end
            
            mu1=0.2*ones(D,1);
            mu0=-0.2*ones(D,1);
            Sig1=A;
            Sig0=A;
            
        case 'toeplitz-c'
            rho=0.5;
            A=nan(D);
            for a=1:D
                for b=1:D
                    A(a,b)=rho^abs(a-b);
                end
            end
            
            mu1=0.2*ones(D,1);
            mu0=zeros(D,1);
            Sig1=A;
            Sig0=A;
            
        case 'decaying'
            
            A=eye(D);
            A(1:D+1:end)=100./sqrt(1:D);
            
            mu1=2*ones(D,1);
            mu0=-mu1;
            Sig1=A;
            Sig0=A;
            
            
        case 'model1'
            
            rho=0.5;
            A=rho*ones(D);
            A(1:D+1:end)=1;
            
            s0=10;
            mu1=[ones(s0,1); zeros(D-s0,1)];
            mu0=zeros(D,1);
            Sig1=A;
            Sig0=A;
            
        case 'model3'
            rho=0.8;
            A=nan(D);
            for a=1:D
                for b=1:D
                    A(a,b)=rho^abs(a-b);
                end
            end
            
            s0=10;
            mu1=[ones(s0,1); zeros(D-s0,1)];
            mu0=zeros(D,1);
            Sig1=A;
            Sig0=A;
            
            
        case '1'
            P.ntrain=100;
            D=400;
            rho=0.5;
            A=nan(D);
            for a=1:D
                for b=1:D
                    A(a,b)=rho^abs(a-b);
                end
            end
            mu1=zeros(D,1);
            beta=0.556*[3;1.5;0;0;2;zeros(D-5,1)];
            mu0=A*beta;
            Sig1=A;
            Sig0=A;
        case '2'
            P.ntrain=100;
            D=400;
            rho=0.5;
            A=nan(D);
            for a=1:D
                for b=1:D
                    A(a,b)=rho^abs(a-b);
                end
            end
            mu1=zeros(D,1);
            beta=0.582*[3;2.5;-2.8;zeros(D-3,1)];
            mu0=A*beta;
            Sig1=A;
            Sig0=A;
        case '3'
            P.ntrain=400;
            D=800;
            rho=0.5;
            A=0.5*eye(D)+0.5*ones(D);
            mu1=zeros(D,1);
            beta=0.395*[3;1.7;-2.2;-2.1;2.55;zeros(D-5,1)];
            mu0=A*beta;
            Sig1=A;
            Sig0=A;
        case '4'
            P.ntrain=300;
            D=800;
            p=D/5;
            A0=0.4*eye(p)+0.6*ones(p);
            A1=eye(5);
            A=kron(A1,A0);
            beta=0.916*[1.2;-1.4;1.15;-1.64;1.5;-1;2;zeros(D-7,1)];
            mu1=zeros(D,1);
            mu0=A*beta;
            Sig1=A;
            Sig0=A;
        case '5'
            P.ntrain=400;
            D=800;
            A=0.5*eye(D)+0.5*ones(D);
            beta=0.551*[3;1.7;-2.2;-2.1;2.55;(D-5)^(-1)*ones(D-5,1)];
            mu1=zeros(D,1);
            mu0=A*beta;
            Sig1=A;
            Sig0=A;
        case '6'
            P.ntrain=400;
            D=800;
            A=0.5*eye(D)+0.5*ones(D);
            mu1=zeros(D,1);
            beta=0.362*[3;1.7;-2.2;-2.1;2.55;(D-5)^(-1)*ones(D-5,1)];
            mu0=A*beta;
            Sig1=A;
            Sig0=A;
            
        case 'DRL' % simple angle
            
            mudelt = 2.5;                                 % distance betwen dim 1 of means
            mu1 = [-mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            mu0 = [mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            mu1(2)=mu1(2)/3;
            mu0(2)=mu0(2)/3;
            
            sv = sd/sqrt(D)*ones(D,1);
            sv(2)=4;
            A  = eye(D,D); %A(1:2,1:2)=[1,2;0,1];       % singular vectors
            Sig=A*diag(sv);                            % class 1 cov
            Sig(1,2) = sv(2)/2;
            Sig(2,1) = sv(2)/2;
            Sig=Sig+eye(D);
            Sig1=Sig;
            Sig0=Sig;
            
    end
    
    if sim.permute
        pi=randperm(D);
    else
        pi=1:D;
    end
    Q=eye(D);
    Q=Q(pi,:);
    P.mu1=Q*mu1;
    P.mu0=Q*mu0;
    P.Sig1=Q*Sig1*Q';
    P.Sig0=Q*Sig0*Q';
    P.pi=pi;
    [~,d1, v1]=svd(Sig1);
    P.d1=diag(d1);
    idx1=find(diff(P.d1)==0,1);
    P.v1=v1(:,1:idx1);
    
    [~,d0, v0]=svd(Sig0);
    P.d0=diag(d0);
    idx0=find(diff(P.d0)==0,1);
    P.v0=v0(:,1:idx0);
    P.Q=Q;
    P.name=sim.name;
else
    P=sim.P;
end

mubar=(P.mu1+P.mu0)/2;
P.mu1=P.mu1-mubar;
P.mu0=P.mu0-mubar;

P.delta=mu1-mu0;
if norm(Sig1-Sig0)<10^-4
    P.Risk=1-normcdf(0.5*sqrt(P.delta'*(P.Sig1\P.delta)));
end

if max(abs(P.mu1+P.mu0))>10^-4
    error('means are not centered')
end
% if max(max(abs(P.Sig1-P.Sig1')))>10^-4
%     error('Sig1 is not symmetric')
% end
% if max(max(abs(P.Sig0-P.Sig0')))>10^-4
%     error('Sig0 is not symmetric')
% end
[~,p1]=chol(P.Sig1);
[~,p2]=chol(P.Sig0);
if p1>0 || p2>0
    error('Sig1 or Sig0 is not positive definite')
end



