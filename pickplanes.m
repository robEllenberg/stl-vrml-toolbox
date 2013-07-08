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

% Last Modified by GUIDE v2.5 08-Jul-2013 02:43:20

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
if length(varargin)>=1
    handles.FileName=varargin{1};
    handles.PathName='';
else
    [handles.FileName,handles.PathName,handles.FilterIndex] = uigetfile('*.stl','Select an STL mesh to split');
end
[handles.V,handles.F]=stlread([handles.PathName,handles.FileName],true,true);
handles.V1=handles.V;
handles.V2=[];
handles.F1=handles.F;
handles.F2=[];
mkdir export
% Update handles structure
% This sets up the initial plot - only do when we are invisible
% so window can get raised using pickplanes.

eztrisurf(handles.axes1,handles.F,handles.V);

handles.axis_range=axis();
update_plot(handles);
guidata(hObject, handles);


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

% --- Executes on button press in ShowLeftButton.
function ShowLeftButton_Callback(hObject, eventdata, handles)
% hObject    handle to ShowLeftButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ShowLeftButton
update_plot(handles);

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


% --- Executes on button press in RotateModeButton.
function RotateModeButton_Callback(hObject, eventdata, handles)
% hObject    handle to RotateModeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
get(hObject,'Value')
if get(hObject,'Value')==0
    rotate3d off
else
    rotate3d on
end

% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function eztrisurf(ax,faces,vertices,alpha,col)
if ~exist('alpha','var')
    alpha=1;
end
if ~exist('col','var')
    col=[.5,.5,.5];
end
trisurf(faces,vertices(:,1),vertices(:,2),vertices(:,3),...
    'FaceAlpha',alpha,'Parent',ax,'FaceColor',col);

axis equal




% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pt=select3d(handles.axes1);

if ~isempty(pt)
    handles.pt=pt;
    newSplitPoint(hObject,handles);
end

function newSplitPoint(hObject,handles)
%%Based on the latest selection point, re-slice the model
ind=4-get(handles.plane,'Value');
side=get(handles.SideButton,'Value');
tol=str2double(get(handles.edit1,'String'));
[handles.V1,handles.F1,handles.V2,handles.F2]=splitModel(handles.V,handles.F,handles.pt,ind,tol,side);

% handles.F1=F1;
% handles.F2=F2;
% handles.V1=V1;
% handles.V2=V2;

update_plot(handles)
guidata(hObject,handles)
    
function update_plot(handles)

[az,el]=view;
cla;
%eztrisurf(handles.axes1,handles.F,handles.V,1,[.5,.5,.5]);

showleft=get(handles.ShowLeftButton,'Value');
showright=get(handles.ShowRightButton,'Value');

hold on
if showleft && ~isempty(handles.F1)
    F_conv1=convhull(handles.V1);
    eztrisurf(handles.axes1,handles.F1,handles.V1,1,[.7,.2,.2]);
    eztrisurf(handles.axes1,F_conv1,handles.V1,.5,[.9,.2,.2]);
end

if showright && ~isempty(handles.F2)
    F_conv2=convhull(handles.V2);
    eztrisurf(handles.axes1,handles.F2,handles.V2,1,[.2,.2,.7]);
    eztrisurf(handles.axes1,F_conv2,handles.V2,.5,[.2,.2,.9]);
end

hold off

view(az,el)
axis(handles.axis_range)
xlabel('X')
ylabel('Y')
zlabel('Z')
title(handles.FileName,'Interpreter', 'none')

function [V1,F1,V2,F2]=splitModel(V,F,point,ind,tol,side)
%Split vertices and faces at the cut plane, fuzzifying by a tolerance
%to include points just above / just below the plane
% V = vertices
% F = faces

%Vcut1=V(V(:,ind)>=point(ind),:);
if ~exist('side','var')
    side=1;
end
if side
    slice1=sum(reshape(V(F,ind)>=point(ind)-tol,[],3),2)==3;
else
    slice1=sum(reshape(V(F,ind)<=point(ind)-tol,[],3),2)==3;
end
slice2=~slice1;

Fcut1=F(slice1,:);
Fcut2=F(slice2,:);

[V1,F1]=shrinkModel(V,Fcut1);
[V2,F2]=shrinkModel(V,Fcut2);

% --- Executes on button press in SaveButton.
function SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.ShowLeftButton,'Value') && ~isempty(handles.V1)
    writeModel(handles.V1,handles.F1,handles.FileName,get(handles.ReduceHullsCheck,'Value'));
    %writeConvexHull(handles.V1,handles.FileName,get(handles.ReduceHullsCheck,'Value'))
end
if get(handles.ShowRightButton,'Value') && ~isempty(handles.V2)
    writeModel(handles.V2,handles.F2,handles.FileName,get(handles.ReduceHullsCheck,'Value'));
    %writeConvexHull(handles.V2,handles.FileName,get(handles.ReduceHullsCheck,'Value'))
end


% --- Executes on button press in LoadButton.
function LoadButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.FileName,handles.PathName,handles.FilterIndex] = uigetfile('*.stl','Select an STL mesh to split');
if handles.FileName
    [handles.V,handles.F]=stlread([handles.PathName,handles.FileName],true,true);
    
    eztrisurf(handles.axes1,handles.F,handles.V);
end
handles.axis_range=axis();
update_plot(handles);
guidata(hObject,handles);


% --- Executes on button press in AddModelButton.
function AddModelButton_Callback(hObject, eventdata, handles)
% hObject    handle to AddModelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.FileName,handles.PathName,handles.FilterIndex] = uigetfile('*.stl','Select an STL mesh to split');
[handles.V,handles.F]=stlread([handles.PathName,handles.FileName],true,true);
hold on
eztrisurf(handles.axes1,handles.F,handles.V);
hold off
guidata(hObject,handles);


% --- Executes on button press in ResetViewButton.
function ResetViewButton_Callback(hObject, eventdata, handles)
% hObject    handle to ResetViewButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla
handles.V1=handles.V;
handles.V2=[];
handles.F1=handles.F;
handles.F2=[];
update_plot(handles);
guidata(hObject,handles);

% --- Executes on button press in ShowRightButton.
function ShowRightButton_Callback(hObject, eventdata, handles)
% hObject    handle to ShowRightButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ShowRightButton
update_plot(handles);

function writeConvexHull(V,modelname,reduce)
F_conv=convhull(V);
if reduce
    [Vc,Fc]=trimeshReduce(V,F_conv,reduce);
else
    [Vc,Fc]=shrinkModel(V,F_conv);
end

outname=regexprep(modelname,'Body','convhull');
cloud2stl(outname,Vc,Fc,'binary');

function writeModel(V,F,modelname,reduce)
ind=getFileIndex(modelname);
%outname=regexprep(modelname,'Body','raw');
outname=regexprep(modelname,'\.stl',sprintf('_%d.stl',ind));
%[Vc,Fc]=shrinkModel(V,F);
cloud2stl(['export/',outname],V,F,'binary');
writeConvexHull(V,['export/',outname],reduce)


% --- Executes on button press in SliceXYCheck.
function SliceXYCheck_Callback(hObject, eventdata, handles)
% hObject    handle to SliceXYCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SliceXYCheck


% --- Executes on button press in SliceXZCheck.
function SliceXZCheck_Callback(hObject, eventdata, handles)
% hObject    handle to SliceXZCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SliceXZCheck


% --- Executes on button press in SliceYZCheck.
function SliceYZCheck_Callback(hObject, eventdata, handles)
% hObject    handle to SliceYZCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SliceYZCheck


% --- Executes on button press in RefineRedButton.
function RefineRedButton_Callback(hObject, eventdata, handles)
% hObject    handle to RefineRedButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.V1)
    handles.V=handles.V1;
    handles.F=handles.F1;
    eztrisurf(handles.axes1,handles.F,handles.V);
    axis(handles.axis_range);
    guidata(hObject,handles);
end


% --- Executes on button press in RefineBlueButton.
function RefineBlueButton_Callback(hObject, eventdata, handles)
% hObject    handle to RefineBlueButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.V2)
    handles.V=handles.V2;
    handles.F=handles.F2;
    eztrisurf(handles.axes1,handles.F,handles.V);
    axis(handles.axis_range);
    guidata(hObject,handles);
end

function ind=getFileIndex(filename)
filemask=['export/',filename(1:8),'*'];
%rawmask=regexprep(filemask,'Body','raw');
files=dir(filemask);
ind=length(files)+1;


% --- Executes on button press in ExportRedButton.
function ExportRedButton_Callback(hObject, eventdata, handles)
% hObject    handle to ExportRedButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%KLUDGE: assume Body_XXX name

writeModel(handles.V1,handles.F1,handles.FileName,get(handles.ReduceHullsCheck,'Value'));
%writeConvexHull(handles.V1,handles.FileName,get(handles.ReduceHullsCheck,'Value'))

% --- Executes on button press in ExportBlueButton.
function ExportBlueButton_Callback(hObject, eventdata, handles)
% hObject    handle to ExportBlueButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

writeModel(handles.V2,handles.F2,handles.FileName,get(handles.ReduceHullsCheck,'Value'));

% --- Executes on button press in SideButton.
function SideButton_Callback(hObject, eventdata, handles)
% hObject    handle to SideButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SideButton
newSplitPoint(hObject,handles);


% --- Executes on button press in ShowExportedPartsButton.
function ShowExportedPartsButton_Callback(hObject, eventdata, handles)
% hObject    handle to ShowExportedPartsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=regexprep(['export/',handles.FileName],'\.[Ss][Tt][Ll]','');
searchstr=[filename,'_*.stl'];
files=dir(searchstr);
[az,el]=view;
cla;
hold on
for f=files'
    [V,F]=stlread(['export/',f.name],true,true);
    eztrisurf(handles.axes1,F,V);
    
end
hold off

searchstr=regexprep(searchstr,'Body','convhull');
conv_files=dir(searchstr);

hold on
for f=conv_files'
    [V,F]=stlread(['export/',f.name],true,true);
    eztrisurf(handles.axes1,F,V,.5,[.6,.9,.6]);
end
hold off
view(az,el)
axis(handles.axis_range)


% --- Executes on button press in AllDoneButton.
function AllDoneButton_Callback(hObject, eventdata, handles)
% hObject    handle to AllDoneButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%movefile(handles.FileName,['completed/',handles.FileName])
close


% --- Executes on button press in ReduceHullsCheck.
function ReduceHullsCheck_Callback(hObject, eventdata, handles)
% hObject    handle to ReduceHullsCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ReduceHullsCheck


function ReductionValue_Callback(hObject, eventdata, handles)
% hObject    handle to ReductionValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ReductionValue as text
%        str2double(get(hObject,'String')) returns contents of ReductionValue as a double


% --- Executes during object creation, after setting all properties.
function ReductionValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ReductionValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
