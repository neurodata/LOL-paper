% LOWESS- Locally Weighted Scatterplot Smoothing that does not require the
% statistical toolbox in matlab.
%
% This regression will work on linear and non-linear relationships between
% X and Y.
%
% Modifications:
%    12/19/2008 - added upper and lower LOWESS smooths.  These additional
%    smooths show how the distribution of Y varies with X.  These smooths
%    are simply LOWESS applied to the positive and negative residuals
%    separately, then added to the original lowess of the data.  The same
%    smoothing factor is applied to both the upper and lower limits.
%
% Using a robust regression like LOWESS allows one the ability to detect a
% trend in data that may otherwise have too much variance resulting in
% non-significance p-values.
%
% Yhat (prediction) is computed from a weghted least squares regression
% whose weights are both a function of distance from X and magnitude
% from of the residual from the previous regression.
%
% The conceptual of these functions and subfunctions follow the USGS
% Kendall.exe routines. Because matlab is 8-byte precision, there are
% some very small differences between FORTRAN compiled and matlab.
% Maybe 64-bit OS's has 16-byte precision in matlab?
%
% IMPORTANT Note:
% Data are expected to be sorted prior to data input for this function.
% Sorted on first column of datain.
%
% There is a very simple subfucntion to create a plot of the data and
% regression if the user so choses with a flag in the call to the lowess
% function. BTW-- the png file looks much better than what the figure looks
% like on screen.
%
% There are loops in these routines to keep the memory requirements to a
% minimum, since it is foreseeable that one may have very large datasets to
% work with.
%
% f = a smoothing factor between 0 and 1.  The closer to one, the more
% smoothing done.
%
% Syntax:
%    [dataout lowerLimit upperLimit] = lowess(datain,f,wantplot,imagefile)
%
%   datain = n x 2 matrix
%   dataout = n x 3 matrix
%   wantplot = scaler (optional)
%        if ~= 0 then create plot
%   imagefile = full path and file name where to output the figure to an
%        png file type at 600 dpi. If imagefile not provided, a figure will
%        be displayed but not exported to a graphics file.
%        e.g. imagefile = 'd:\temp\lowess.png';
%
% where:
%   datain(:,1) = x
%   datain(:,2) = y
%   f = scaler (0 < f < 1)
%   wantplot = scaler
%   imagefile = string
%
%  datain must be sorted prior to loading into this function on the
%  x-value.  This is not done in the function because the user may want to
%  have the end result be unsorted (e.g. time sort).
%
% dataout(:,1) = x
% dataout(:,2) = y
% dataout(:,3) = y-prediction (aka yhat)
% lowerLimit(:,1) = x with negative residuals
% lowerLimit(:,2) = y-prediction of residuals + original y-prediction
% upperLimit(:,1) = x with positive residuals
% upperLimit(:,2) = y-prediction of residuals + original y-prediction
%
% Requirements:  none
%
% Written by
% Jeff Burkey
% King County Department of Natural Resources and Parks
% email: jeff.burkey@kingcounty.gov
% 12/16/2008
function [dataout lowerLimit upperLimit] = lowess(datain,f,wantplot,imagefile)
    
    % start timer
    start = tic;
    
    if exist('wantplot','var') == 0 || wantplot == 0
        % user didn't provide assume zero (i.e. no plot)
        fprintf('\nNo plot will be created.\n');
        wantplot = 0;
        imagefile = '';
        limits = 1;
        upperLimit = nan;
        lowerLimit = nan;
    else
        limits = 3;
    end
    if exist('imagefile','var') == 0
        % User didn't provide do not export to graphics file
        fprintf('\nNo plot will be exported.\n');
        imagefile = '';
    end
    dataout = [];
    
    for nplots=1:limits
        % if limits is turned on, then plot the upper and lower limits of
        % the lowess- set to plot residuals lowess
        row = find(datain(:,1));
        x = datain(row,1);
        y = datain(row,2);
        
        switch nplots
            case 2
                row = lwsResiduals > 0;
                x = dataout(row,1);
                y = lwsResiduals(row);
            case 3
                row = lwsResiduals < 0;
                x = dataout(row,1);
                y = lwsResiduals(row);
        end
        
        n = length(x);
        
        if (f <= 0.0)
            f=0.25; % set to default
        end
        
        m=fix(n*f+0.5);
        window = zeros(n,1);
        yhat = zeros(n,1);
        
        for j=1:n
            % This could be done in a matrix, but need to keep memory footprint
            % small, thus the loop.
            d = abs(x- x(j));
            r1 = ones(n,1);
            d = sort(d);
            
            window(j)=d(m);
            yhat(j)= rwlreg(x,y,n,window(j),r1,x(j));
        end
        
        for it=1:2
            e = abs(y-yhat);
            
            n = length(e);
            s=median(e);
            
            r = e/(6*s);
            r = 1-r.^2;
            r = max(0.d0,r);
            r = r.^2;
            
            for j=1:n
                yhat(j)= rwlreg(x,y,n,window(j),r,x(j));
            end
        end
        
        switch nplots
            case 1
                % calculate residuals otherwise skip
                lwsResiduals = y - yhat;
                dataout = [x y yhat];
            case 2
                ul = [x y yhat];
                [c, ia, ib] = intersect(dataout(:,1),ul(:,1));
                upperLimit = [ul(ib,1) ul(ib,3) + dataout(ia,3)];
                clear ul c ia ib
            case 3
                ll = [x y yhat];
                [c, ia, ib] = intersect(dataout(:,1),ll(:,1));
                lowerLimit = [ll(ib,1) ll(ib,3) + dataout(ia,3)];
                clear ul c ia ib
        end
    end
    
    fprintf('\nCompute time %6.4f seconds.\n',toc(start));
    if wantplot ~= 0
        customplot(dataout,upperLimit,lowerLimit,f,imagefile);
    end
end

function [yy] = rwlreg(x,y,n,d,r,xx)
    % Modification of check for 10 or more non-zero weights by Hirsch June
    % 1987.
    %
    % Robust weighted least squares regression, bisquare weights by
    %         distance on X-axis.
    %   x = is the estimation point
    %   yy = is the estimate value of y at x
    %   dd = is half the width of the window
    %   r = is the robustness weight, a bisquare weight of residuals.
    dd=d;
    ddmax = abs(x(n) - x(1));
    if dd == 0.0
        error('Regression:lowess','LOWESS window size = 0. Increase f.');
    else
        while dd <= ddmax
            c = 0;
            total = 0.0;
            f = (abs(x-xx)/dd);
            f = 1.0-f.^3;
            %weight = ((max(0.d0,f)).^3);
            w = ((max(0.d0,f)).^3).*r;
            total = sum(w);
            c = sum(w>0);
            if c > 3
                break % out of while loop
            else
                dd=1.28*dd;
                fprintf('\nrwlreg size of window (c) = %5.0f.\nLowess window size increased to %3.2f\n', c, dd);
            end
        end
    end
    
    w = w/total;
    
    [a b] = wlsq(x,y,w);
    yy=a+b*xx;
end

function[a b] = wlsq(x,y,w)
    % Weighted least squares- this subfunction does not require any
    % toolboxes in matlab to execute.
    sumw = abs(1-sum(w));
    if sumw > 1e-10
        % The weights, w, must sum to one. Precision assuming type double,
        %    The user may want to adjust this value.
        error('Regression:wlsq','\nThere is an error in the weights.\nWeights do not equal zero (%10.9f).\n',sumw);
    end
    wxx = sum(w.*x.^2);
    wx = sum(w.*x);
    wxy = sum(w.*x.*y);
    wy = sum(w.*y);
    b = (wxy-wy*wx)/(wxx-wx^2);
    a = wy-b*wx;
end

function customplot(lws,uplmt,lwrlmt,f,imgfile)
    % Plotting of data and lowess regression line
    try
        x = lws(:,1);
        y = lws(:,2);
        yh = lws(:,3);
        plot(x,y,'d');
        hold on
        plot(x,yh, 'r-', 'LineWidth',2);
        
        x = uplmt(:,1);
        yh = uplmt(:,2);
        plot(x,yh, 'r:', 'LineWidth',2);
        
        x = lwrlmt(:,1);
        yh = lwrlmt(:,2);
        plot(x,yh, 'r:', 'LineWidth',2);
        
        grid on
        xlabel('x-values')
        ylabel('y-values')
        ts = strcat('LOWESS Regression plot f=',num2str(f));
        title(ts)
        hold off
        if ~isempty(imgfile)
            fprintf('\nCreating plot. Give a few tics.\n');
            print('-dpng','-r600', imgfile);
            fprintf('\nFinished...\n');
        end
    catch ME1
        disp(ME1)
    end
end