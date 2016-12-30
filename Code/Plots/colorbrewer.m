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
% co = [ 102,194,165;  252,141,98;  141,160,203;  231,138,195;  166,216,84;  255,217,47;  229,196,148;  179,179,179'];
% co=[166,206,227;
% 31,120,180;
% 178,223,138;
% 51,160,44;
% 251,154,153;
% 227,26,28;
% 253,191,111;
% 255,127,0;
% 202,178,214;
% 106,61,154;
% 255,255,153;
% 177,89,40];

co = [0,255,0; % green
0,255,255;  % cyan
255,0,255;  % magenta
255,127,0;  % orange
55,126,184; % blue
247,129,191;% pink
153,153,153;% gray
166,86,40;  % brown
152,78,163; % purple
77,175,74;  % forest
228,26,28;  % red
255,255,51];% yellow


co = co ./255;

set(groot,'defaultAxesColorOrder',co)

l=length(co);
I=eye(l);
for i=1:l, I(i,i)=i;end

figure(1), clf, hold all
plot(rand(100,l)+ones(100,l)*I,'linewidth',2)
% plot(rand(10,1),'g','linewidth',2)
% plot(rand(10,1)-1,'m','linewidth',2)
% plot(rand(10,1)-2,'c','linewidth',2)


