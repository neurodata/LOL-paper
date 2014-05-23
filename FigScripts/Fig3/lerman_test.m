N0=125;
N1=125;
D=10;
d=5;
noise=0.1;

[X0, V0]=lerman_model(N0,N1,D,d,noise);
[X1, V1]=lerman_model(N0,N1,D,d,noise);

X=[X0', X1'];
Y=[zeros(N0+N1,1); ones(N0+N1,1)]';


R0=m_estimator_gms(X0);
R1=m_estimator_gms(X1);

[RD0, RV0]=eig(R0);
[RD1, RV1]=eig(R1);

[ru,rd,rv]=svd(V0'*RV0,0);

C0=cov(X0);
C1=cov(X1);

[CD0, CV0]=eig(C0);
[CD1, CV1]=eig(C1);

[ku,kd,kv]=svd(V0'*CV0,0);

[u,d,v]=svd(V0'*V1);

[sum(diag(rd)), sum(diag(kd)), sum(diag(d))]


%%

types={'DENE'};
Kmax=5;
[Proj, P] = LOL(X,Y,types,Kmax);


%% test if data must be centered prior to doing stuff
% r0=m_estimator_gms(X0+40);
% [rd0,rv0]=eig(r0);
% [rru,rrd,rrv]=svd(V0'*rv0,0);
% sum(diag(rd))-sum(diag(rrd))
% % seems like stuff works better when centered
%%

clearvars, clc
j=6;
task.name='gms';
task.simulation=1;
task.ntrials=5;
task.percent_unlabeled=0;
task.ntrain=250;
task.D=50;
task.types={'DVNV'; 'DVRV'};
[T{j},S{j},P{j}] = run_task(task);
