function [] = plotDR(WX,Y,morph,model)
%
% plotDR(Y,WX,morph,model);
% 
% This function plots regression and classification data projected onto the 
% central subspace. For continuous responses, function plots Y vs the first 
% two columns in WX. For discrete responses, function plots the coordinates 
% in the reduced subspace labeled by the classes in Y.
%
% USAGE:
% - inputs:
%    - Y: response vector
%    - WX: projection of predictors onto the central subspace
%    - morph: string used to set the type of response. Allowed values are 
%      'cont' and 'disc', for continuous and discrete responses, respectively.
%    - model: string used to set the dimensionality reduction method used to 
%      get WX. This is used to label the axes...
%
% Unlike built-in matlab functions such as scatter or scatter3, plotDR is
% supposed to interpret dimensionality in data in order to choose for the
% right plot. In addition, note that despite it is easier to use with WX 
% resulting from the application of a function such as ldr, SIR, SAVE, etc.,
% you can also get 'hybrid' plots using coordinates taken from different 
% methods by just concatenating them as columns of a single matrix. In example,
% suppose you would like to plot classification data using SAVE-1 vs SIR-1. 
% To do so, type:
%    WX = [WXsir(:,1) WXsave(:,1)];
%    plotDR(Y,WX,'disc','SIR-SAVE');
%
% USE OF SCATTER AND SCATTER3 BUILT-IN FUNCTIONS
% Note that you would get similar results using the built-in function SCATTER.
% Following the previous example with classification data, you can type:
%    scatter(WXsir(:,1),WXsave(:,1),5,Y)
% where the number 5 just sets the size of the markers in the plot and Y is
% used to label the plot according to the different classes.
% In case of regression data, you can get a 2D plot by typing:
%    scatter(Y,WX(:,1))
%
% For 3D plots, you can use the built-in function SCATTER3 in a similar way.
% For classification data, type
%    scatter3(WX(:,1),WX(:,2),WX(:,3),5,Y)
%
% and for regression data type:
%    scatter3(Y,WX(:,1),WX(:,2));
%
% See MATLAB documentation for further details.
% =========================================================================

if nargin > 3,
    ismodel = true;
else
    ismodel = false;
end
Y = Y + (1-min(Y));
a = min(Y);
b =max(Y);
d = size(WX,2);

gca;hold off;
%figure;hold;
if strcmpi(morph,'disc'),
    for i=a:b,
        class = WX(Y==i,:);
        label = getlabel(i);        
        if d>2,
            plot3(class(:,1),class(:,2),class(:,3),label); hold on;
            view(-37.5,30);
            if ismodel,
                xlabel(strcat(model,'-1'));
                ylabel(strcat(model,'-2'));
                zlabel(strcat(model,'-3'));
            end
            set(gca,'xtick',[],'ytick',[],'ztick',[]);
        elseif d>1,
            plot(class(:,1),class(:,2),label); hold on;
            if ismodel,
                if strcmp(model,'SIR-SAVE'),
                    xlabel('SIR-1');
                    ylabel('SAVE-1');
                else
                    xlabel(strcat(model,'-1'));
                    ylabel(strcat(model,'-2'));
                end
            end
            set(gca,'xtick',[],'ytick',[]);
        elseif d==1;
            colores = {'b','r','g','k','y'};
            for k=1:b,
                [histo,bins]=hist(WX(Y==k,:));
                bar(bins,histo,colores{k}); hold on;
                xlabel(strcat(model,'-1'));
                set(gca,'xtick',[],'ytick',[]);
            end
        else
            error('empty array');
        end
    end
else
    if size(WX,2) > 1,
        plot3(WX(:,1),WX(:,2),Y(:),'ko');hold on;
        view(-37.5,30);
        if ismodel,
            xlabel(strcat(model,'-1'));
            ylabel(strcat(model,'-2'));
            zlabel('Y');
        end
        set(gca,'xtick',[],'ytick',[],'ztick',[]);
    else
        plot(WX(:,1),Y(:),'ko');hold on;
        if ismodel,
            xlabel(strcat(model,'-1'));
            ylabel('Y');
        end
        set(gca,'xtick',[],'ytick',[]);
    end
end
title(['Analysis using ' upper(model) ' model']);
hold off;

%=======================================================
function label = getlabel(idx)
labels = {'ro','go','bo','ko','r+','b+','g+','r*','g*','b*','k*','rx','gx','bx','kx','yo','co','mo','kd'};
label = labels{idx};