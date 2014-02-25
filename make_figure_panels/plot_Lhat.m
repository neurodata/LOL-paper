function plot_Lhat(T,S,F,col)
%  plot Lhats for each alg, one col per task
% INPUT:
%   T: task info
%   S: statistics of algorithms
%   F: figure properties
%   col: which col

Nalgs=length(T.algs);
legendcell=[];
for i=1:Nalgs
    legendcell=[legendcell; T.algs(i)];
end

plot_chance = false;
plot_bayes = false;
plot_risk = false;

if plot_chance, legendcell=[legendcell;'chance']; end
if plot_bayes,  legendcell=[legendcell;'Bayes']; end
if plot_risk,   legendcell=[legendcell;'Risk']; end
minLDA=0.5;

% plot accuracies
subplot(F.Nrows,F.Ncols,col), hold all
minAlg=0.5;
for i=1:Nalgs;
%     
%     if T.ntest>9
%         location=S.medians.Lhats(i,:);
%         loc=' median';
%     else
        location=S.means.Lhats(i,:);
        loc=' mean';
%     end
    minloc=min(location);
    
    if isnan(location(2)) % if no dimension tuning in algorithm
        plot(T.ks,location(1)*ones(size(T.ks)),'-','linewidth',2,'color',F.colors{i})
    else
        plot(T.ks,location,'color',F.colors{i},'linewidth',2)
        minAlg=min(minAlg,minloc);
    end
end

% plot upper and lower bounds
if plot_chance, plot(1:T.Kmax,mean(S.Lchance)*ones(T.Kmax,1),'-k','linewidth',2), end
if T.QDA_model % plot emperically computed Lhat for the Bayes classifier
    if plot_bayes
        plot(1:T.Kmax,median(S.Lbayes)*ones(T.Kmax,1),'-.r','Linewidth',2)
        YL=0.9*median(S.Lbayes);
    end
    
    if isfield(S,'Risk')     % plot risk if we can compute it analytically
        if plot_risk,
            plot(1:T.Kmax,S.Risk*ones(T.Kmax,1),'-k','linewidth',2),
        end
        % YL=0.9*S.Risk;
    end
end

% formatting
YU=0.5; %YU = min(S.means.Lhats(:,1))*1.1;
if T.ntest>9
    YL=0.9*nanmin(S.medians.Lhats(:));
    YL=YL-(YU-YL)*0.1;
else
    YL=0.9*nanmin(S.means.Lhats(:));
    YL=YL-(YU-YL)*0.1;
end


set(gca,'XScale','linear','Ylim',[YL, 0.5],'Xlim',[1 T.Kmax])
title(T.name)
grid on
if col==1, ylabel('$\langle \hat{L}_n \rangle$','interp','latex'), end