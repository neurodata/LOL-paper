clear, clc

D=5;
fprintf('\nd = %D', D)

%%

fprintf('\nrandn(D)')
L=randn(D);
Sig=L'*L;
fprintf('\nrank = %D', rank(Sig))
fprintf('\nnorm(Sig-Sig.T) = %D', norm(Sig-Sig'))
[U,S,V]=svd(Sig);
fprintf('\nnorm(U*U.T) = %D', norm(U*U'-eye(D))) % = 0
fprintf('\nnorm(V.T*V) = %D', norm(V'*V-eye(D))) % = 0
fprintf('\ndiag(S) = %1.2f, %1.2f, %1.2f, %1.2f, %1.2f\n', diag(S)) % = diag

%%

fprintf('\north(randn(D))')
L=orth(randn(D));
Sig=L'*L;
fprintf('\nrank = %D', rank(Sig))
fprintf('\nnorm(Sig-Sig.T) = %D', norm(Sig-Sig'))
[U,S,V]=svd(Sig);
fprintf('\nnorm(U*U.T) = %D', norm(U*U'-eye(D))) % = 0
fprintf('\nnorm(V.T*V) = %D', norm(V'*V-eye(D))) % = 0
fprintf('\ndiag(S) = %1.2f, %1.2f, %1.2f, %1.2f, %1.2f\n', diag(S)) % = diag

%%

clc
theta=4;
switch theta
    case 1
        fprintf('\n del=ones/sqrt(D)\n Sig=Identity\n')
        del=ones(D,1);
        del=del/norm(del,2);
        L=eye(D);
        Sig=L'*L;
    case 2
        fprintf('\n del=ones/sqrt(D)\n Sig=orth(randn)\n')
        del=ones(D,1);
        del=del/norm(del,2);
        L=orth(randn(D));
        Sig=L'*L;
        
    case 3
        fprintf('\n del=ones/norm(del,2)\n Sig=randn\n')
        del=ones(D,1);
        del=del/norm(del,2);        
        L=(randn(D));
        Sig=L'*L;
        
    case 4
        fprintf('\n del=randn/norm(del,2)\n Sig=randn\n')
        del=randn(D,1);
        del=del/norm(del,2);        
        L=(randn(D));
        Sig=L'*L;
end

BP=Sig^(-1)*del;
fprintf('\nBayes Project = %1.2f, %1.2f, %1.2f, %1.2f, %1.2f\n', BP)

nBP=BP/norm(BP)
fprintf('\nBP.T*BP = %1.2f\n', nBP'*nBP)

% let A be a random dx2 projection matrix
A=orth(randn(5,2));
SA=A'*Sig^(-1)*A;
dA=A'*del;

AP=A*SA^(-1)*dA;
corrA=(BP/norm(BP,2))'*(AP/norm(AP,2));
fprintf('\nAngle(Bayes, Random Dx2 orthonormal matrix) = %1.2f\n', corrA)

% let A = bayes optimal projection matrix
A=orth(BP);
AP=A*A'*Sig^(-1)*A*A'*del;
corrB=(BP/norm(BP,2))'*(AP/norm(AP,2));
fprintf('\nAngle(Bayes, Optimal projection) = %1.2f\n', corrB)


%%

clear, clc
D=10;
d=5;
del=ones(D,1);
del=del/norm(del,2);
L=(randn(D));
Sig=L'*L;

[U,S,V]=svd(Sig);

d=5;
Ud=U(:,1:d);
Sd=S(1:d,1:d);
Xd=(Ud*sqrt(Sd));

figure(1), 
subplot(221), imagesc(Ud'*Ud), title('UT*U'),colorbar
subplot(222), imagesc(Ud*Ud'), title('U*UT'), colorbar
subplot(223), imagesc(Xd'*Xd), title('XT*X'),colorbar
subplot(224), imagesc(Xd*Xd'), title('X*XT'), colorbar

figure(2),
subplot(121), imagesc(Xd*Xd'-Sig), title('XT*X-Sig'),colorbar
subplot(122), imagesc(Xd'*Xd-Ud'*Ud), title('XT*X-UT*U'),colorbar

figure(3)
subplot(121), imagesc(U'*Ud), title('UT*Ud'), colorbar
subplot(122), imagesc(Ud'*U), title('UdT*U'), colorbar


IDd=U'*Ud;
IdD=Ud'*U;


