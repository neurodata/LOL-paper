
% test choose_simulation
sim.name = 'w';
% sim.n = 10000;
% sim.d = 2;
% sim.P.mu1 = 1;
% sim.P.mu = -1;


mu1 = [1 -1]; Sigma1 = [.9 .4; .4 .3];
X1 = mvnrnd(mu1, Sigma1, 500)'; % p = 2 x n = 500 matrix

mu2 = [4 3]; Sigma2 = [.9 -.4; -.4 .3]';
X2 = mvnrnd(mu2, Sigma2, 500)'; % p = 2 x n = 500 matrix

X = [X1 X2]; % p = 2 x n = 1000
figure; plot(X(1,:), X(2,:), 'x');


% jovo's

choose_simulation(sim);


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
            Sig2=A*diag(sv);
            
    end
end
