function varargout = gui(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in reverb.
function reverb_Callback(hObject, eventdata, handles)
global reverb;
 reverb = get(hObject,'Value');
 

% --- Executes on button press in harmonik.
function harmonik_Callback(hObject, eventdata, handles)
global harmonik;
 harmonik = get(hObject,'Value');

% --- Executes on button press in harmoniksiz.
function harmoniksiz_Callback(hObject, eventdata, handles)
global harmoniksiz;
 harmoniksiz = get(hObject,'Value');

% --- Executes on button press in browser.
function browser_Callback(hObject, eventdata, handles)
[filename pathname] = uigetfile({'*.musicxml'},'File Selector');
fullpathname = strcat(pathname , filename);
global text;
text = fullpathname;
set(handles.tt,'String',fullpathname);



% --- Executes during object creation, after setting all properties.
function pop_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in pop.
function pop_Callback(hObject, eventdata, handles)


contents = cellstr(get(hObject,'String'));
choix   = contents{get(hObject,'Value')};

global choice;
if(strcmp(choix,'EXPO'))
     choice = 1;
else
     choice = 2;
end


function sayi_Callback(hObject, eventdata, handles)
global sayi ;
  sayi = str2double(get(hObject,'String'));
 

% --- Executes during object creation, after setting all properties.
function sayi_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function sentezleme_Callback(hObject, eventdata, handles)

global text;
global sayi;
global harmonik;
global harmoniksiz;
global reverb;
global choice;

[timeX signalX revSigX FsX] = sentez(text,choice,sayi);



axes(handles.axes1);
plot(timeX,signalX);
legend('Signal');

axes(handles.axes2);
plot(timeX,revSigX);
legend('Signal','Signal','Reverb');
soundsc(revSigX,FsX);

if( (harmonik==1 && harmoniksiz==1) && reverb==1)
    [timeY1 signalY1 revSigY1] = olculuk(text,choice,sayi);
    [timeY2 signalY2 revSigY2] = olculuk(text,choice,1);
   
    axes(handles.axes3);
    plot(timeY1,signalY1,timeY2,signalY2,timeY1,revSigY1);
    legend('Harmonik','Harmoniksiz','Signal','Reverb');
    
elseif(harmonik==1 && harmoniksiz==1 && reverb == 0)
    [timeY1 signalY1 revSigY1] = olculuk(text,choice,sayi);
    [timeY2 signalY2 revSigY2] = olculuk(text,choice,1);
   
    axes(handles.axes3);
    plot(timeY1,signalY1,timeY2,signalY2);
    legend('Harmonik','Harmoniksiz');
elseif(harmonik==1 && harmoniksiz==0 && reverb == 1)
    
   [timeY1 signalY1 revSigY1] = olculuk(text,choice,sayi);
    
    axes(handles.axes3);
    plot(timeY1,signalY1,timeY1,revSigY1);
    legend('Harmonik','Signal','Reverb');
elseif(harmonik==1 && harmoniksiz==0 && reverb == 0)
    [timeY1 signalY1 revSigY1] = olculuk(text,choice,sayi);    
    axes(handles.axes3);
    plot(timeY1,signalY1);
    legend('Harmonik');
    
elseif(harmonik==0 && harmoniksiz==1 && reverb == 1)
    [timeY1 signalY1 revSigY1] = olculuk(text,choice,sayi);
    [timeY2 signalY2 revSigY2] = olculuk(text,choice,1);
   
    axes(handles.axes3);
    plot(timeY2,signalY2,timeY1,revSigY1);
    legend('Harmoniksiz','Signal','Reverb');
    
 elseif(harmonik==0 && harmoniksiz==0 && reverb == 1)
    [timeY1 signalY1 revSigY1] = olculuk(text,choice,sayi);
   
    axes(handles.axes3);
    plot(timeY1,revSigY1);
    legend('Signal','Reverb');
 elseif(harmonik==0 && harmoniksiz==1 && reverb==0)

    [timeY2 signalY2 revSigY2] = olculuk(text,choice,1);
   
    axes(handles.axes3);
    plot(timeY2,signalY2);
    legend('Harmoniksiz');
end
 
    
function close_Callback(hObject, eventdata, handles)
clc;
clearStr = 'clear all';
evalin('base',clearStr);
%delete(handles.gui);
closereq();


% --- Executes during object creation, after setting all properties.
function tt_CreateFcn(hObject, eventdata, handles)
