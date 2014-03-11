clf, clearvars, clc,
h(1)=figure(1);
%set(gcf,'renderer','zbuffer')
[x0, y0, z0] = ellipsoid(rand,rand,rand,rand,rand,rand,30);
S0=surfl(x0, y0, z0);
light;
fname='debugprint';
wh=[4, 2];
print(h,fname,'-dpdf')
