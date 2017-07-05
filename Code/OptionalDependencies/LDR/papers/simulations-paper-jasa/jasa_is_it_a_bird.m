% This script reproduces figure 4 and figure 5 from the paper "Likelihood-
% Based Sufficient Dimension Reduction", by D. Cook and L. Forzni.
%
% It is an example of the use of the LAD method for a discrimination task
% using real data.

clear all;
%setpaths;

data = load('marcewithout.txt');
Y = data(:,1);
X = data(:,2:end);

%% figure 4a
figure(1);
[WXsir,Wsir] = SIR(Y,X,'disc',2);
plotDR(WXsir,Y,'disc','SIR');
title('a. First two SIR directions');
xlabel('SIR-1');
ylabel('SIR-2');
legend('planes','cars','birds','Location','Best');

%% figure 4b
figure(2);
[WXsave,Wsave] = SAVE(Y,X,'disc',2);
plotDR(WXsave,Y,'disc','SAVE');
title('b. First two SAVE directions');
xlabel('SAVE-1');
ylabel('SAVE-2');
legend('planes','cars','birds','Location','Best');

%% figura 4c
figure(4);
WXhyb = [WXsir(:,1) WXsave(:,1)];
plotDR(WXhyb,Y,'disc','SIR-SAVE');
title('c. First SIR and first SAVE directions');
xlabel('SIR-1');
ylabel('SAVE-1');
legend('planes','cars','birds','Location','Best');


%% figure 4d
figure(3);
[WXdr,Wdr] = DR(Y,X,'disc',2);
plotDR(WXdr,Y,'disc','DR');
title('d. First and second DR directions');
xlabel('DR-1');
ylabel('DR-2');
legend('planes','cars','birds','Location','Best');

%% figure 5
figure(5);
[WXlad,Wlad,flad] = ldr(Y,X,'LAD','disc',2);
plotDR(WXlad,Y,'disc','LAD');
title('The first two LAD directions for the birds-planes-cars example');
xlabel('LAD-1');
ylabel('LAD-2');
legend('planes','cars','birds','Location','Best');

 