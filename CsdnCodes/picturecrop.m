function varargout = picturecrop(varargin)
%% PICTURECROP M-file for picturecrop.fig
%      PICTURECROP, by itself, creates a new PICTURECROP or raises the existing
%      singleton*.
%
%      H = PICTURECROP returns the handle to a new PICTURECROP or the handle to
%      the existing singleton*.
%
%      PICTURECROP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PICTURECROP.M with the given input arguments.
%
%      PICTURECROP('Property','Value',...) creates a new PICTURECROP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before picturecrop_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to picturecrop_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help picturecrop

% Last Modified by GUIDE v2.5 12-Aug-2015 10:20:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @picturecrop_OpeningFcn, ...
    'gui_OutputFcn',  @picturecrop_OutputFcn, ...
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


%% --- Executes just before picturecrop is made visible.
function picturecrop_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to picturecrop (see VARARGIN)

global pic_cut
pic_cut=0;

set(handles.editImgNum,'String','1');
set(handles.editCurImgN,'String','1');
set(handles.txtSaveName,'String','1_1.jpg');

% Choose default command line output for picturecrop
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes picturecrop wait for user response (see UIRESUME)
% uiwait(handles.figure1);


%% --- Outputs from this function are returned to the command line.
function varargout = picturecrop_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% --- Executes on button press in search.
function search_Callback(hObject, eventdata, handles)
% hObject    handle to search (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% [filename,pathname]=uigetfile({'*.bmp;*.jpg;*.gif','(*.bmp;*.jpg;*.gif)';'*.bmp','(*.bmp)';'*.jpg','(*.jpg)';'*.gif','(*.gif)';},'打开图片');
FilePath = uigetdir('C:\'); % 获取路径

fileNames = dir(FilePath);
if fileNames(1).name == '.'
    fileNames(1:2) = [];
end
if isempty(fileNames)
    msgbox('Empty File !!','Warning','warn');
else
    ImgNo = str2double(get(handles.editCurImgN,'String'));
    CurFileName = [FilePath '\' fileNames(ImgNo).name]; %当前图像名
    
    OrigImg = imread(CurFileName);
    cla(handles.axesOrgImg);
    axes(handles.axesOrgImg);
    imshow(OrigImg);
    handles.OrigImg = OrigImg;
    
    % == 更新图像张数 == %
    set(handles.editImgNum,'String',num2str(length(fileNames)));
    set(handles.txtImgPath,'String',FilePath);
    % == 将文件路径和文件名保存到handles里面 == %
    handles.FilePath = FilePath;
    handles.fileNames = fileNames;
    % Update handles structure
    guidata(hObject,handles);
end


% --- Executes on button press in SelectSavePathBtn.
function SelectSavePathBtn_Callback(hObject, eventdata, handles)
% hObject    handle to SelectSavePathBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SaveFilePath = uigetdir('C:\'); % 获取路径

set(handles.txtSaveImgPath,'String',SaveFilePath);

handles.SaveFilePath = SaveFilePath;
guidata(hObject,handles);


%% == Previous Image : Executes on button press in PreImgBtn == %%
function PreImgBtn_Callback(hObject, eventdata, handles)
% hObject    handle to PreImgBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
curImgNum = str2double(get(handles.editCurImgN,'String'));
if curImgNum <= 1
    msgbox('At the First Image !!','Warning','warn');
else
    curImgNum = curImgNum - 1;
    
    set(handles.editCurImgN,'String',num2str(curImgNum));
    FilePath = handles.FilePath;
    fileNames = handles.fileNames;
    
    CurFileName = [FilePath '\' fileNames(curImgNum).name];
    CurImg = imread(CurFileName);
    cla(handles.axesOrgImg);
    axes(handles.axesOrgImg);
    imshow(CurImg);
    handles.OrigImg = CurImg;
    % == 重置样本数，更新存储名 == %
    set(handles.txtSaveName,'String',[num2str(curImgNum) '_1.jpg']);
    % Update handles structure
    guidata(hObject,handles);
end


%% == Next Image :  Executes on button press in NextImgBtn == %%
function NextImgBtn_Callback(hObject, eventdata, handles)
% hObject    handle to NextImgBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% == 更新当前图像编号 == %
curImgNum = str2double(get(handles.editCurImgN,'String'));
AllImgNum = str2double(get(handles.editImgNum,'String'));
if curImgNum >= AllImgNum
    msgbox('At the Last Image !!','Warning','warn');
else
    curImgNum = curImgNum + 1;
    set(handles.editCurImgN,'String',num2str(curImgNum));
    
    FilePath = handles.FilePath;
    fileNames = handles.fileNames;
    
    CurFileName = [FilePath '\' fileNames(curImgNum).name];
    CurImg = imread(CurFileName);
    cla(handles.axesOrgImg);
    axes(handles.axesOrgImg);
    imshow(CurImg);
    handles.OrigImg = CurImg;
    % == 重置样本数，更新存储名 == %
    set(handles.txtSaveName,'String',[num2str(curImgNum) '_1.jpg']);
    % Update handles structure
    guidata(hObject,handles);
end

%% == 不固定矩形框的长宽比，手动随意调节 == %%
% --- Executes on button press in CropUnfixedBtn.
function CropUnfixedBtn_Callback(hObject, eventdata, handles)
% hObject    handle to CropUnfixedBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pic_cut;
pic_cut = 1;

h = imrect(handles.axesOrgImg,[10,10,250,200]);
%setFixedAspectRatioMode(h,true); % == 固定长宽比 == %
% rect = getPosition(h);
rect = wait(h);

if pic_cut == 1
    OrigImg_t = handles.OrigImg;
    CutImg = imcrop(OrigImg_t,rect);
    
    axes(handles.axesCutImg);
    imshow(CutImg);
    
    pic_cut = 0;
    handles.CutImg = CutImg;
    guidata(hObject,handles);
end

%% == Save Positive Image : Executes on button press in save == %%
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

CutImg = handles.CutImg;
%  [file,path] = uiputfile('*.jpg;','保存图像');
%  filename=fullfile(path,file);
name = get(handles.txtSaveName,'String');
saveFileName = handles.SaveFilePath;
filename = [saveFileName  '\PosImgs_' name];
imwrite(CutImg,filename);
% == 更新存储文件的名字 == %
curImgNum = str2double(get(handles.editCurImgN,'String'));
saveName = [num2str(curImgNum) '_1.jpg'];
set(handles.txtSaveName,'String',saveName);
% == 更新正样本的个数 == %
t_fileNames = dir(saveFileName);
set(handles.txtPosNum,'String',num2str(length(t_fileNames) - 2));
% Update handles structure
guidata(hObject, handles);

%% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% --- Executes during object creation, after setting all properties.
function editImgNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editImgNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

%% --- Executes during object creation, after setting all properties.
function editCurImgN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editCurImgN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

%% == axes的CreateFcn，去掉坐标轴上的坐标 == %%
% --- Executes during object creation, after setting all properties.
function axes4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate axes4
set(hObject,'xTick',[]);
set(hObject,'ytick',[]);
set(hObject,'box','on');


% --- Executes during object creation, after setting all properties.
function axesCutImg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axesCutImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axesCutImg
set(hObject,'xTick',[]);
set(hObject,'ytick',[]);
set(hObject,'box','on');


% --- Executes during object creation, after setting all properties.
function axesOrgImg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axesOrgImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axesOrgImg
set(hObject,'xTick',[]);
set(hObject,'ytick',[]);
set(hObject,'box','on');

    
