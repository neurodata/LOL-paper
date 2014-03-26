function [X, Y, P] = choose_simulation(sim)
%
% simulate data in a variety of different ways
%
% INPUT:
%   sim:    a structure containing fields:
%       name: the name of of simulation
%       sd: a scalar multiplicative
%       permute: whether to randomly permute which dimensions are which,
%       for testing purposes.
%   n:      # of samples
%   D:      ambient dimension
%   (optional)
%   P:  specify the actual parameters
%
% OUTPUT:
%   X:      responses in R^{n x D}
%   Y:      classes in {0,1}^n
%   P:      structure containing parameters
%       parameters (mu1, mu2, Sig1, Sig2)


if ~isfield(sim,'sd'), sd=1; else sd=sim.sd; end
if ~isfield(sim,'permute'), sim.permute=0; end
if ~isfield(sim,'D'), D=100; else D=sim.D; end
if ~isfield(sim,'n'), n=550; else n=sim.n; end

if ~isfield(sim,'P')
    
    switch sim.name
        
        case 'w' % wide
            
            mudelt = 6/sqrt(D);                                 % distance betwen dim 1 of means
            mu1 = [-mudelt/2; zeros(D-1,1)];                   % class 1 mean
            mu2 = [mudelt/2; zeros(D-1,1)];                     % class 2 mean

            sv = sd/sqrt(D)*ones(D,1);
            sv(2)=1;
            A  = eye(D,D); 
            Sig1=A*diag(sv);                            % class 1 cov
            Sig2=A*diag(sv);                            % class 2 cov
            
        case 's' % simple
            
            mudelt = 3/sqrt(D);                                 % distance betwen dim 1 of means
            mu1 = [-mudelt/2; zeros(D-1,1)];                   % class 1 mean
            mu2 = [mudelt/2; zeros(D-1,1)];                     % class 2 mean

            sv = sd/sqrt(D)*ones(D,1);
            sv(2)=1;
            A  = eye(D,D);       
            Sig1=A*diag(sv);                            % class 1 cov
            Sig2=A*diag(sv);                            % class 2 cov
            
        case 'sa' % simple angle
            
            mudelt = 2.5;                                 % distance betwen dim 1 of means
            mu1 = [-mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            mu2 = [mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            mu1(2)=mu1(2)/3;
            mu2(2)=mu2(2)/3;
            
            sv = sd/sqrt(D)*ones(D,1);
            sv(2)=4;
            A  = eye(D,D); %A(1:2,1:2)=[1,2;0,1];       % singular vectors
            Sig1=A*diag(sv);                            % class 1 cov
            Sig2=A*diag(sv);                            % class 2 cov
            
            Sig1(1,2) = sv(2)/2;
            Sig1(2,1) = sv(2)/2;
            Sig2(1,2) = sv(2)/2;
            Sig2(2,1) = sv(2)/2;
            
            Sig1=Sig1+eye(D);
            Sig2=Sig2+eye(D);
            
        case 'sa2' % simple angle
            
            mudelt = 3.5;                                 % distance betwen dim 1 of means
            mu1 = [-mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            mu2 = [mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            mu1(2)=mu1(2)/3;
            mu2(2)=mu2(2)/3;
            
            sv = sd/sqrt(D)*ones(D,1);
            sv(2)=4;
            A  = eye(D,D); %A(1:2,1:2)=[1,2;0,1];       % singular vectors
            Sig1=A*diag(sv);                            % class 1 cov
            Sig2=A*diag(sv);                            % class 2 cov
            
            Sig1(1,2) = sv(2)/2;
            Sig1(2,1) = sv(2)/2;
            Sig2(1,2) = sv(2)/2;
            Sig2(2,1) = sv(2)/2;
            
            Sig1=Sig1+eye(D);
            Sig2=Sig2+eye(D);        case 'wa' % wide angle
            
            k = 1;                                      % # of latent dimensions with relatively high variance
            mudelt = 3;                                 % distance betwen dim 1 of means
            sv = sd/sqrt(D)*ones(D,1);
            sv(2)=2;
            A  = eye(D,D); %A(1:2,1:2)=[1,2;0,1];       % singular vectors
            mu1 = [-mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            mu2 = [mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            
            Sig1=A*diag(sv);                            % class 1 cov
            Sig2=A*diag(sv);                            % class 2 cov
            
            Sig1(1,2) = sv(2)/2;
            Sig1(2,1) = sv(2)/2;
            Sig2(1,2) = sv(2)/2;
            Sig2(2,1) = sv(2)/2;
            
            Sig1=Sig1+eye(D);
            Sig2=Sig2+eye(D);
            
        case 'r' % rotated
            
            k = 1;                                      % # of latent dimensions with relatively high variance
            mudelt = 1;                                 % distance betwen dim 1 of means
            sv = sd/sqrt(D)*ones(D,1);
            
            A  = eye(D,D); %A(1:2,1:2)=[1,2;0,1];       % singular vectors
            mu1 = [-mudelt/2; zeros(D-1,1)];                   % class 1 mean
            mu2 = [mudelt/2; zeros(D-1,1)];                     % class 2 mean
            
            sv1=sv;
            sv1(2)=1;
            Sig1=A*diag(sv1);                            % class 1 cov
            
            sv2=sv;
            sv2(1)=1;
            Sig2=A*diag(sv2);                            % class 2 cov
            
            
        case 'wra' % wide angle
            
            k = 1;                                      % # of latent dimensions with relatively high variance
            mudelt = 8/sqrt(D);                                 % distance betwen dim 1 of means
            sv = 3*sd/sqrt(D)*ones(D,1);
            sv(2)=2;
            A  = eye(D,D); %A(1:2,1:2)=[1,2;0,1];       % singular vectors
            mu1 = [-mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            mu2 = [mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            
            mu1(1)=mu1(1)*2;
            mu2(1)=mu2(1)*2;
            
            mu1(2)=mu1(2)/3;
            mu2(2)=mu2(2)/3;
            
            Sig1=A*diag(sv);                            % class 1 cov
            Sig2=A*diag(sv);                            % class 2 cov
            
            Sig1(1,2) = sv(2)/2;
            Sig1(2,1) = sv(2)/2;
            
            Sig2(1,2) = -sv(2)/2;
            Sig2(2,1) = -sv(2)/2;
            
            Sig1=Sig1+eye(D);
            Sig2=Sig2+eye(D);
        case 'wra2' % wide angle
            
            k = 1;                                      % # of latent dimensions with relatively high variance
            mudelt = 16/sqrt(D);                                 % distance betwen dim 1 of means
            sv = 3*sd/sqrt(D)*ones(D,1);
            sv(2)=2;
            A  = eye(D,D); %A(1:2,1:2)=[1,2;0,1];       % singular vectors
            mu1 = [-mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            mu2 = [mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            
            mu1(1)=mu1(1)*2;
            mu2(1)=mu2(1)*2;
            
            mu1(2)=mu1(2)/3;
            mu2(2)=mu2(2)/3;
            
            Sig1=A*diag(sv);                            % class 1 cov
            Sig2=A*diag(sv);                            % class 2 cov
            
            Sig1(1,2) = sv(2)/2;
            Sig1(2,1) = sv(2)/2;
            
            Sig2(1,2) = -sv(2)/2;
            Sig2(2,1) = -sv(2)/2;
            
            Sig1=Sig1+eye(D);
            Sig2=Sig2+eye(D);
        case 'pca'
            
            k = 2;
            sv = [ones(k,1);sd/sqrt(D)*ones(D-k,1)];
            A  = eye(D,D); 
            A(1:2,1:2)=[1,2;0,1];
            mu1 = zeros(D,1);
            mu2 = [2;zeros(D-1,1)];                     % PCA good, lda ok.
            
            Sig1=A*diag(sv);                            % class 1 cov
            Sig2=A*diag(sv);                            % class 2 cov
            
        case 'lda'
            
            k = 2;
            sv = [ones(k,1);2*sd/sqrt(D)*ones(D-k,1)];
            A  = eye(D,D); A(1:2,1:2)=[1,2;2,1];
            mu1 = zeros(D,1);
            mu2 = 0.5*[zeros(k,1);1;zeros(D-k-1,1)];        % PCA screws up, lda kaboom!, SDA kaboon!
            
            Sig1=A*diag(sv);                            % class 1 cov
            Sig2=A*diag(sv);                            % class 2 cov
            
            Sig1=Sig1+eye(D);
            Sig2=Sig2+eye(D);

        case 'lda2'
            
            k = 2;
            sv = [ones(k,1);sd/sqrt(D)*ones(D-k,1)];
            A  = eye(D,D); %A(1:2,1:2)=[1,2;0,1];
            mu1 = zeros(D,1);
            mu2 = 0.5*[zeros(k,1);1;zeros(D-k-1,1)];        % PCA screws up, lda kaboom!, SDA kaboon!
            
            Sig1=A*diag(sv);                            % class 1 cov
            Sig2=A*diag(sv);                            % class 2 cov
           
            Sig1=Sig1+eye(D);
            Sig2=Sig2+eye(D);
            
        case 'weird'
            
            %         k = 2;
            sv = [0.05*sd/sqrt(D)*ones(D,1)];
            A  = eye(D,D); %A(1:2,1:2)=[1,2;0,1];
            mu1 = zeros(D,1);
            mu2 = mu1;                     % PCA good, lda ok.
            mu2(10:20)=1;
            
            Sig1=A*diag(sv);                            % class 1 cov
            Sig2=A*diag(sv);                            % class 2 cov
            
        case 'trunk'
            
            mu1=2./sqrt(1:D)';
            mu2=-mu1;
            A = sqrt(D)*0.5*eye(D);
            Sig1 = A;
            Sig2 = A;
            
        case 'trunk2'
            
            mu1=12./sqrt(D:-1:1)';
            mu2=-mu1;
            
            A=eye(D);
            A(1:D+1:end)=100./sqrt(1:D);
            Sig1=A;
            Sig2=A;

        case 'toeplitz'
            rho=0.5;
            A=nan(D);
            for a=1:D
                for b=1:D
                    A(a,b)=rho^abs(a-b);
                end
            end
            
            mu1=0.2*ones(D,1);
            mu2=-0.2*ones(D,1);
            Sig1=A;
            Sig2=A;
            
        case 'toeplitz-c'
            rho=0.5;
            A=nan(D);
            for a=1:D
                for b=1:D
                    A(a,b)=rho^abs(a-b);
                end
            end
            
            mu1=0.2*ones(D,1);
            mu2=zeros(D,1);
            Sig1=A;
            Sig2=A;
            
        case 'decaying'
            
            A=eye(D);
            A(1:D+1:end)=100./sqrt(1:D);
            
            mu1=2*ones(D,1);
            mu2=-mu1;
            Sig1=A;
            Sig2=A;
            
            
        case 'model1'
            
            rho=0.5;
            A=rho*ones(D);
            A(1:D+1:end)=1;
            
            s0=10;
            mu1=[ones(s0,1); zeros(D-s0,1)];
            mu2=zeros(D,1);
            Sig1=A;
            Sig2=A;
            
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
            mu2=zeros(D,1);
            Sig1=A;
            Sig2=A;
            
            
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
            mu2=A*beta;
            Sig1=A;
            Sig2=A;
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
            mu2=A*beta;
            Sig1=A;
            Sig2=A;
        case '3'
            P.ntrain=400;
            D=800;
            rho=0.5;
            A=0.5*eye(D)+0.5*ones(D);
            mu1=zeros(D,1);
            beta=0.395*[3;1.7;-2.2;-2.1;2.55;zeros(D-5,1)];
            mu2=A*beta;
            Sig1=A;
            Sig2=A;
        case '4'
            P.ntrain=300;
            D=800;
            p=D/5;
            A0=0.4*eye(p)+0.6*ones(p);
            A1=eye(5);
            A=kron(A1,A0);
            beta=0.916*[1.2;-1.4;1.15;-1.64;1.5;-1;2;zeros(D-7,1)];
            mu1=zeros(D,1);
            mu2=A*beta;
            Sig1=A;
            Sig2=A;
        case '5'
            P.ntrain=400;
            D=800;
            A=0.5*eye(D)+0.5*ones(D);
            beta=0.551*[3;1.7;-2.2;-2.1;2.55;(D-5)^(-1)*ones(D-5,1)];
            mu1=zeros(D,1);
            mu2=A*beta;
            Sig1=A;
            Sig2=A;
        case '6'
            P.ntrain=400;
            D=800;
            A=0.5*eye(D)+0.5*ones(D);
            mu1=zeros(D,1);
            beta=0.362*[3;1.7;-2.2;-2.1;2.55;(D-5)^(-1)*ones(D-5,1)];
            mu2=A*beta;
            Sig1=A;
            Sig2=A;
            
        case 'DRL' % simple angle
            
            mudelt = 2.5;                                 % distance betwen dim 1 of means
            mu1 = [-mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            mu2 = [mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
            mu1(2)=mu1(2)/3;
            mu2(2)=mu2(2)/3;
            
            sv = sd/sqrt(D)*ones(D,1);
            sv(2)=4;
            A  = eye(D,D); %A(1:2,1:2)=[1,2;0,1];       % singular vectors
            Sig=A*diag(sv);                            % class 1 cov
            Sig(1,2) = sv(2)/2;
            Sig(2,1) = sv(2)/2;
            Sig=Sig+eye(D);
            Sig1=Sig;
            Sig2=Sig;
            
    end
    
    if sim.permute
        pi=randperm(D);
    else
        pi=1:D;
    end
    Q=eye(D);
    Q=Q(pi,:);
    P.mu1=Q*mu1;
    P.mu2=Q*mu2;
    P.Sig1=Q*Sig1*Q';
    P.Sig2=Q*Sig2*Q';
    P.pi=pi;
    [~,d1, v1]=svd(Sig1);
    P.d1=diag(d1);
    idx1=find(diff(P.d1)==0,1);
    P.v1=v1(:,1:idx1);
    
    [~,d2, v2]=svd(Sig2);
    P.d2=diag(d2);
    idx2=find(diff(P.d2)==0,1);
    P.v2=v2(:,1:idx2);
    P.Q=Q;
    P.name=sim.name;
else
    P=sim.P;
end

mubar=(P.mu1+P.mu2)/2;
P.mu1=P.mu1-mubar;
P.mu2=P.mu2-mubar;

P.delta=mu1-mu2;
if norm(Sig1-Sig2)<10^-4
    P.Risk=1-normcdf(0.5*sqrt(P.delta'*(P.Sig1\P.delta)));
end

if max(abs(P.mu1+P.mu2))>10^-4
    error('means are not centered')
end
% if max(max(abs(P.Sig1-P.Sig1')))>10^-4
%     error('Sig1 is not symmetric')
% end
% if max(max(abs(P.Sig2-P.Sig2')))>10^-4
%     error('Sig2 is not symmetric')
% end
[~,p1]=chol(P.Sig1);
[~,p2]=chol(P.Sig2);
if p1>0 || p2>0
    error('Sig1 or Sig2 is not positive definite')
end

% [X, Y] = sample_data(n,P.mu1,P.mu2,P.Sig1,P.Sig2);


