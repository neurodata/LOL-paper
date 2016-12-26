% co = [
%     51,160,44; 
%     31,120,180; 
%     227,26,28; 
%     255,127,0;
%     178,223,138; 
%     166,206,227; 
%     251,154,153; 
%     253,191,111; 
% ];  


% http://colorbrewer2.org/?type=qualitative&scheme=Set2&n=8
co = [ 102,194,165;  252,141,98;  141,160,203;  231,138,195;  166,216,84;  255,217,47;  229,196,148;  179,179,179'];
co = co ./255;

set(groot,'defaultAxesColorOrder',co)


I=eye(8);
for i=1:8, I(i,i)=i;end

figure(1), clf
plot(rand(10,8)+ones(10,8)*I,'linewidth',2)