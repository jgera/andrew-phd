function varargout = glcmGUI(varargin)
% GLCMGUI M-file for glcmGUI.fig
%      GLCMGUI, by itself, creates a new GLCMGUI or raises the existing
%      singleton*.
%
%      H = GLCMGUI returns the handle to a new GLCMGUI or the handle to
%      the existing singleton*.
%
%      GLCMGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GLCMGUI.M with the given input arguments.
%
%      GLCMGUI('Property','Value',...) creates a new GLCMGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before glcmGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to glcmGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help glcmGUI

% Last Modified by GUIDE v2.5 16-Oct-2009 14:19:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @glcmGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @glcmGUI_OutputFcn, ...
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


% --- Executes just before glcmGUI is made visible.
function glcmGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to glcmGUI (see VARARGIN)
global data;
% Choose default command line output for glcmGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% UIWAIT makes glcmGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = glcmGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



%% --- Generates random sections on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global data;
data.pixels = str2double(get(handles.edit1, 'String'));%Determine how big the image is
randRowPos = floor((size(data.currentImage,1)-data.pixels)*rand);
randColPos = floor((size(data.currentImage,2)-data.pixels)*rand);        
data.randomImage = data.currentImage(randRowPos:randRowPos+data.pixels,randColPos:randColPos+data.pixels,:);
image(data.randomImage, 'parent',handles.axes2);




%% --- Perform the classification of the sample material on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
global data;
%updateModel(handles);
if get(handles.textureClassification,'value') == 1
    data.glcmProperties = createGLCMProperties(data.randomImage); %Generate the properties for the randomImage
    data.overallProbPercent = generatePDF(data.glcmProperties, data.model);
    %Display the information on the GUI
    elements = size(data.overallProbPercent,2);
    data.tempImage = imread(get(handles.modelSample1,'string'));
    set(handles.outcome1,'String',data.overallProbPercent(1));
    image(data.tempImage, 'parent',handles.axes3);
    if elements > 1
        data.tempImage = imread(get(handles.modelSample2,'string'));
        set(handles.outcome2,'String',data.overallProbPercent(2));
        image(data.tempImage, 'parent',handles.axes4);
    end
    if elements > 2
        data.tempImage = imread(get(handles.modelSample3,'string'));
        set(handles.outcome3,'String',data.overallProbPercent(3));
        image(data.tempImage, 'parent',handles.axes5);
    end
    if elements > 3
        data.tempImage = imread(get(handles.modelSample4,'string'));
        set(handles.outcome4,'String',data.overallProbPercent(4));
        image(data.tempImage, 'parent',handles.axes6);
    end
end
if get(handles.colourClassification,'value') == 1
    data.overallColourProbPercent = generateColourPDF(data.randomImage, data.NormalisedRGBModel);
    %Display the information on the GUI
    elements = size(data.overallColourProbPercent,2);
    data.tempImage = imread(get(handles.modelSample1,'string'));
    set(handles.outcome1,'String',data.overallColourProbPercent(1));
    image(data.tempImage, 'parent',handles.axes3);
    if elements > 1
        data.tempImage = imread(get(handles.modelSample2,'string'));
        set(handles.outcome2,'String',data.overallColourProbPercent(2));
        image(data.tempImage, 'parent',handles.axes4);
    end
    if elements > 2
        data.tempImage = imread(get(handles.modelSample3,'string'));
        set(handles.outcome3,'String',data.overallColourProbPercent(3));
        image(data.tempImage, 'parent',handles.axes5);
    end
    if elements > 3
        data.tempImage = imread(get(handles.modelSample4,'string'));
        set(handles.outcome4,'String',data.overallColourProbPercent(4));
        image(data.tempImage, 'parent',handles.axes6);
    end
end
if get(handles.textureBasedGray,'value') == 1
    data.glcmProperties = createGLCMProperties(data.randomImage); %Generate the properties for the randomImage
    data.overallGrayProbPercent = generateGrayPDF(data.glcmProperties, data.modelGray);
    %Display the information on the GUI
    elements = size(data.overallGrayProbPercent,2);
    data.tempImage = imread(get(handles.modelSample1,'string'));
    set(handles.outcome1,'String',data.overallGrayProbPercent(1));
    image(data.tempImage, 'parent',handles.axes3);
    if elements > 1
        data.tempImage = imread(get(handles.modelSample2,'string'));
        set(handles.outcome2,'String',data.overallGrayProbPercent(2));
        image(data.tempImage, 'parent',handles.axes4);
    end
    if elements > 2
        data.tempImage = imread(get(handles.modelSample3,'string'));
        set(handles.outcome3,'String',data.overallGrayProbPercent(3));
        image(data.tempImage, 'parent',handles.axes5);
    end
    if elements > 3
        data.tempImage = imread(get(handles.modelSample4,'string'));
        set(handles.outcome4,'String',data.overallGrayProbPercent(4));
        image(data.tempImage, 'parent',handles.axes6);
    end    
end
if get(handles.hybridClassification,'value') == 1
end



% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
global data
data.currentImage = imread(get(handles.testImage1,'string'));
image(data.currentImage,'parent',handles.axes1);


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
global data
data.currentImage = imread(get(handles.testImage2,'string'));
image(data.currentImage,'parent',handles.axes1);



% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
global data
data.currentImage = imread(get(handles.testImage3,'string'));
image(data.currentImage,'parent',handles.axes1);


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
global data
data.currentImage = imread(get(handles.testImage4,'string'));
image(data.currentImage,'parent',handles.axes1);

% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
global data
data.currentImage = imread(get(handles.testImage5,'string'));
image(data.currentImage,'parent',handles.axes1);

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



function outcome1_Callback(hObject, eventdata, handles)
% hObject    handle to outcome1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outcome1 as text
%        str2double(get(hObject,'String')) returns contents of outcome1 as a double


% --- Executes during object creation, after setting all properties.
function outcome1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outcome1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function outcome2_Callback(hObject, eventdata, handles)
% hObject    handle to outcome2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outcome2 as text
%        str2double(get(hObject,'String')) returns contents of outcome2 as a double


% --- Executes during object creation, after setting all properties.
function outcome2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outcome2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function outcome4_Callback(hObject, eventdata, handles)
% hObject    handle to outcome4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outcome4 as text
%        str2double(get(hObject,'String')) returns contents of outcome4 as a double


% --- Executes during object creation, after setting all properties.
function outcome4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outcome4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function outcome3_Callback(hObject, eventdata, handles)
% hObject    handle to outcome3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outcome3 as text
%        str2double(get(hObject,'String')) returns contents of outcome3 as a double


% --- Executes during object creation, after setting all properties.
function outcome3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outcome3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% --- Executes on button press in generateModelButton.
function generateModelButton_Callback(hObject, eventdata, handles)
global data;
classes = str2double(get(handles.classes, 'string'));
imageArray(1).val = get(handles.modelSample1, 'string');
if classes > 1
    imageArray(2).val = get(handles.modelSample2, 'string');
end
if classes > 2
    imageArray(3).val = get(handles.modelSample3, 'string');
end
if classes > 3
    imageArray(4).val = get(handles.modelSample4, 'string');
end
segmentation = str2double(get(handles.segmentation, 'string'));
%Create the pdf model
data.model = createGLCMModel(imageArray, segmentation);
%keyboard




function modelSample1_Callback(hObject, eventdata, handles)
% hObject    handle to modelSample1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of modelSample1 as text
%        str2double(get(hObject,'String')) returns contents of modelSample1 as a double


% --- Executes during object creation, after setting all properties.
function modelSample1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modelSample1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function modelSample2_Callback(hObject, eventdata, handles)
% hObject    handle to modelSample2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of modelSample2 as text
%        str2double(get(hObject,'String')) returns contents of modelSample2 as a double


% --- Executes during object creation, after setting all properties.
function modelSample2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modelSample2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function modelSample3_Callback(hObject, eventdata, handles)
% hObject    handle to modelSample3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of modelSample3 as text
%        str2double(get(hObject,'String')) returns contents of modelSample3 as a double


% --- Executes during object creation, after setting all properties.
function modelSample3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modelSample3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function modelSample4_Callback(hObject, eventdata, handles)
% hObject    handle to modelSample4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of modelSample4 as text
%        str2double(get(hObject,'String')) returns contents of modelSample4 as a double


% --- Executes during object creation, after setting all properties.
function modelSample4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modelSample4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function testImage1_Callback(hObject, eventdata, handles)
% hObject    handle to testImage1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of testImage1 as text
%        str2double(get(hObject,'String')) returns contents of testImage1 as a double


% --- Executes during object creation, after setting all properties.
function testImage1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to testImage1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function testImage2_Callback(hObject, eventdata, handles)
% hObject    handle to testImage2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of testImage2 as text
%        str2double(get(hObject,'String')) returns contents of testImage2 as a double


% --- Executes during object creation, after setting all properties.
function testImage2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to testImage2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function testImage3_Callback(hObject, eventdata, handles)
% hObject    handle to testImage3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of testImage3 as text
%        str2double(get(hObject,'String')) returns contents of testImage3 as a double


% --- Executes during object creation, after setting all properties.
function testImage3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to testImage3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function testImage4_Callback(hObject, eventdata, handles)
% hObject    handle to testImage4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of testImage4 as text
%        str2double(get(hObject,'String')) returns contents of testImage4 as a double


% --- Executes during object creation, after setting all properties.
function testImage4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to testImage4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function testImage5_Callback(hObject, eventdata, handles)
% hObject    handle to testImage5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of testImage5 as text
%        str2double(get(hObject,'String')) returns contents of testImage5 as a double


% --- Executes during object creation, after setting all properties.
function testImage5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to testImage5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function classes_Callback(hObject, eventdata, handles)
% hObject    handle to classes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of classes as text
%        str2double(get(hObject,'String')) returns contents of classes as a double


% --- Executes during object creation, after setting all properties.
function classes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to classes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function segmentation_Callback(hObject, eventdata, handles)
% hObject    handle to segmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of segmentation as text
%        str2double(get(hObject,'String')) returns contents of segmentation as a double


% --- Executes during object creation, after setting all properties.
function segmentation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to segmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes on button press in classifyImageButton.
function classifyImageButton_Callback(hObject, eventdata, handles)
global data
if get(handles.textureClassification,'value') == 1
    data.pixels = str2double(get(handles.edit1, 'String'));%Determine how big the image is    
    data.labelImage = classifyImage(data.model, data.currentImage, data.pixels);
end
if get(handles.colourClassification,'value') == 1
    data.pixels = str2double(get(handles.edit1, 'String'));%Determine how big the image is
    data.labelImage = classifyImageColour(data.NormalisedRGBModel, data.currentImage, data.pixels);
end
if get(handles.textureBasedGray,'value') == 1
    data.pixels = str2double(get(handles.edit1, 'String'));%Determine how big the image is
    data.labelImage = classifyImageGray(data.modelGray, data.currentImage, data.pixels);
end
if get(handles.hybridClassification,'value') == 1
end



% --- Executes on button press in colourModel.
function colourModel_Callback(hObject, eventdata, handles)
global data;
classes = str2double(get(handles.classes, 'string'));
imageArray(1).val = get(handles.modelSample1, 'string');
if classes > 1
    imageArray(2).val = get(handles.modelSample2, 'string');
end
if classes > 2
    imageArray(3).val = get(handles.modelSample3, 'string');
end
if classes > 3
    imageArray(4).val = get(handles.modelSample4, 'string');
end
segmentation = str2double(get(handles.segmentation, 'string'));
%Create the pdf model
data.NormalisedRGBModel = createNormalisedRGBModel(imageArray, segmentation);
%keyboard


% --- Executes on button press in imageCaptureButton.
function imageCaptureButton_Callback(hObject, eventdata, handles)
global data;
data.currentImage = vid_aq();
try out = imaqfind;stop(out);delete(out);end
imshow(data.currentImage,'parent',handles.axes1);
   
% try out = imaqfind;stop(out);delete(out);end
% data.vid = videoinput('winvideo', 1);
% try
%     %data.vid.BayerSensorAlignment = 'rggb';
%     %data.vid.ReturnedColorSpace = 'bayer';
%     start(data.vid);
%     
%     while(data.vid.FramesAcquired<=inf)
%         data.imageData =squeeze(getdata(data.vid,1));
%         flushdata(data.vid);
%         figure(3);
%         imshow(data.imageData);
%     end
%     %image(data.imageData,'parent',handles.axes1);
% catch
%     lasterr;
% end




% --- Executes on button press in generateTextureGrayModel.
function generateTextureGrayModel_Callback(hObject, eventdata, handles)
global data;
classes = str2double(get(handles.classes, 'string'));
imageArray(1).val = get(handles.modelSample1, 'string');
if classes > 1
    imageArray(2).val = get(handles.modelSample2, 'string');
end
if classes > 2
    imageArray(3).val = get(handles.modelSample3, 'string');
end
if classes > 3
    imageArray(4).val = get(handles.modelSample4, 'string');
end
segmentation = str2double(get(handles.segmentation, 'string'));
%Create the pdf model
data.modelGray = createGLCMGrayModel(imageArray, segmentation);
%keyboard


% --- Executes on button press in loadModels.
function loadModels_Callback(hObject, eventdata, handles)
load('data.mat');


function classificationDistance_Callback(hObject, eventdata, handles)
% hObject    handle to classificationDistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of classificationDistance as text
%        str2double(get(hObject,'String')) returns contents of classificationDistance as a double


% --- Executes during object creation, after setting all properties.
function classificationDistance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to classificationDistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in saveModels.
function saveModels_Callback(hObject, eventdata, handles)
%keyboard

%--- This function takes the specified distance value and selects the 
% most appropriate model set to use
function updateModel(handles)
global data;
%load('model.mat');
%keyboard
data.model = ['model.model',get(handles.classificationDistance, 'string')];
data.modelGray = ['model.modelGray',get(handles.classificationDistance, 'string')];
data.NormalisedRGBModel = ['model.NormalisedRGBModel',get(handles.classificationDistance, 'string')];
data.model
