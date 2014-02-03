function plot_relative(T,S,F,row,col)
%  plot Lhats for each alg, one row per dataset
% INPUT:
%   T: dataset info
%   S: statistics of algorithms
%   F: figure properties
%   row: which row
%   col: which column


% plot relative accuracies
maxt=0.0;
mint=0.5;
subplot(F.Nrows,F.Ncols,F.Ncols*row-col), hold all

% find LDA
did_lda = false;
for i=1:T.Nalgs
    if strcmp(T.algs{i},'LDA'),
        lda_id=i;
        did_lda = true;
        break,
    end
end
for i=1:T.Nalgs;
    
    if did_lda % if we ran LDA, this is the baseline
        if ~strcmp(T.algs{i},'LDA')
            if S.means.Lhats(lda_id,1) < mean(S.Lchance);
                temp=S.means.Lhats(i,:)-S.means.Lhats(lda_id,1);
                tit='LDA';
            else
                temp=S.means.Lhats(i,:)-mean(S.Lchance);
                tit='chance';
            end
            plot(T.ks,temp,'color',F.colors{i},'linewidth',2,'linestyle','-')
            maxt=max(maxt,max(temp));
            mint=min(mint,min(temp));
        end
        
    else % if not, baseline is chance
        temp=S.means.Lhats(i,:)-mean(S.Lchance);
        plot(T.ks,temp,'color',F.colors{i},'linewidth',2,'linestyle','--')
        maxt=max(maxt,max(temp));
        mint=min(mint,min(temp));
    end
    
    plot(T.ks,zeros(T.Nks,1),'--','color','k','linewidth',2)
    ylabel(['D', num2str(T.D), ', n', num2str(T.ntrain)])
end

mint=mint*1.1;
maxt=maxt*1.1;
if abs(mint-0)<10^-2, 
    ylim=[-0.1 0.1];
else
    ylim=[mint 0];
end
set(gca,'XScale','log','Ylim',ylim,'Xlim',[1 T.Kmax])
grid on
if did_lda
    title(['Rel. Acc. vs. ', tit])
else
    title('Rel. Acc. vs. chance')
end
if row==F.Nrows, xlabel('# of dimensions'), end