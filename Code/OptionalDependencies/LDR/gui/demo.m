function varargout = demo(varargin)
% =================Begin initialization code - DO NOT EDIT==========
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @demo_OpeningFcn, ...
                   'gui_OutputFcn',  @demo_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end
    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end

% =================End initialization code - DO NOT EDIT============

% ------------ Executes just before demo is made visible.
function demo_OpeningFcn(hObject, eventdata, handles, varargin)
    handles = guihandles(hObject);
    handles.dataselected = false;
    handles.saveready = false;
    handles.model  = 'LAD';
    handles.morph  = 'disc';
    handles.labelplot = true;
    handles.showresults = 0;
    handles.u = 3;
    handles.h = 10;
    handles.polyorder = 2;
    handles.vertaxis = '==vertical axis==';
    handles.hor1axis = '=horizontal axis1=';
    handles.hor2axis = '=horizontal axis2=';
    handles.testedmodels = [];
    handles.optargs = [];
    handles.X = [];
    handles.Y = [];
    setpaths;
    load_model_list(handles);
    handles.output = hObject;
    guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = demo_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;


% ================= CONTROLS FOR POPUPS MENUS ======================

function popupMODEL_Callback(hObject, eventdata, handles)
    val = get(hObject,'Value');
    str = get(hObject,'String');
    model = str{val};
    handles.model = model;
    list = findmethods(model);
    set(handles.popupDIM,'String',list);
    prevent_DIMcrash(handles);
    CHANGE_DISPLAY(handles);
    SHOW_MESSAGE_MODEL_CHANGE(handles);
    handles.output = hObject;
    guidata(hObject,handles);

%--------------------------------------------------------------------------
function CHANGE_DISPLAY(handles)
% sets edit box' caption according to the selected model..............
if strcmpi(handles.model,'PFC')||strcmpi(handles.model,'IPFC')||strcmpi(handles.model,'EPFC')||strcmpi(handles.model,'SPFC'),
    set(handles.textENTERh,'String','Enter r');
    set(handles.edit_h,'String',int2str(3));
else
    set(handles.textENTERh,'String','Enter h');
    set(handles.edit_h,'String',int2str(5));    
end
disp(['    Model changed to ' handles.model]);

%--------------------------------------------------------------------------    
function SHOW_MESSAGE_MODEL_CHANGE(handles)
    % displays info........let's implement an aux function INFO(handles,text)?
    set(handles.textINFO,'String',['Ready to process data with ' handles.model ' model.']); drawnow;
    if strcmpi(handles.model,'PFC'),
        set(handles.textINFO,'String','PFC models selected. Selected dimension should be less than the number of populations in data.');
    end
    if strcmpi(handles.model,'IPFC'),
        set(handles.textINFO,'String','IPFC models selected. Selected dimension should be less than the number of populations in data.');
    end
    if strcmpi(handles.model,'SPFC'),
        set(handles.textINFO,'String','SPFC models selected. Selected dimension should be less than the number of populations in data.');
    end

%--------------------------------------------------------------------------
function popupMODEL_CreateFcn(hObject, eventdata, handles)
%     if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%         set(hObject,'BackgroundColor','white');
%     end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    

function popupMORPH_Callback(hObject, eventdata, handles)
    val = get(hObject,'Value');
    str = get(hObject,'String');
    strval = str{val};
    if strcmp(strval,'continuous'),
        handles.morph = 'cont';
        handles.labelplot = false;
        set(handles.edit_h,'Enable','on');
        set(handles.textENTERh, 'Enable','on');
        set(handles.textINFO,'String', strcat(upper(strval),...
        ' response selected. Enter a number of slices for discretization.'));
    elseif strcmp(strval,'discrete'),
        handles.morph = 'disc';
        handles.labelplot = true;
        set(handles.edit_h,'Enable','off');
        set(handles.textENTERh, 'Enable','off');
        set(handles.textINFO,'String', strcat(upper(strval),' response selected.'));
        set(handles.pushSCATTER,'Enable','on');
        set(handles.pushUP,'Enable','off');
    else
        error('Unknown argument...')
    end
    handles.output = hObject;
    guidata(hObject,handles);

%--------------------------------------------------------------------------    
function popupMORPH_CreateFcn(hObject, eventdata, handles)
%     if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%         set(hObject,'BackgroundColor','white');
%     end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function popupDIM_Callback(hObject, eventdata, handles)
    val = get(hObject,'Value');
    str = get(hObject,'String');
    strval = str{val};
    switch strval,
        case 'fixed d=1',
            handles.u = 1;
            set(handles.textINFO,'String',['Ready to look for a reduced subspace of dimension ' int2str(1)]);        
        case 'fixed d=2',
            handles.u = 2;
            set(handles.textINFO,'String',['Ready to look for a reduced subspace of dimension ' int2str(2)]);
        case 'fixed d=3',
            handles.u = 3;
            set(handles.textINFO,'String',['Ready to look for a reduced subspace of dimension ' int2str(3)]);        
        case 'estimate using AIC',
            handles.u = 'aic';
            set(handles.textINFO,'String','Ready to look for a reduced subspace with dimension estimated by Akaike information criterion');        
        case 'estimate using BIC',
            handles.u = 'bic';
            set(handles.textINFO,'String','Ready to look for a reduced subspace with dimension estimated by Bayes information criterion');        
        case 'estimate using LRT',
            handles.u = 'lrt';
            set(handles.textINFO,'String','Ready to look for a reduced subspace with dimension estimated by likelihood-ratio test');        
        case 'estimate using PERM',
            handles.u = 'perm';
            set(handles.textINFO,'String','Ready to look for a reduced subspace with dimension estimated by permutation test');        
        otherwise
            error('UNKNOWN SELECTION');
    end
    handles.output = hObject;
    guidata(hObject,handles);

function popupDIM_CreateFcn(hObject, eventdata, handles)
%     if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%         set(hObject,'BackgroundColor','white');
%     end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function popupVERTPLOT_Callback(hObject, eventdata, handles)
    list_entries = cellstr(get(hObject,'String'));
    index_selected = get(hObject,'Value');
    handles.vertaxis = list_entries{index_selected};
    ready = check_axes(handles);
    if ready,
        change_plot(handles);
    end
    handles.output = hObject;
    guidata(hObject,handles);
    
function popupVERTPLOT_CreateFcn(hObject, eventdata, handles)
%     if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%         set(hObject,'BackgroundColor','white');
%     end

    
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function popupHORPLOT1_Callback(hObject, eventdata, handles)
    list_entries = cellstr(get(hObject,'String'));
    index_selected = get(hObject,'Value');
    handles.hor1axis = list_entries{index_selected};
    ready = check_axes(handles);
    if ready,
        change_plot(handles);
    end
    handles.output = hObject;
    guidata(hObject,handles);
    
function popupHORPLOT1_CreateFcn(hObject, eventdata, handles)
%     if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%         set(hObject,'BackgroundColor','white');
%     end


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function popupHORPLOT2_Callback(hObject, eventdata, handles)
    list_entries = cellstr(get(hObject,'String'));
    index_selected = get(hObject,'Value');
    handles.hor2axis = list_entries{index_selected};
    ready = check_axes(handles);
    if ready,
        change_plot(handles);
    end
    handles.output = hObject;
    guidata(hObject,handles);
    
function popupHORPLOT2_CreateFcn(hObject, eventdata, handles)
%     if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%         set(hObject,'BackgroundColor','white');
%     end



% ================== CONTROLS FOR PUSH BUTTONS ====================

function pushDATA_Callback(hObject, eventdata, handles)
    cla; drawnow;
    [datafile, datapath] = uigetfile( '*.txt', ...
                'Select a data file to load' );
    set(handles.textINFO,'String',...
                ['DATA at ' datafile ' file have been loaded.']);
    [handles.DATA,handles.header,handles.colheader] = loadDATA4gui(strcat(datapath,datafile));
    handles.datafile = datafile;
    handles.response_selected = false;
    handles.predictors_selected = false;
    

    %---------------------------------------------------------
    p = size(handles.DATA,2)-1;
    handles.p = p;
    set(handles.listbox3,'Max',p);
    set(handles.listbox3,'Value',1:p);
    update_listbox(handles);
    %---------------------------------------------------------
    set(handles.popupVERTPLOT,'Value',1);
    set(handles.popupHORPLOT1,'Value',1);
    set(handles.popupHORPLOT2,'Value',1);
    update_PLOT_AXES(handles,handles.popupVERTPLOT,'DATA');
    update_PLOT_AXES(handles,handles.popupHORPLOT1,'DATA');
    update_PLOT_AXES(handles,handles.popupHORPLOT2,'DATA');
    
    if ~isempty(handles.colheader),
        for k=1:(p+1),
            eval(strcat('handles.',handles.colheader{k},'= handles.DATA(:,k);'));
        end
    else
        handles.Y = handles.DATA(:,1); 
        for k=1:p,
            eval(strcat('handles.X',int2str(k),'= handles.DATA(:,k+1);'));
        end
    end
    set(handles.pushRUN,'Enable','on');
    set(handles.pushSCATTER,'Enable','on');
    set(handles.pushbutton9,'Enable','on');
    set(handles.pushbutton10,'Enable','on');
    set(handles.edit_h,'Enable','on');
    handles.output = hObject;
    guidata(hObject,handles);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function pushRUN_Callback(hObject, eventdata, handles)
            % MESSAGES AND GUI UPDATE
            set(handles.pushRUN,'String','PLEASE WAIT');
            cla;
            drawnow;
            
            % ACTION
            % perform computations
            [WX,W,dim] = COMPUTE_SUBSPACE(handles);
            % show output in command window
            if handles.showresults,
                disp('Generating vectors for the reduced subspace: ');
                disp(W);
                disp('Coordinates on the reduced subspace:');
                disp(WX);
                disp(['Dimension of the estimated subspace: ' int2str(dim)])
            end
            plotDR(WX,handles.Y,handles.morph,handles.model);

            % MESSAGES AND GUI UPDATE            
            current_test = [handles.model,'_',int2str(dim)];
            testedmodels = handles.testedmodels;
            testedmodels = strvcat(testedmodels,current_test);
            handles.testedmodels = testedmodels;
            set(handles.listboxRESULTS,'String',cellstr(testedmodels));
            set(handles.listboxRESULTS,'Max',size(testedmodels,1));
            handles.WX = WX;
            handles.W = W;
            for k=1:dim,
                if ~exist(strcat('handles.',handles.model,int2str(k)),'var'),
                    update_PLOT_AXES(handles,handles.popupVERTPLOT,strcat(handles.model,int2str(k)));
                    update_PLOT_AXES(handles,handles.popupHORPLOT1,strcat(handles.model,int2str(k)));
                    update_PLOT_AXES(handles,handles.popupHORPLOT2,strcat(handles.model,int2str(k)));
                end
                eval(strcat('handles.',handles.model,int2str(k),' = WX(:,k);'));
            end
            eval(strcat('handles.',current_test,' = [handles.Y WX];'));
            eval(strcat('handles.',current_test,'_W = W;'));
            set(handles.pushRUN,'String','RUN');
            enable_PUSHRUNbtn(handles);
            set(handles.popupVERTPLOT,'Value',1);
            set(handles.popupHORPLOT1,'Value',1);
            set(handles.popupHORPLOT2,'Value',1);
            handles.output = hObject;
            guidata(hObject,handles);



%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
function pushSAVE_Callback(hObject, eventdata, handles)
    saveready = handles.saveready;
    if ~saveready,
        % ACTION: toggle flag and display experiments to save
        handles.saveready = true;
        set(handles.listboxRESULTS,'Visible','on');        
        % MESSAGE AND GUI UPDATE
        set(handles.pushSAVE,'String', 'PRESS again');
        disable_PUSHSAVEbtn(handles);        
    else
        % ACTION: toggle flag
        handles.saveready = false;
        save_results(handles);
        % MESSAGE AND GUI UPDATE
        set(handles.listboxRESULTS,'Visible','off');
        drawnow;
        enable_PUSHSAVEbtn(handles);        
        set(handles.pushSAVE,'String', 'SAVE results');
    end
    handles.output = hObject;
    guidata(hObject,handles);


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
function pushUP_Callback(hObject, eventdata, handles)
    X = handles.DATA(:,2:end);
    Y = handles.DATA(:,1);
    p = handles.p;
    currentsp = handles.currentsp;
    if currentsp<p,
       currentsp = currentsp+1;
    else
        currentsp = 1;
    end
    colheaderc = handles.colheader{currentsp};
    Xc = eval(strcat('handles.',colheaderc,';'));
    morph = handles.morph;
    gca; hold off; 
    if ~strcmp(handles.vertaxis,'==vertical axis=='),
        Xvert = get_var_data(handles.vertaxis,handles);
        if strcmpi(morph,'cont'),
            updatePLOT(Xc,Xvert(:));
        else
            updatePLOT(Xc,Xvert(:),Y);            
        end
        xlabel(colheaderc);
        ylabel(handles.vertaxis);
        set(handles.textINFO,'String',['Displaying scatter plot for ' handles.vertaxis ' vs ' colheaderc]);        
    elseif ~strcmp(handles.hor1axis,'=horizontal axis1='), 
        Xhor = get_var_data(handles.hor1axis,handles);
        if strcmpi(morph,'cont'),
            updatePLOT(Xhor(:),X(:,currentsp));
        else
            updatePLOT(Xhor(:),X(:,currentsp),Y);            
        end
        ylabel(colheaderc);
        xlabel(handles.hor1axis);
        set(handles.textINFO,'String',['Displaying scatter plot for ' colheaderc ' vs ' handles.hor1axis]);        
    end
    set(gca,'xtick',[],'ytick',[]);
    handles.currentsp = currentsp;
    handles.output = hObject;
    guidata(hObject,handles);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function pushDOWN_Callback(hObject, eventdata, handles)
    X = handles.DATA(:,2:end);
    Y = handles.DATA(:,1);
    p = size(X,2);
    currentsp = handles.currentsp;
    if currentsp>1,
       currentsp = currentsp-1;
    else
       currentsp = p;
    end
    colheaderc = handles.colheader{currentsp};
    Xc = eval(strcat('handles.',colheaderc,';'));
    morph = handles.morph;
    gca; hold off; 

    if ~strcmp(handles.vertaxis,'==vertical axis=='),
        Xvert = get_var_data(handles.vertaxis,handles);
        if strcmpi(morph,'cont'),
            updatePLOT(Xc,Xvert(:));
        else
            updatePLOT(Xc,Xvert(:),Y);            
        end
        xlabel(colheaderc);
        ylabel(handles.vertaxis);
        set(handles.textINFO,'String',['Displaying scatter plot for ' handles.vertaxis ' vs ' colheaderc]);        
    elseif ~strcmp(handles.hor1axis,'=horizontal axis1='), 
        Xhor = get_var_data(handles.hor1axis,handles);
        if strcmpi(morph,'cont'),
            updatePLOT(Xhor(:),Xc);            
        else
            updatePLOT(Xhor(:),Xc,Y);            
        end
        ylabel(colheaderc);
        xlabel(handles.hor1axis);
        set(handles.textINFO,'String',['Displaying scatter plot for ' colheaderc ' vs ' handles.hor1axis]);        
    end
    set(gca,'xtick',[],'ytick',[]);
 
    handles.currentsp = currentsp;
    handles.output = hObject;
    guidata(hObject,handles);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function pushSCATTER_Callback(hObject, eventdata, handles)
    Y = handles.DATA(:,1);
    X = handles.DATA(:,2:end);
    if ~strcmp(handles.vertaxis,'==vertical axis=='),
        Xvert = get_var_data(handles.vertaxis,handles);
        handles.currentsp = 1;
        morph = handles.morph;
        gca; hold off; 
        colheaderc = handles.colheader{handles.currentsp};
        Xc = eval(['handles.',colheaderc,';']);
        if strcmpi(morph,'cont'),
            updatePLOT(Xc,Xvert(:));
        else
            updatePLOT(Xc,Xvert(:),Y);
        end
        xlabel(colheaderc);
        ylabel(handles.vertaxis);
        set(gca,'xtick',[],'ytick',[]);
        set(handles.pushUP,'Enable','on');
        set(handles.pushDOWN,'Enable','on');
        set(handles.textINFO,'String',['Displaying scatter plot for ' handles.vertaxis ' vs ' colheaderc ...
            '. Press UP or DOWN buttons to see scatter for other coordinates']);
        handles.output = hObject;
        guidata(hObject,handles);
    elseif ~strcmp(handles.hor1axis,'=horizontal axis1='),
        Xhor = get_var_data(handles.hor1axis,handles);
        handles.currentsp = 1;
        morph = handles.morph;
        gca; hold off; 
        colheaderc = handles.colheader{handles.currentsp};
        Xc = eval(['handles.',colheaderc,';']);
        if strcmpi(morph,'cont'),
            updatePLOT(Xhor(:),Xc);
        else
            updatePLOT(Xhor(:),Xc,Y);
        end
        ylabel(colheaderc);
        xlabel(handles.hor1axis);
        set(gca,'xtick',[],'ytick',[]);
        set(handles.pushUP,'Enable','on');
        set(handles.pushDOWN,'Enable','on');
        set(handles.textINFO,'String',['Displaying scatter plot for X-' int2str(handles.currentsp) ' vs ' handles.hor1axis...
        '. Press UP or DOWN buttons to see scatter for other coordinates']);
        handles.output = hObject;
        guidata(hObject,handles);
    else
        set(handles.textINFO,'String','Choose a variable for vertical axis and try again');
    end
    handles.output = hObject;
    guidata(hObject,handles);

    
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function pushRESETPOPUP_Callback(hObject, eventdata, handles)
    update_PLOT_AXES(handles,handles.popupVERTPLOT,'DATA');
    update_PLOT_AXES(handles,handles.popupHORPLOT1,'DATA');
    update_PLOT_AXES(handles,handles.popupHORPLOT2,'DATA');
    handles.testedmodels = [];
    set(handles.listboxRESULTS,'String',[]);
    set(handles.listboxRESULTS,'Value',0);
    set(handles.textINFO,'String','Results have been cleared');
    handles.output = hObject;
    guidata(hObject,handles);


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
function listbox3_Callback(hObject, eventdata, handles)

function listbox3_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function edit_h_Callback(hObject, eventdata, handles)
    model = handles.model;
    if strcmp(model,'PFC')||strcmp(model,'IPFC')||strcmp(model,'SPFC')||strcmp(model,'SEPFC'),
        handles.polyorder = str2double(get(hObject,'String'));
        FF = get_fy(handles.Y,handles.polyorder,'sqr');
        handles.optargs = [];
        handles.optargs{1} = 'fy';
        handles.optargs{2} = FF;
    elseif strcmp(model,'LAD')||strcmp(model,'CORE')||strcmp(model,'SIR')||strcmp(model,'SAVE')||strcmp(model,'DR')
        handles.h = str2double(get(hObject,'String'));
        handles.optargs = [];
        handles.optargs{1} = 'nslices';
        handles.optargs{2} = handles.h;
    end
    set(hObject,'BackgroundColor','white');
    handles.output = hObject;
    guidata(hObject,handles);

function edit_h_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function update_PLOT_AXES(handles,tag,var)
    vars = get(tag,'String');
    if strcmp(var,'DATA'),
        vars(2:end,:) = [];
        switch tag
            case 'handles.popupVERTPLOT',
                set(handles.popupVERTPLOT,'String','==vertical axis==');
            case 'handles.popupHORPLOT1',
                set(handles.popupHORPLOT1,'String','=horizontal axis1=');
            case 'handles.popupHORPLOT2',
                set(handles.popupHORPLOT1,'String','=horizontal axis2=');
        end
        colheader = handles.colheader;
        for k=1:(handles.p+1),
            vars = strvcat(vars,colheader{k});
        end
    else
         vars = strvcat(vars,var);
    end
    set(tag,'String',vars);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function update_listbox(handles)
    if ~isempty(handles.colheader)
        vars = handles.colheader; %disp(vars);
    else
        vars = cell(handles.p+1,1);
        vars{1} = 'Y';
        for k=2:handles.p+1,
            vars{k} = ['X',int2str(k)];
        end
    end
    set(handles.listbox3,'String',vars);
    set(handles.listbox3,'Value',1);
    
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function vardata = get_var_data(handlesvar,handles)
    var = handlesvar;
    vardata = eval(['handles.',var,';']);
    
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [] = updatePLOT3(x1,x2,x3,labels,handles)
    x1=x1(:);    x2=x2(:);    x3=x3(:);
    if nargin < 3,
        error('Not enough input arguments...');
    end
    gca; hold off;
    if nargin > 3,
        labels = labels + (1-min(labels));
        a = min(labels);        b = max(labels);
        for i=a:b,
            lab = getlabel(i);
            plot3(x1(labels==i),x2(labels==i),x3(labels==i),lab);hold on;
        end
    else
        plot3(x1(:),x2(:),x3(:),'ko');hold on;
    end
    view(-37.5,30);
    xlabel(handles.hor1axis);    
    ylabel(handles.hor2axis);    
    zlabel(handles.vertaxis);
    set(gca,'xtick',[],'ytick',[],'ztick',[]);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [ ] = updatePLOT(x1,x2,labels)
    if nargin < 2,
        error('Not enough input arguments...');
    end
    gca; hold off;
    if nargin > 2,
        labels = labels + (1-min(labels));
        a = min(labels);        b = max(labels);
        for i=a:b,
            lab = getlabel(i);
            plot(x1(labels==i),x2(labels==i),lab);hold on;
        end
    else
        plot(x1(:),x2(:),'ko');hold on;
    end
    set(gca,'xtick',[],'ytick',[]);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function label = getlabel(idx)
    labels = {'ro','go','bo','ko','r+','b+','g+','k+','r*','b*','g*','k*','y*','yo','y+'};
    label = labels{idx};

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function predictors = get_predictors(handles)
    list_entries = cellstr(get(handles.listbox3,'String'));
    index_selected = get(handles.listbox3,'Value');
    if length(index_selected) < 2
%         error('You must select two variables at least');
disp('a ver que pasa...')
    else
        n = size(handles.DATA,1);
        pred = zeros(n,length(index_selected));
        for k=1:length(index_selected),
            Xk = list_entries{index_selected(k)};
            pred(:,k) = eval(['handles.',Xk,';']);
        end
    end
    predictors = pred;
    

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function resp = get_response(handles)
    list_entries = cellstr(get(handles.listbox3,'String'));
    index_selected = get(handles.listbox3,'Value');
    if length(index_selected) > 1
        error('You must select only one variable as the response');
    else
        aux = list_entries{index_selected};
        resp = eval(['handles.',aux,';']);
    end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
function [] = change_plot(handles)    
    if ~strcmp(handles.vertaxis,'==vertical axis=='),
        vertdata = get_var_data(handles.vertaxis,handles);
    else
        error('You must select a variable for vertical axis');
    end
    if ~strcmp(handles.hor1axis,'=horizontal axis1='),
        hor1data = get_var_data(handles.hor1axis,handles);
    else
        error('You must select a variable for first horizontal axis');
    end
    if ~strcmp(handles.hor2axis,'=horizontal axis2='),
        hor2data = get_var_data(handles.hor2axis,handles);
    else
        hor2data = [];
    end
    labelplot = handles.labelplot;
    if ~isempty(hor2data),
        if labelplot,
            response = handles.DATA(:,1); response = response(:);
            updatePLOT3(hor1data,hor2data,vertdata,response,handles);
        else
            updatePLOT3(hor1data,hor2data,vertdata,handles);
        end
    else
        if labelplot,
            response = handles.DATA(:,1);
            updatePLOT(hor1data,vertdata,response);
            xlabel(handles.hor1axis);
            ylabel(handles.vertaxis);
        else
            updatePLOT(hor1data,vertdata);
            xlabel(handles.hor1axis);
            ylabel(handles.vertaxis);
        end
    end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function ready = check_axes(handles)
    if ~strcmp(handles.vertaxis,'==vertical axis=='),
        vertdata = true;
    else
        vertdata = false;
    end
    if ~strcmp(handles.hor1axis,'=horizontal axis1='),
        hordata = true;
    else
        hordata = false;
    end
    ready = vertdata & hordata;
    
% --------------------------------------------------------------------
function [] = save_results(handles)
    list_testedmodels = cellstr(get(handles.listboxRESULTS,'String'));
    idx_selected = get(handles.listboxRESULTS,'Value');
    for k=1:length(idx_selected),
        current_model = list_testedmodels{idx_selected(k)};
        results = eval(['handles.',current_model,';']);
        W = eval(['handles.',current_model,'_W;']);
        [file,path] = uiputfile([current_model,'-results.txt'],['Save results of ',current_model,' as']);
        if ischar(file) && ischar(path),
            save([path file],'results','-ascii','-double');
        end
        [file,path] = uiputfile([current_model,'-directions.txt'],['Save only directions of ',current_model,' as']);
        if ischar(file) && ischar(path),
            save([path,file],'W','-ascii','-double');
        end
    end

        
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
function listboxRESULTS_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function listboxRESULTS_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --------------------------------------------------------------------
function [] = disable_PUSHRUNbtn(handles)
    set(handles.pushSAVE,'Enable','off');
    set(handles.pushSCATTER,'Enable','off');
    set(handles.pushUP,'Enable','off');      
    set(handles.pushDOWN,'Enable','off');      
    set(handles.pushDATA,'Enable','off');
    set(handles.pushRESETPOPUP,'Enable','off');      
% --------------------------------------------------------------------
function [] = enable_PUSHRUNbtn(handles)
    set(handles.pushSAVE,'Enable','on');
    set(handles.pushSCATTER,'Enable','on');
    set(handles.pushUP,'Enable','on');      
    set(handles.pushDOWN,'Enable','on');      
    set(handles.pushDATA,'Enable','on');
    set(handles.pushRESETPOPUP,'Enable','on');      

% --------------------------------------------------------------------
function [] = disable_PUSHSAVEbtn(handles)
    set(handles.pushRUN,'Enable','off');
    set(handles.pushSCATTER,'Enable','off');
    set(handles.pushUP,'Enable','off');      
    set(handles.pushDOWN,'Enable','off');      
    set(handles.pushDATA,'Enable','off');
    set(handles.pushRESETPOPUP,'Enable','off');      
    
% --------------------------------------------------------------------
function [] = enable_PUSHSAVEbtn(handles)
    set(handles.pushRUN,'Enable','on');
    set(handles.pushSCATTER,'Enable','on');
    set(handles.pushUP,'Enable','on');      
    set(handles.pushDOWN,'Enable','on');      
    set(handles.pushDATA,'Enable','on');
    set(handles.pushRESETPOPUP,'Enable','on');     


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
    handles.showresults = get(hObject,'Value');
    handles.output = hObject;
    guidata(hObject,handles);

%##########################################################################
function prevent_DIMcrash(handles)
    val = get(handles.popupDIM,'Value');
    if val<4,
        set(handles.popupDIM,'Value',val);
        handles.u = 4-val;
    else
        set(handles.popupDIM,'Value',3);
        handles.u = 3;
    end
    drawnow;
    


% --------------------------------------------------------------------
function uitoggletool3_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function [WX,W,dim] = COMPUTE_SUBSPACE(handles)
  X = handles.predictors;
  Y = handles.Y;
  morph = handles.morph;
  model = handles.model;
  criterion = handles.u;
  optargs = handles.optargs;

  if isinLDR(model),
        if~isempty(optargs),
            [WX,W,f,dim] = ldr(Y,X,model,morph,criterion,optargs{:});
        else
            [WX,W,f,dim] = ldr(Y,X,model,morph,criterion);
        end
  else
	dim = handles.u;
    switch upper(model)
        case 'SIR',
            if ~isempty(optargs),
                [WX,W] = SIR(Y,X,morph,dim,optargs{:});
            else
                [WX,W] = SIR(Y,X,morph,dim);
            end
    	case 'SAVE',
            if ~isempty(optargs),
                [WX,W] = SAVE(Y,X,morph,dim,optargs{:});
            else
                [WX,W] = SAVE(Y,X,morph,dim);
            end
    	case 'DR',
            if ~isempty(optargs),
                [WX,W] = DR(Y,X,morph,dim,optargs{:});
            else
                [WX,W] = DR(Y,X,morph,dim);
            end
        case 'PCV'
            [WX,W] = pc(X,dim,'cov');
        case 'PCC',
            [WX,W] = pc(X,dim,'cor');
    	otherwise,
    		error('Unknown model selected');
    end
 end

% --------------------------------------------------------------------
function yorn = isinLDR(model)
% this function looks for the selected model among all likelihood-based
% functions available for running under the LDR function. Please note that
% if a new model is added to run throug LDR, it must be added to the
% models_in_ldr.txt file in order it can be recognized.
if strcmpi(model,'SIR')||strcmpi(model,'SAVE')||strcmpi(model,'DR')||strcmpi(model,'PCC')||strcmpi(model,'PCV')
    yorn = false;
else
    yorn = true;
end


% --------------------------------------------------------------------
function list = findmethods(model)
% this function tries to find automatically all the methods available for a
% given model. It should be noticed that implementation files must be saved
% taking care of the naming conventions used for LDR.
model = upper(model);
aicOK = false; bicOK = false; lrtOK = false; permOK = false;
h = dir(['.' filesep 'models' filesep lower(model) filesep '*.m']);
for line = 2:length(h),
    switch h(line).name
        case ['aic',model,'.m'] 
            aicOK = true;
        case ['bic',model,'.m'] 
            bicOK = true;
        case ['lrt',model,'.m'] 
            lrtOK = true;
        case ['perm',model,'.m'] 
            permOK = true;
    end
end
part_list = cell(7,1);
part_list{1} = 'fixed d=3';
part_list{2} = 'fixed d=2';
part_list{3} = 'fixed d=1';
if aicOK, 
    part_list{4} = 'estimate using AIC';
else
    part_list{4} = 'AIC: not available';
end
if bicOK, 
    part_list{5} = 'estimate using BIC';
else
    part_list{5} = 'BIC: not available';
end
if lrtOK, 
    part_list{6} = 'estimate using LRT';
else
    part_list{6} = 'LRT: not available';
end
if permOK, 
    part_list{7} = 'estimate using PERM';
else
    part_list{7} = 'PERM: not available';
end
list = part_list;


% --------------------------------------------------------------------
function list_models = load_model_list(handles)
list = dir('./models');
list = list(3:end);
list_models = cell(length(list),1);
for k=1:length(list),
    list_models{k}=upper(list(k).name);
end
list_models(strcmpi(list_models,'mlm'))=[];
list_models(strcmpi(list_models,'etc'))=[];
list_models(strcmpi(list_models,'.DS_Store'))=[];
list_models(strcmpi(list_models,'README.TXT'))=[];
list_models{end+1} = '-------------------';
list_models{end+1} = 'SIR';
list_models{end+1} = 'SAVE';
list_models{end+1} = 'DR';
list_models{end+1} = 'PCC';
list_models{end+1} = 'PCV';
val = find(strcmp(list_models,'LAD'));
set(handles.popupMODEL,'String',list_models);
set(handles.popupMODEL,'Value',val);
REFRESH_BKGND(handles,'white');

%--------------------------------------------------------------------------
function [] = REFRESH_BKGND(handles,color)
if nargin < 2,
    color = 'white';
end
set(handles.popupMODEL,'BackgroundColor',color); 
guidata(handles.popupMODEL,handles);
set(handles.popupDIM,'BackgroundColor',color);
guidata(handles.popupDIM,handles);
set(handles.popupMORPH,'BackgroundColor',color);
guidata(handles.popupMORPH,handles);
set(handles.popupVERTPLOT,'BackgroundColor',color);
guidata(handles.popupVERTPLOT,handles);
set(handles.popupHORPLOT1,'BackgroundColor',color);
guidata(handles.popupHORPLOT1,handles);
set(handles.popupHORPLOT2,'BackgroundColor',color);
guidata(handles.popupHORPLOT2,handles);
drawnow;

function [] = gplot1D(WX,Y,model)
h = max(Y);
colores = {'b','r','g','k','y'};
for k=1:h,
    h = findobj(gca,'Type','patch');
    set(h,'FaceColor',colores{k})
    [histo,bins]=hist(WX(Y==k,:));
    bar(bins,histo); hold on;
    xlabel([model,'-1']);
    set(gca,'xtick',[],'ytick',[]);
end
title(['Analysis using ' upper(model) ' model']);
hold off;
    

function pushbutton9_Callback(hObject, eventdata, handles) %% BUTTON SET Y
% ACTION  
% highlight default response variable
if ~handles.response_selected,
    set(handles.listbox3,'Value',1);
    set(handles.listbox3,'Visible','on');
    set(handles.listbox3,'Max',1);
    % MESSAGES
    cla(handles.axes1);
    handles.response_selected = true;
    set(handles.pushbutton9,'String','press again');    
else
    handles.Y = get_response(handles);
    handles.response_selected  = false;
    set(handles.listbox3,'Visible','off');
    set(handles.pushbutton9,'String','set Y');
end
update_PLOT_AXES(handles,handles.popupVERTPLOT,'DATA');
update_PLOT_AXES(handles,handles.popupHORPLOT1,'DATA');
update_PLOT_AXES(handles,handles.popupHORPLOT2,'DATA');
handles.output = hObject;
guidata(hObject,handles);


function pushbutton10_Callback(hObject, eventdata, handles)
% ACTION  
% highlight default response variable
if ~handles.predictors_selected
    set(handles.listbox3,'Max',handles.p);
    set(handles.listbox3,'Value',2:handles.p+1);
    set(handles.listbox3,'Visible','on');     
    set(handles.pushbutton10,'String','press again');
    handles.predictors_selected = true;
else
    handles.predictors = get_predictors(handles);
    set(handles.listbox3,'Visible','off');     
    set(handles.pushbutton10,'String','set X');
    handles.predictors_selected = false;
end
% MESSAGES
cla(handles.axes1);
handles.responseready = false;
handles.output = hObject;
guidata(hObject,handles);


