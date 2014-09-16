function auxmtx = setaux(X,Y,h,p,V,D)
% setaux(X,Y,h,p,V,D)
% 
% This function sets shared auxiliary partial results to compute generating
% vectors for the central subspace according to SIR, SAVE and DR methods.
%-----------------------------------------------------------------


%----aux variable
n = length(Y);

%----construct indicator array---------------------------------------------
ydelta = getI(Y,h); 
pv = mean(ydelta);
%----standardize x--------------------------------------------------------- 
nsqrtx = invsqrtm(V,D); %Compute inverse sqrt of marginal covariance matrix
z = (X - kron(ones(n,1),mean(X)))*nsqrtx ;  

%----construct auxiliary arrays--------------------------------------------
cez = zeros(p,h);
cezz = zeros(p,p,h);
for i = 1:h,
    for j=1:n,
		cez(:,i) = cez(:,i)+(z(j, : )*ydelta(j,i))';
		cezz(:,:,i) = cezz(:,:,i) + z(j,: )'*z(j,: )*ydelta(j,i);
    end
	 cez(:,i) = cez(:,i)/n/pv(i);
	 cezz(:,:,i) = cezz(:,:,i)/n/pv(i);
end
mat1 = zeros(p);
mat2 = zeros(p);
mat3 = 0;
mat4 = zeros(p);
mat5 = zeros(p);
for i=1:h,
	mat1 = mat1 + cezz(:,:,i)*cezz(:,:,i)*pv(i);
	mat2 = mat2 + cez(:,i)*cez(:,i)'*pv(i);
	mat3 = mat3 + sum(cez(:,i).^2)*pv(i);
	mat4 = mat4 + cezz(:,:,i)*cez(:,i)*cez(:,i)'*pv(i);	
	mat5 = mat5 + sum(cez(:,i).^2)*cez(:,i)*cez(:,i)'*pv(i);	
end
auxmtx.mat1 = mat1;
auxmtx.mat2 = mat2;
auxmtx.mat3 = mat3;
auxmtx.mat4 = mat4;
auxmtx.mat5 = mat5;
auxmtx.nsqrtx = nsqrtx;

%==============AUXILIARY FUNCTIONS=========================================
function I = getI(Y,h)
I = zeros(length(Y),h);
for i=1:h,
	I(:,i) = (Y==i);
end
