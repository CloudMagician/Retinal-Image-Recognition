function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 15-Jul-2018 16:12:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

%当前是否存在原图
setappdata(handles.imageaxes,'imagebool',false);

%截图框
%setappdata(handles.cutbutton,'rect');

%当前是否存在截图框
setappdata(handles.cutbutton,'cutbool',false);

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in choosebutton.
function choosebutton_Callback(hObject, eventdata, handles)
% hObject    handle to choosebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%读文件
[filepath,filename] = uigetfile({'*.bmp';'*.jpg'},'Select the Image');

if isempty(filename)
    msgbox('Empty File !!','Warning','warn');
else
    currentfile = [filename,filepath];
    currentimage = imread(currentfile);
    axes(handles.imageaxes);
    imshow(currentimage);
    
    setappdata(handles.imageaxes,'imagebool',true);
    setappdata(handles.imageaxes,'currentimage',currentimage);
    setappdata(handles.imageaxes,'filepath',filepath);
    setappdata(handles.imageaxes,'filename',filename);
end

% --- Executes on button press in cutbutton.
function cutbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cutbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%获取全局变量imagebool的值
imagebool = getappdata(handles.imageaxes,'imagebool');

if imagebool == true
    %获取全局变量cutbool的值
    cutbool = getappdata(handles.cutbutton,'cutbool');

    if cutbool == false
        setappdata(handles.cutbutton,'cutbool',true);
        h = imrect(handles.imageaxes,[10,10,250,200]);
        rect = wait(h);
        setappdata(handles.cutbutton,'rect',rect);
    end
end

% --- Executes on button press in cancelbutton.
function cancelbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%获取全局变量cutbool的值
cutbool = getappdata(handles.cutbutton,'cutbool');

if cutbool == true
    setappdata(handles.cutbutton,'cutbool',false);
end

% --- Executes on button press in confirmbutton.
function confirmbutton_Callback(hObject, eventdata, handles)
% hObject    handle to confirmbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%获取全局变量cutbool的值
cutbool = getappdata(handles.cutbutton,'cutbool');

if cutbool == true
    setappdata(handles.cutbutton,'cutbool',false);
    rect = getappdata(handles.cutbutton,'rect');
    currentimage = getappdata(handles.imageaxes,'currentimage');
    cutimage = imcrop(currentimage,rect);
    ImageRecognition(cutimage);
end
