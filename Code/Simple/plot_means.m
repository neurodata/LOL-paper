function plot_means(setting,F)

D=100;

if ~isfield(F,'ddiv') F.ddiv=1; end
if ~isfield(F,'legend'), F.legend=1; end
if ~isfield(F,'ids'), F.ids=2:1:10; end
if ~isfield(F,'col'), F.col=get(groot,'defaultAxesColorOrder'); end
%%

switch setting
    case 'rtrunk'
        [mu,Sigma]=rtrunk(D);
        F.ids=D/2:5:D;
    case 'toeplitz'
        %         D=10;
        [mu,Sigma]=toep(D);
    case '3trunk'
        [mu,Sigma] = rtrunk(D,6,0,3);
        F.ids=D/2:5:D;
    case 'fat_tails'
        [~,~,~,~,mu,Sigma] = fat_tails(D,10,10);
    case 'r2toeplitz'
        %         D=10;
        [mu,Sigma]=toep(D,1);
end

ids=D:-1:1;
%%
% means
subplot(F.nrows,F.ncols,(F.row-1)*F.ncols+2)
cla, hold all
mu2=mu(1:10,:);
o3=ones(1,3);
col=[0*o3; 0.6*o3; 0.9*o3; 0.75*o3];
set(gca,'ColorOrder',col)
mu2 = (mu2 - min(mu2(:)))/(max(mu2(:)) - min(mu2(:)));
plot(mu2,'linewidth',2)
axis('tight')
set(gca,'YTickLabel',[],'XTickLabel',[])
if F.row==1, title([{'Means'}, {'(first 10 dimensions)'}]), end
if F.row==F.nrows
    set(gca,'XTick',[1,5,10])
    xlabel('Observed Dimensions')
end

% covariances
subplot(F.nrows,F.ncols,(F.row-1)*F.ncols+3)
cla, hold all
if F.row<F.nrows
    imagesc(flipud(Sigma(F.ids,F.ids,1)))
    colormap('bone')
    ltick=length(F.ids);
    mtick=round(ltick/2);
    ticks=[1  mtick, ltick];
    % set(gca,'xaxisLocation','top')
    
    if any(strcmp(setting,{'rtrunk','toeplitz'}))
        % switch setting
        %     case {'trunk','toeplizt'}
        F.xticklab=[F.ids(1), F.ids(mtick), F.ids(end)];
        F.yticklab=[F.ids(end), F.ids(mtick), F.ids(1)];
    else
        F.xticklab=[];
        F.yticklab=[];
    end
    set(gca,'XTick',ticks,'YTick',ticks,'XTickLabel',F.xticklab,'YTickLabel',F.yticklab)
    axis('tight')
    axis('square')
    if F.row==1, title([{'Covariances'}, {'(subset of dimensions)'}]), end
else
    cols=F.col;
    cols(7,:)=[1 1 1];
    cols(8:11,:)=col;
    
    for i=1:10
        if i==6, ls='--'; cols(i,:)=cols(1,:); else ,ls='-'; end
        plot(rand(1,10),'linewidth',2,'Color',cols(i,:),'LineStyle',ls)
    end  
    %     col=get(gca,'ColorOrder');
%     plot(rand(1,10),'linewidth',2,'Color',col)
    xlim([-100, -90])
    ylim([-100, -90])


    set(gca,'visible','off');
    h=legend('LOL','PCA''','PCA','ROAD','Lasso','QOQ',' ',...
        '$\mu_1$','$\mu_2$','$\mu_3$'); % [left bottom width height]
    set(h,'Interpreter','latex','Box','off','Position',[0.3 0.05 1 0.2])

end


% if F.legend
%     legend('show')
% end
