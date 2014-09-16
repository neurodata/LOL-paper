function directions = get_more(todos,ni,p,h,u)
% 
% directions = get_more(todos,ni,p,h,u)
% 
% This is an auxiliary function used to compute an initial estimate for
% likelihood maximization.
% ========================================================================

%---Define aux variables
Del = zeros(p);
directions = zeros(h+2,p,u);
Deltag = zeros(p);
n = sum(ni);
Ip = eye(p);
for i=1:h,
 Deltag(:,:) = todos(i,:,:);
 directions(i,:,:) = firsteigs(Deltag,u);
 Del = Del + ni(i)*Deltag;
end
Del = Del/n;

aux1 = zeros(p);
aux2 = zeros(p);
for i=1:h,
    Deltag(:,:) = todos(i,:,:);
    aux1 = aux1 + sqrm(inv(Del)*(Deltag-Del)*inv(Del));
    aux2 = aux2 + sqrm(Ip - invsqrtm(Del)*Deltag*invsqrtm(Del));
end
%first u eigenvectors of mean of covariance matrices
directions(h+1,:,:) = firsteigs(aux1,u);
% first u eigenvectors of W initial value for common principal components.
directions(h+2,:,:) = firsteigs(aux2,u);

