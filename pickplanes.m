function varargout = pickplanes(varargin)
% PICKPLANES MATLAB code for pickplanes.fig
%      PICKPLANES, by itself, creates a new PICKPLANES or raises the existing
%      singleton*.
%
%      H = PICKPLANES returns the handle to a new PICKPLANES or the handle to
%      the existing singleton*.
%
%      PICKPLANES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PICKPLANES.M with the given input arguments.
%
%      PICKPLANES('Property','Value',...) creates a new PICKPLANES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pickplanes_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pickplanes_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pickplanes

% Last Modified by GUIDE v2.5 02-Jul-2013 20:01:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pickplanes_OpeningFcn, ...
                   'gui_OutputFcn',  @pickplanes_OutputFcn, ...
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

% --- Executes just before pickplanes is made visible.
function pickplanes_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pickplanes (see VARARGIN)

% Choose default command line output for pickplanes
handles.output = hObject;
[handles.FileName,handles.PathName,handles.FilterIndex] = uigetfile('*.stl','Select an STL mesh to split');
[handles.K,handles.P]=stlread([handles.PathName,handles.FileName]);
handles.clicked=false;
% Update handles structure
% This sets up the initial plot - only do when we are invisible
% so window can get raised using pickplanes.
if strcmp(get(hObject,'Visible'),'off')
    eztrisurf(handles.axes1,handles.K,handles.P);
end
guidata(hObject, handles);


% UIWAIT makes pickplanes wait for user respendonse (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pickplanes_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)

% --- Executes on button press in SideSelectButton.
function SideSelectButton_Callback(hObject, eventdata, handles)
% hObject    handle to SideSelectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SideSelectButton
if get(hObject,'Value')
    set(hObject,'String','Right Side');
else
    set(hObject,'String','Left Side');
end

% --- Executes on button press in updatemode.
function updatemode_Callback(hObject, eventdata, handles)
% hObject    handle to updatemode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of updatemode


% --- Executes on selection change in plane.
function plane_Callback(hObject, eventdata, handles)
% hObject    handle to plane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns plane contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plane


% --- Executes during object creation, after setting all properties.
function plane_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rotate3d


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function eztrisurf(ax,K,P,alpha,col)
if ~exist('alpha','var')
    alpha=1;
end
if ~exist('col','var')
    col=[.5,.5,.5];
end
    trisurf(K,P(:,1),P(:,2),P(:,3),'FaceAlpha',alpha,'Parent',ax,'FaceColor',col);
    axis equal


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pt=select3d(handles.axes1);
ax_range=axis();
if ~isempty(pt) && ~handles.clicked  
    ind=4-get(handles.plane,'Value');
    side=get(handles.SideSelectButton,'Value');
    tol=str2num(get(handles.edit1,'String'));
    [Pl,Kl,Pr,Kr]=splitCloud(handles.P,handles.K,pt,ind,tol);
    [az,el]=view;
    eztrisurf(handles.axes1,Kl,handles.P,1,[.8,.2,.2]);
    hold on
    eztrisurf(handles.axes1,Kr,handles.P,1,[.2,.2,.8]);
    
    Kconvl=convhull(Pl);
    Kconvr=convhull(Pr);
    eztrisurf(handles.axes1,Kconvl,Pl,.5,[.8,.2,.2]);
    eztrisurf(handles.axes1,Kconvr,Pr,.5,[.2,.2,.8]);
    hold off
    handles.clicked=~handles.clicked;
    view(az,el)
    axis(ax_range)
    xlabel('X')
    ylabel('Y')
    handles.pt=pt;
    handles.Kl=Kl;
    handles.Kr=Kr;
    handles.Pl=Pl;
    handles.Pr=Pr;
elseif handles.clicked && ~isempty(pt)
    handles.clicked=~handles.clicked;
    [az,el]=view;
    eztrisurf(handles.axes1,handles.K,handles.P);
    view(az,el)
    axis(ax_range)
end

guidata(hObject,handles)

function [Pleft,Kleft,Pright,Kright]=splitCloud(P,K,point,ind,tol)

    Pleft=P(P(:,ind)>point(ind),:);
    Kleft=K(sum(reshape(P(K,ind)>=point(ind)-tol,[],3),2)==3,:);

    Pright=P(P(:,ind)<point(ind),:);
    Kright=K(sum(reshape(P(K,ind)<=point(ind)+tol,[],3),2)==3,:);

    

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveButton.
function SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cloud2stl(['l_',handles.FileName],handles.P,handles.Kl,'binary');
cloud2stl(['r_',handles.FileName],handles.P,handles.Kr,'binary');


% --- Executes on button press in LoadButton.
function LoadButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.FileName,handles.PathName,handles.FilterIndex] = uigetfile('*.stl','Select an STL mesh to split');
[handles.K,handles.P]=stlread([handles.PathName,handles.FileName]);
guidata(hObject,handles);