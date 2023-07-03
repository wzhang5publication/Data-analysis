%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % NAME:   
% %     c_NanopillarAnalysis_20230619
% % PURPOSE: 
% %     A movie processing software package with a graphic user interface.
% % CATEGORY:
% %     Image processing.
% % CALLING SEQUENCE:
% %     c_NanopillarAnalysis_20230619
% % INPUTS:
% %     Put in various parameters according to the intruction.
% % OUTPUS:
% %     Play a movie.
% %     Save a movie into avi format.
% %     Calculate background.
% %     Calculate sumdata.
% % COMMENTS:
% %     none.
% % HISTORY:
% %     Written by Bianxiao Cui on June 20, 2020.
% %     Modified by Bianxiao Cui on October 18, 2020
% %     Modified by Bianxiao Cui on Oct. 30, 2020
% %     Substantially modified by Bianxiao Cui on June 16, 2023. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = c_NanopillarAnalysis_20230619(varargin)
% C_NANOPILLARANALYSIS_20230619 M-file for c_NanopillarAnalysis_20230619.fig
%      C_NANOPILLARANALYSIS_20230619, by itself, creates a new C_NANOPILLARANALYSIS_20230619 or raises the existing
%      singleton*.
%
%      H = C_NANOPILLARANALYSIS_20230619 returns the handle to a new C_NANOPILLARANALYSIS_20230619 or the handle to
%      the existing singleton*.
%
%      C_NANOPILLARANALYSIS_20230619('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in C_NANOPILLARANALYSIS_20230619.M with the given input arguments.
%
%      C_NANOPILLARANALYSIS_20230619('Property','Value',...) creates a new C_NANOPILLARANALYSIS_20230619 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before c_cdf_process_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to c_NanopillarAnalysis_20230619_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help c_NanopillarAnalysis_20230619

% Last Modified by GUIDE v2.5 19-Jun-2023 17:37:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @c_NanopillarAnalysis_20230619_OpeningFcn, ...
                   'gui_OutputFcn',  @c_NanopillarAnalysis_20230619_OutputFcn, ...
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


% --- Executes just before c_NanopillarAnalysis_20230619 is made visible.
function c_NanopillarAnalysis_20230619_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to c_NanopillarAnalysis_20230619 (see VARARGIN)

    axes(handles.axes1);    %% make the existing axes1 the current axes.
    cla;        %% clear current axes
    set(gcf,'Units','pixels');
 %%   [x,map]=imread('yxz.tif');
 %%   imshow(x(1:512,1:512,:),map);
    
    axes(handles.axes2);    %% make the existing axes1 the current axes.
    cla;        %% clear current axes
    set(gcf,'Units','pixels');
%%    [x,map]=imread('yxz.tif');
%%    imshow(x(1:512,1:512,:),map);

% Choose default command line output for c_NanopillarAnalysis_20230619
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes c_NanopillarAnalysis_20230619 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = c_NanopillarAnalysis_20230619_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% Open files %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in OpenGreen.
function OpenGreen_Callback(hObject, eventdata, handles)
% hObject    handle to OpenGreen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global movieon;
    fclose all;
   [datafile,datapath]=uigetfile('*.tif','Choose a Green TIF movie file');

    if datafile==0, return; end
    cd(datapath);
    
    fileinfo=imfinfo(datafile);
    NumFrames=numel(fileinfo);
    imagesizex=fileinfo(1).Height;
    imagesizey=fileinfo(1).Width;
    
    set(handles.FileName,'String',[datafile '   -   ' num2str(NumFrames) ' frames']);
    set(handles.DisplayText,'String',{['Be patient'];...
        ['A large file will take a few minutes to open.']});
    
    Data=zeros(imagesizex,imagesizey,NumFrames);
    for k=1:NumFrames
        Data(:,:,k)=imread(datafile,k,'Info',fileinfo);
    end
    
    
    image_t=squeeze(Data(:,:,1));
    low=min(min(image_t));
    high=max(max(image_t));
    high=ceil(high*1.5);
    handles.ColorRange=[low high];
    set(handles.ColorSlider,'min',low);
    set(handles.ColorSlider,'max',high);
    set(handles.ColorSlider,'value',floor((low+high)/2));
    set(handles.ColorSlider,'SliderStep',[(high-low)/high/100 0.1]);
    
    if NumFrames>1
        set(handles.FrameSlider,'min',1);
        set(handles.FrameSlider,'max',NumFrames);
        set(handles.FrameSlider,'value',1);
        set(handles.FrameSlider,'SliderStep',[1/(NumFrames-1) 0.1]);
    end

    axes(handles.axes1);
    handles.image_t=image_t;
    handles.imagehandle=imshow(image_t,[low high]); %%do not transpose
    colormap(gray);

    handles.greenfilename=datafile;
    handles.greendatapath=datapath;
    handles.imagesizex=imagesizex;
    handles.imagesizey=imagesizey;
    handles.greenNumFrames=NumFrames;
    handles.greenData=Data;
    handles.filename=handles.greenfilename;
    handles.Data=handles.greenData;
    handles.NumFrames=handles.greenNumFrames;
    handles.axrange=axis(handles.axes1);
    
    display('Open Green Finished');
    guidata(hObject,handles);
    movieon=0;


% --- Executes on button press in OpenRed.
function OpenRed_Callback(hObject, eventdata, handles)
% hObject    handle to OpenRed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
      global movieon;
    fclose all;
   [datafile,datapath]=uigetfile('*.tif','Choose a Red TIF movie file');

    if datafile==0, return; end
    cd(datapath);
    
    fileinfo=imfinfo(datafile);
    NumFrames=numel(fileinfo);
    imagesizex=fileinfo(1).Height;
    imagesizey=fileinfo(1).Width;
    
    Data=zeros(imagesizex,imagesizey,NumFrames);
    for k=1:NumFrames
        Data(:,:,k)=imread(datafile,k,'Info',fileinfo);
    end
    set(handles.FileName,'String',[datafile '   -   ' num2str(NumFrames) ' frames']);
    
    image_t=squeeze(Data(:,:,1));
    low=min(min(image_t));
    high=max(max(image_t));
    high=ceil(high*1.5);
    handles.ColorRange=[low high];
    set(handles.ColorSlider,'min',low);
    set(handles.ColorSlider,'max',high);
    set(handles.ColorSlider,'value',floor((low+high)/2));
    set(handles.ColorSlider,'SliderStep',[(high-low)/high/100 0.1]);
    
    if NumFrames>1
        set(handles.FrameSlider,'min',1);
        set(handles.FrameSlider,'max',NumFrames);
        set(handles.FrameSlider,'value',1);
        set(handles.FrameSlider,'SliderStep',[1/(NumFrames-1) 0.1]);
    end

    axes(handles.axes1);
    handles.image_t=image_t;
    handles.imagehandle=imshow(image_t,[low high]); %%do not transpose
    colormap(gray);

    handles.redfilename=datafile;
    handles.reddatapath=datapath;
    handles.imagesizex=imagesizex;
    handles.imagesizey=imagesizey;
    handles.redNumFrames=NumFrames;
    handles.redData=Data;
    handles.filename=handles.redfilename;
    handles.Data=handles.redData;
    handles.NumFrames=handles.redNumFrames;
    handles.axrange=axis(handles.axes1);
    
    guidata(hObject,handles);
    movieon=0;


% --- Executes on button press in Z_Projection.
function OpenBrightfield_Callback(hObject, eventdata, handles)
% hObject    handle to Z_Projection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global movieon;
    fclose all;
    [datafile,datapath]=uigetfile('*.tif','Choose a matching brightfield file'); % read cui-lab data format files
    if datafile==0, return; end
    cd(datapath);
    
    fileinfo=imfinfo(datafile);
    NumFrames=numel(fileinfo);
    imagesizex=fileinfo(1).Height;
    imagesizey=fileinfo(1).Width;
    
    Data=zeros(imagesizex,imagesizey,NumFrames);
    for k=1:NumFrames
        Data(:,:,k)=imread(datafile,k,'Info',fileinfo);
    end
    set(handles.FileName,'String',[datafile '   -   ' num2str(NumFrames) ' frames']);
    
    image_t=squeeze(Data(:,:,1));
    low=min(min(image_t));
    high=max(max(image_t));
    high=ceil(high*1.5);
    handles.ColorRange=[low high];
    set(handles.ColorSlider,'min',low);
    set(handles.ColorSlider,'max',high);
    set(handles.ColorSlider,'value',floor((low+high)/2));
    set(handles.ColorSlider,'SliderStep',[(high-low)/high/100 0.1]);
    
    if NumFrames>1
        set(handles.FrameSlider,'min',1);
        set(handles.FrameSlider,'max',NumFrames);
        set(handles.FrameSlider,'value',1);
        set(handles.FrameSlider,'SliderStep',[1/(NumFrames-1) 0.1]);
    end

    axes(handles.axes1);
    handles.image_t=image_t;
    handles.imagehandle=imshow(image_t,[low high]); %%do not transpose
    colormap(gray);

    handles.brightfieldfilename=datafile;
    handles.brightfielddatapath=datapath;
    handles.imagesizex=imagesizex;
    handles.imagesizey=imagesizey;
    handles.brightfieldNumFrames=NumFrames;
    handles.brightfieldData=Data;
    handles.filename=handles.brightfieldfilename;
    handles.Data=handles.brightfieldData;
    handles.NumFrames=handles.brightfieldNumFrames;
    handles.axrange=axis(handles.axes1);
    
    guidata(hObject,handles);
    movieon=0;
    
    
function FileName_Callback(hObject, eventdata, handles)
% hObject    handle to FileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FileName as text
%        str2double(get(hObject,'String')) returns contents of FileName as a double


% --- Executes during object creation, after setting all properties.
function FileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in SelectFile.
function SelectFile_Callback(hObject, eventdata, handles)
% hObject    handle to SelectFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SelectFile contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SelectFile

val = get(hObject,'Value');
axes(handles.axes1);
switch val

    case 2  %green channel
        ax=handles.axes1;
        cax = axis(ax);
        handles.filename=handles.greenfilename;
        handles.Data=handles.greenData;
        handles.NumFrames=handles.greenNumFrames;
        set(handles.FileName,'String',[handles.filename '   -   ' num2str(handles.NumFrames) ' frames']);
        image_t = handles.Data(:,:,1);
% %         set(handles.imagehandle,'CData',image_t);
% %         drawnow;
        handles.image_t=image_t;
        low = min(min(image_t));
        high = max(max(image_t));
        gap = high-low;
        handles.imagehandle=imshow(image_t,[low-0.15*gap, high-0.5*gap]); %%do not transpose

        axis(ax,cax);
        %%axis(ax,handles.axrange);
        
        low=min(min(image_t));
        high=max(max(image_t));
        high=ceil(high*1.5);
        handles.ColorRange=[low high];
        set(handles.ColorSlider,'min',low);
        set(handles.ColorSlider,'max',high);
        set(handles.ColorSlider,'value',floor((low+high)/2));
        set(handles.ColorSlider,'SliderStep',[(high-low)/high/100 0.1]);
    
        guidata(hObject,handles);
    case 3  %red channel
        ax=handles.axes1;
        cax = axis(ax);
        handles.filename=handles.redfilename;
        handles.Data=handles.redData;
        handles.NumFrames=handles.redNumFrames;
        set(handles.FileName,'String',[handles.filename '   -   ' num2str(handles.NumFrames) ' frames']);
        image_t = handles.Data(:,:,1);
% %         set(handles.imagehandle,'CData',image_t);
% %         drawnow;
        handles.image_t=image_t;
        low = min(min(image_t));
        high = max(max(image_t));
        gap = high-low;
        handles.imagehandle=imshow(image_t,[low-0.15*gap, high-0.5*gap]); %%do not transpose
        axis(ax, cax);
        
        low=min(min(image_t));
        high=max(max(image_t));
        high=ceil(high*1.5);
        handles.ColorRange=[low high];
        set(handles.ColorSlider,'min',low);
        set(handles.ColorSlider,'max',high);
        set(handles.ColorSlider,'value',floor((low+high)/2));
        set(handles.ColorSlider,'SliderStep',[(high-low)/high/100 0.1]);
    
        guidata(hObject,handles);
    case 4 %Brightfield channel
        ax=handles.axes1;
        cax = axis(ax);
        handles.filename=handles.brightfieldfilename;
        handles.Data=handles.brightfieldData;
        handles.NumFrames=handles.brightfieldNumFrames;
        set(handles.FileName,'String',[handles.filename '   -   ' num2str(handles.NumFrames) ' frames']);
        image_t = handles.Data(:,:,1);
% %         set(handles.imagehandle,'CData',image_t);
% %         drawnow;
        handles.image_t=image_t;
        handles.imagehandle=imshow(image_t,[]); %%do not transpose
        axis(ax,cax);
        
        low=min(min(image_t));
        high=max(max(image_t));
        high=ceil(high*1.5);
        handles.ColorRange=[low high];
        set(handles.ColorSlider,'min',low);
        set(handles.ColorSlider,'max',high);
        set(handles.ColorSlider,'value',floor((low+high)/2));
        set(handles.ColorSlider,'SliderStep',[(high-low)/high/100 0.1]);
        
        guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function SelectFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SelectFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
    


% --- Executes on button press in PlayMovie.
function PlayMovie_Callback(hObject, eventdata, handles)
% hObject    handle to PlayMovie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global movieon;
    if movieon==0
        movieon=1;
        set(hObject,'String','Stop Movie');
        
        for k=1:handles.NumFrames,
            temp=handles.Data(:,:,k);
            set(handles.imagehandle,'CData',temp); %%do not transpose
            set(handles.DisplayText,'String',['Frame ' int2str(k)]);
            drawnow;
            if movieon==0 break; end
        end
        movieon=0;
        set(hObject,'String','Play Movie');
    elseif movieon==1
        movieon=0;
        set(hObject,'String','Play Movie');
    end
    

% --- Executes on button press in ImageInverse.
function ImageInverse_Callback(hObject, eventdata, handles)
% hObject    handle to ImageInverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        axes(handles.axes1);
        img = get(handles.imagehandle,'CData');
        valuemax = max(max(img));
        image_t = valuemax - img;
       
        low=max([0 min(min(image_t))]);
        high=max([256 max(max(image_t))]);
        high=ceil(high*20);
        set(handles.ColorSlider,'min',low);
        set(handles.ColorSlider,'max',high*0.1);
        set(handles.ColorSlider,'value',high*0.1);
        set(handles.ColorSlider,'SliderStep',[(high-low)/high/100 0.1]);
        set(handles.imagehandle,'CData',image_t);
        drawnow;



% --- Executes on slider movement.
function ColorSlider_Callback(hObject, eventdata, handles)
% hObject    handle to ColorSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%set(handles.axes2,'CDatamapping','scaled');
    set(handles.axes1,'CLim',[get(handles.ColorSlider,'min') get(handles.ColorSlider,'value')]);
    set(handles.DisplayText,'String',{['colormap min: ' num2str(get(handles.ColorSlider,'min'))];...
            ['colormap max:' num2str(get(handles.ColorSlider,'value'))]});


% --- Executes during object creation, after setting all properties.
function ColorSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ColorSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function FrameSlider_Callback(hObject, eventdata, handles)
% hObject    handle to FrameSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

    frame_no = round(get(handles.FrameSlider,'value'));
    temp = handles.Data(:,:,frame_no);
    set(handles.imagehandle,'CData',temp);
    drawnow;
    set(handles.FrameSlider,'value',frame_no);
    set(handles.DisplayText,'String',['Frame number: ' num2str(frame_no)]);


% --- Executes during object creation, after setting all properties.
function FrameSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FrameSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function DisplayText_Callback(hObject, eventdata, handles)
% hObject    handle to DisplayText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DisplayText as text
%        str2double(get(hObject,'String')) returns contents of DisplayText as a double


% --- Executes during object creation, after setting all properties.
function DisplayText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DisplayText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%% End of Open files %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% menubar items %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------------------
function Tools_Callback(hObject, eventdata, handles)
% hObject    handle to Tools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function CopyFigure_Callback(hObject, eventdata, handles)
% hObject    handle to CopyFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fig = gcf;
print(fig, '-clipboard','-dmeta');


% --------------------------------------------------------------------
function SaveImage_Callback(hObject, eventdata, handles)
% hObject    handle to SaveImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    im=get(handles.imagehandle,'CData');
    low=get(handles.ColorSlider,'min');
    high=get(handles.ColorSlider,'value');
    im=(im-low)/(high-low)*236; %%don't know why I have to use 236 instead of 256
    black=find(im < 0);         %%There is something about the colormap.
    im(black)=0;
    white=find(im > 236);
    im(white)=236;
    cmap=colormap;
    [filename,pathname]=uiputfile('.tif','Save the image into ',strrep(handles.filename,'cdf','tif'));
    cdirec = cd;
    cd(pathname);
    imwrite(im,cmap,filename,'TIF');
    cd(cdirec);

% --------------------------------------------------------------------
function SaveTifStack_Callback(hObject, eventdata, handles)
% hObject    handle to SaveTifStack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    prompt = {'File Name info','Begin at :','End at :'}; 
    dlg_title = 'File Info.';
    num_lines= 1;
    def     = {'Name','1','301'};
    answer  = inputdlg(prompt,dlg_title,num_lines,def);
    NameInfo=answer{1};
    [filename,pathname]=uiputfile('.tif','Save the movie into ',['TiffStack-',NameInfo,'.tif']);
    cdirec = cd;
    cd(pathname);
    
    startframe=max([1 sscanf(answer{2},'%d')]);
    endframe=min([5000 sscanf(answer{3},'%d')]);
    
    NumFiles=dir([NameInfo,'*.TIF']);
    
for i=startframe:endframe
    name= NumFiles(i).name;
    img=imread(name);
    imwrite(img,filename,'writemode','append');
end


% --------------------------------------------------------------------
function Zoom_Callback(hObject, eventdata, handles)
% hObject    handle to Zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%zoom on;
zoom on;

% --------------------------------------------------------------------
function Pixval_Callback(hObject, eventdata, handles)
% hObject    handle to Pixval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%pixval on;
impixelinfo;


% --------------------------------------------------------------------
function proj_processing_Callback(hObject, eventdata, handles)
% hObject    handle to proj_processing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Z_projection_Callback(hObject, eventdata, handles)
% hObject    handle to Z_projection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    prompt = {['Projection method: Max(1), Min(2), Mean(3)'], 'starting frame', 'ending frame'}; 
    dlg_title = 'Frame Info.';
    num_lines= 1;
    def     = {'1','1',num2str(handles.NumFrames)};
    answer  = inputdlg(prompt,dlg_title,num_lines,def); 
        Proj = sscanf(answer{1},'%d');
        starting_frame = sscanf(answer{2},'%d');
        ending_frame = sscanf(answer{3},'%d');
        proj_image = zeros(handles.imagesizex,handles.imagesizey);
        
         
        for fr = starting_frame:ending_frame
            temp = squeeze(handles.Data(:,:,fr));
            switch Proj
                case 1  %Project along the maxium value
                    proj_image = max(proj_image,temp);
                case 2  %Project along the minumum value
                    proj_image = min(proj_image,temp);
                case 3  %Project along the mean value
                    proj_image = proj_image+temp;
            end
        set(handles.imagehandle,'CData',proj_image); %do not transpose
        drawnow;
        end
        
    set(handles.DisplayText,'String',['Finished - Z projection processing']);
    
         NameInfo=handles.filename;
        [filename,pathname]=uiputfile('.TIF','Save Mask Avg image ',['Zproj-',NameInfo]);
        cdirec = cd;
        cd(pathname);
        save_img=uint16(proj_image);
        imwrite(save_img,filename,'TIF');

    guidata(hObject,handles);
    

% --------------------------------------------------------------------
function Cal_Movie_bkgrd_Callback(hObject, eventdata, handles)
% hObject    handle to Cal_Movie_bkgrd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

        imagesizex = handles.imagesizex;
        imagesizey = handles.imagesizey;
        NumFrames = handles.NumFrames;
        Data = handles.Data;
        bkgrd_intensity=zeros(1,NumFrames);
    for fr=1:NumFrames
        image_array = Data(:,:,fr);
        bkgrd_intensity(1,fr)=median(image_array,'all');
    end

    axes(handles.axes2);
    plot(bkgrd_intensity(1,:),'.-r');
            set( findobj(gca,'typehFig','line'), 'LineWidth', 1);
            set(gca, 'FontName', 'Arial')
            set(gca, 'FontSize', 8);
            title('Background Intensity vs. Time');
            xlabel('time (frame)')
            ylabel('Intensity')
   
  [savefile,savepath]=uiputfile('*.txt','Save the background intensity data into TXT file','bkgrd_Zplot.txt'); 
   if savefile ~= 0
       writematrix(bkgrd_intensity,savefile);
   end
       
   display('Cal_Movie_bkgrd finished');
   
   handles.bkgrd_trace = bkgrd_intensity;
   guidata(hObject,handles);

        
% --------------------------------------------------------------------
function Colormap_Callback(hObject, eventdata, handles)
% hObject    handle to Colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function original_Callback(hObject, eventdata, handles)
% hObject    handle to original (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colormap(original);


% --------------------------------------------------------------------
function jet_Callback(hObject, eventdata, handles)
% hObject    handle to jet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colormap(jet);

% --------------------------------------------------------------------
function hot_Callback(hObject, eventdata, handles)
% hObject    handle to hot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colormap(hot);

% --------------------------------------------------------------------
function gray_Callback(hObject, eventdata, handles)
% hObject    handle to gray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colormap(gray);
    
%%%%%%%%%%%%%%%%%%%%%%%% End of menu items %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%









%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Mask Construction %%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in BandPass.
function BandPass_Callback(hObject, eventdata, handles)
% hObject    handle to BandPass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        axes(handles.axes1);
        img = get(handles.imagehandle,'CData');
        gauss_kernel = fspecial('gaussian',[21,21],1);
        bg_kernel = zeros(51,51) + 1/51^2; %% rolling ball 50 pixel square
        image_t = imfilter(img,gauss_kernel,'same') - ...;
            imfilter(img,bg_kernel,'same');
       %%image_t = imfilter(img,gauss_kernel,'same');
        low=max([0 min(min(image_t))]);
        high=max([256 max(max(image_t))]);
        high=ceil(high*20);
        set(handles.ColorSlider,'min',low);
        set(handles.ColorSlider,'max',high*0.1);
        set(handles.ColorSlider,'value',high*0.1);
        set(handles.ColorSlider,'SliderStep',[(high-low)/high/100 0.1]);
        set(handles.imagehandle,'CData',image_t);
        drawnow;

        
% --- Executes on button press in SelectPoint.
function SelectPoint_Callback(hObject, eventdata, handles)
% hObject    handle to SelectPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    axes(handles.axes1);
    h=impixelinfo;  
    delete(h);      %%these two lines to prevent an annoying small 'pixel info' window when right click
    
    ax=handles.axes1;
    cax=axis(ax);   %%get the current axis limits. This is for zoom-in purpose.
    
    %%%% important: when selecting points, the first two points should be
    %%%% on the line of the same diameter nanopillars.  When selecting 3
    %%%% points, the selected points should be 1->left->2 and 1->down->3.
        set(handles.DisplayText,'String','Select a point using left button');
            [xi,yi,but] = ginput(1);    %Graphical input from a mouse or cursor
            set(gcf,'Pointer','crosshair');
            if but == 1; %% left button is clicked
                pointx = xi;
                pointy = yi;
                ln = line(pointx,pointy,'marker','o','color','g',...
                    'LineStyle','none');
                daxX = (cax(2)-cax(1))/20; %%zoom in for 20 times
                daxY = (cax(4)-cax(3))/20; %%zoom in for 20 times
                axis(ax,[pointx+[-1 1]*daxX pointy+[-1 1]*daxY]);
            end

         while but ~= 3; %% right button is clicked
            [xi,yi,but] = ginput(1);    %Graphical input from a mouse or cursor
            set(gcf,'Pointer','crosshair');

            if but == 28; %%
                pointx=pointx-0.3;
                ln.XData=pointx;
                drawnow;
            elseif but == 30; %%
                pointy=pointy-0.3;
                ln.YData=pointy;
                drawnow;
            elseif but == 29; %%
                pointx=pointx+0.3;
                ln.XData = pointx;
                drawnow;
            elseif but == 31; %%
                pointy=pointy+0.3;
                ln.YData=pointy;
                drawnow;
            end
        end
        set(gcf,'Pointer','arrow'); %%this is important in order to return the pointer to arrow from crossline
        axis(ax,cax);   %%zoon out to the original setting

        if isfield(handles,'nSelectedPoints')
            handles.nSelectedPoints=handles.nSelectedPoints+1;
            handles.SelectedPoints(1,handles.nSelectedPoints)=pointx;
            handles.SelectedPoints(2,handles.nSelectedPoints)=pointy;
        else
            handles.nSelectedPoints=1;
            handles.SelectedPoints(1,handles.nSelectedPoints)=pointx;
            handles.SelectedPoints(2,handles.nSelectedPoints)=pointy;
        end
        set(handles.DisplayText,'String',['Selected    ',num2str(handles.nSelectedPoints),'   points']);

       guidata(hObject,handles);




% --- Executes on button press in CalMask.
function CalMask_Callback(hObject, eventdata, handles)
% hObject    handle to CalMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% this function is not updated in the 2023-06-17 version. 
    axes(handles.axes1);
    npoints=handles.nSelectedPoints;
    points=handles.SelectedPoints;
    set(handles.DisplayText,'String',['Selected    ',num2str(npoints),'   points']);
    image_t = get(handles.imagehandle,'CData');
    threshhold_value = str2num(get(handles.Threshhold,'String'));
    half_x = 7;
    half_y = 7;
    
    circlesize = str2num(get(handles.CircleSize,'String'));
    MaskPoints=[];
    switch npoints
        case 1  %one points selected
            p1=points(:,1);
            pointx = p1(1);
            pointy = p1(2);
            ln = line(pointx,pointy,'marker','o','color','m','LineStyle','none',...
                'MarkerSize',circlesize,'LineWidth',circlesize/10);
            MaskPoints(:,1)=[pointx;pointy];
            handles.MaskPoints=MaskPoints;
        case 2  %two points selected
            p1=points(:,1);
            p2=points(:,2);
            dis = sqrt((p1(1)-p2(1))^2+(p1(2)-p2(2))^2);
            vals = get(handles.Interdis,'String');
            interdistance = str2num(vals{1});
            nfeatures = round(dis/interdistance);
            prompt = {'#Features in the line'}; 
            dlg_title = 'Number of repeats';
            num_lines= 1;
            def     = {num2str(nfeatures)};
            answer  = inputdlg(prompt,dlg_title,num_lines,def); 
            NumFeatures = sscanf(answer{1},'%d');

            interdistance = dis/NumFeatures;
            hslope=(p2(2)-p1(2))/(p2(1)-p1(1));
            hintercept=p1(2)-hslope*p1(1);
            hinterdis_x=((p2(1)-p1(1)))/NumFeatures;
            MaskPoints=[];
            n=0;
            
            MaskPoints_x=zeros(NumFeatures+1,1);
            MaskPoints_y=zeros(NumFeatures+1,1);
            n=0;

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%             
                 %%%% this part is to plot out the theoretically calculated mask, for displayin purpose only %%%%%           
                           for h=1:NumFeatures+1
                                if h==1
                                    pointx = p1(1);
                                    pointy = p1(2);
                                else
                                    pointx = p1(1) + hinterdis_x*(h-1);
                                    pointy = p1(2) + hslope*hinterdis_x*(h-1);
                                end
                                ln = line(pointx,pointy,'marker','o','color','g','LineStyle','none',...
                                    'MarkerSize',circlesize,'LineWidth',circlesize/10);
                           end
                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%               
            
            for h=1:NumFeatures+1
                if h==1
                    pointx = p1(1);
                    pointy = p1(2);
                else
                    pointx = MaskPoints_x(h-1,1) + hinterdis_x;
                    pointy = MaskPoints_y(h-1,1) + hslope*hinterdis_x;
                end             
                leftx = max(1,round(pointx-half_x));
                rightx = min(numel(image_t(1,:)),round(pointx+half_x));
                lefty = max(1,round(pointy-half_y));
                righty = min(numel(image_t(:,1)),round(pointy+half_y));

                subimg = image_t(lefty:righty,...
                    leftx:rightx); %%note the x,y switch. This is double checked
                maxval = max(subimg(:));
                medval = median(subimg(:));
                if maxval-medval > threshhold_value
                    [Rowcenter, Colcenter] = find(subimg == maxval);
                    MaskPoints_x(h,1) = pointx-(half_x+1)+Colcenter(1); %%note the Colcenter in x position. This is validated.
                    MaskPoints_y(h,1) = pointy-(half_y+1)+Rowcenter(1);
                    n = n+1;
                    MaskPoints(:,n)=[pointx;pointy]; %%it's important to note that x and y are transposed in the array and in display
                    ln = line(pointx,pointy,'marker','o','color','m','LineStyle','none',...
                        'MarkerSize',circlesize,'LineWidth',circlesize/10); 
                else
                    MaskPoints_x(h,1) = pointx;
                    MaskPoints_y(h,1) = pointy;
                end
            end
           set(handles.Interdis,'String',{[num2str(interdistance,'%4.2f')];...
                [vals{2}]});
            handles.MaskPoints=MaskPoints;
            
        case 3  %3 points selected
            %% it is important the the horizontal line between p1 and p2 are defined as the x direction.
            %% the vertical line between p2 and p3 are defined as the y direction. 
            p1=points(:,1);
            p2=points(:,2);
            p3=points(:,3);
            
            prompt = {'#Features between 1-2 point','#Features between 1-3 points'}; 
            dlg_title = 'Number of repeats between points';
            num_lines= 1;
            dis12 = sqrt((p1(1)-p2(1))^2+(p1(2)-p2(2))^2);
            dis13 = sqrt((p3(1)-p1(1))^2+(p3(2)-p1(2))^2);
            vals = get(handles.Interdis,'String');
            interdistance_x = str2num(vals{1});
            interdistance_y = str2num(vals{2});
            nfeatures12 = round(dis12/interdistance_x); %%#repeats between points1 and points2
            nfeatures13 = round(dis13/interdistance_y); %%#repeats between points2 and points3
            def     = {num2str(nfeatures12),num2str(nfeatures13)};
            answer  = inputdlg(prompt,dlg_title,num_lines,def); 
            NumFeatures_x = sscanf(answer{1},'%d');
            NumFeatures_y = sscanf(answer{2},'%d');

            interdistance_x = dis12/NumFeatures_x; %%#recalculate interdistance_x from the input
            interdistance_y = dis13/NumFeatures_y;
            
            hslope=(p2(2)-p1(2))/(p2(1)-p1(1)); %%slope of the horizontal line
            hintercept=p1(2)-hslope*p1(1);
            hinterdis_x=((p2(1)-p1(1)))/NumFeatures_x;
            vslope=(p3(2)-p1(2))/(p3(1)-p1(1)); %%slope of the vertical line
            vintercept=p1(2)-vslope*p1(1);
            vinterdis_y=((p3(2)-p1(2)))/NumFeatures_y;

            MaskPoints_x=zeros(NumFeatures_x+1,NumFeatures_y+1);
            MaskPoints_y=zeros(NumFeatures_x+1,NumFeatures_y+1);
            n=0;

                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%             
                 %%%% this part is to plot out the theoretically calculated mask, for displayin purpose only %%%%%           
                           for h=1:NumFeatures_x+1
                                if h==1
                                    toppointx = p1(1);
                                    toppointy = p1(2);
                                else
                                    toppointx = p1(1) + hinterdis_x*(h-1);
                                    toppointy = p1(2) + hslope*hinterdis_x*(h-1);
                                end

                                for v=1:NumFeatures_y+1 
                                    pointx = toppointx + (v-1)*vinterdis_y/vslope;
                                    pointy = toppointy + (v-1)*vinterdis_y;
                                    ln = line(pointx,pointy,'marker','o','color','g','LineStyle','none',...
                                        'MarkerSize',circlesize,'LineWidth',circlesize/10);
                                end
                           end
                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%               
            
            for h=1:NumFeatures_x+1
                if h==1
                    pointx = p1(1);
                    pointy = p1(2);
                else
                    pointx = MaskPoints_x(h-1,1) + hinterdis_x;
                    pointy = MaskPoints_y(h-1,1) + hslope*hinterdis_x;
                end
                leftx = max(1,round(pointx-half_x));
                rightx = min(numel(image_t(1,:)),round(pointx+half_x));
                lefty = max(1,round(pointy-half_y));
                righty = min(numel(image_t(:,1)),round(pointy+half_y));
                subimg = image_t(lefty:righty,...
                    leftx:rightx); %%note the x,y switch. This is double checked
                maxval = max(subimg(:));
                medval = median(subimg(:));
                if maxval-medval > threshhold_value
                    [Rowcenter, Colcenter] = find(subimg == maxval);
                    MaskPoints_x(h,1) = pointx-(half_x+1)+Colcenter(1); %%note the Colcenter in x position. This is validated.
                    MaskPoints_y(h,1) = pointy-(half_y+1)+Rowcenter(1);
                else
                    MaskPoints_x(h,1) = pointx;
                    MaskPoints_y(h,1) = pointy;
                end

                toppointx = MaskPoints_x(h,1);
                toppointy = MaskPoints_y(h,1);
                
                for v=1:NumFeatures_y+1                                           
                        if v==1
                            pointx = toppointx;
                            pointy = toppointy;
                        elseif h==1
                            pointx = MaskPoints_x(h,v-1) + vinterdis_y/vslope;
                            pointy = MaskPoints_y(h,v-1) + vinterdis_y;
                        end
                        if (v>=2) & (h>=2)
                            pointx1 = MaskPoints_x(h-1,v) + hinterdis_x;
                            pointy1 = MaskPoints_y(h-1,v) + hslope*hinterdis_x;
                            pointx2 = MaskPoints_x(h,v-1) + vinterdis_y/vslope;
                            pointy2 = MaskPoints_y(h,v-1) + vinterdis_y;
                            pointx = (pointx1+pointx2)/2;
                            pointy = (pointy1+pointy2)/2;
                        end 
                        leftx = max(1,round(pointx-half_x));
                        rightx = min(numel(image_t(1,:)),round(pointx+half_x));
                        lefty = max(1,round(pointy-half_y));
                        righty = min(numel(image_t(:,1)),round(pointy+half_y));
                        subimg = image_t(lefty:righty,...
                            leftx:rightx); %%note the x,y switch. This is double checked
                
                        maxval = max(subimg(:));
                        medval = median(subimg(:));
                        [Rowcenter, Colcenter] = find(subimg == maxval);
                        if (maxval-medval > threshhold_value)
                            MaskPoints_x(h,v) = pointx-(half_x+1)+Colcenter(1); %%note the Colcenter in x position. This is validated.
                            MaskPoints_y(h,v) = pointy-(half_y+1)+Rowcenter(1); 
                        else
                            MaskPoints_x(h,v) = pointx;
                            MaskPoints_y(h,v) = pointy;
                        end                 

                        pointx=MaskPoints_x(h,v);
                        pointy=MaskPoints_y(h,v);
                        if (maxval-medval > threshhold_value) & (Colcenter-half_x-1)<6 & (Rowcenter-half_x-1)<6 
                            ln = line(pointx,pointy,'marker','o','color','m','LineStyle','none',...
                                    'MarkerSize',circlesize,'LineWidth',circlesize/10); 
                            n = n+1;
                            MaskPoints(:,n)=[pointx;pointy]; %%it's important to note that x and y are transposed in the array and in display
                        end
                end
            end
             
            set(handles.Interdis,'String',{[num2str(interdistance_x,'%4.2f')];...
                [num2str(interdistance_y,'%4.2f')]});
            
            handles.MaskPoints=MaskPoints;
    end
    
    guidata(hObject,handles);



% --- Executes on button press in TheoMask.
function TheoMask_Callback(hObject, eventdata, handles)
% hObject    handle to TheoMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% this function is completely revised by Bianxiao on 2023-06-17
    axes(handles.axes1);
    npoints=handles.nSelectedPoints;
    points=handles.SelectedPoints;
    set(handles.DisplayText,'String',['Selected    ',num2str(npoints),'   points']);
    imagesizex = handles.imagesizex;
    imagesizey = handles.imagesizey;
    ax = handles.axes1;
    cax = axis(ax); %%this is to get the limits of current axis. 

    circlesize = str2num(get(handles.CircleSize,'String'));
    MaskPoints=[];
    n=0;
    switch npoints   %%% number of maskpoints selected
        case 1  %one points selected, a single mask point
            p1=points(:,1);
            pointx = p1(1);
            pointy = p1(2);
            ln = line(pointx,pointy,'marker','o','color','g','LineStyle','none',...
                'MarkerSize',circlesize,'LineWidth',circlesize/10);
            MaskPoints(:,1)=[pointx;pointy];
            handles.MaskPoints=MaskPoints;
            guidata(hObject,handles);
        case 2  %two points selected, a line of mask points are calculated
            p1=points(:,1);
            p2=points(:,2);
            dis12 = sqrt((p2(1)-p1(1))^2+(p2(2)-p1(2))^2);
            vals = get(handles.Interdis,'String');
            interdistance_x = str2num(vals{1});
            interdistance_y = str2num(vals{2});
            nfeatures = round(dis12/interdistance_x);
            prompt = {'#Features in the line'}; 
            dlg_title = 'Number of repeats';
            num_lines= 1;
            def     = {num2str(nfeatures)};
            answer  = inputdlg(prompt,dlg_title,num_lines,def); 
            NumFeatures = sscanf(answer{1},'%d'); 
            MaskPoints=[];
            n=0;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%             
            %%%% this part is to calculate and plot out the theoretically calculated mask %%%%% 
                dis12_dis = dis12/NumFeatures; %%#recalculate pair interdistance from 1-2 pocations
                dis12_xdis = (p2(1)-p1(1))/NumFeatures;
                dis12_ydis = (p2(2)-p1(2))/NumFeatures;
                        pointx = p1(1);
                        pointy = p1(2); 
                        %% calculatign the number of musk points within the axis range
                        %% calculating from point(1)
                        numPoints_left = fix((p1(1)-cax(1))/dis12_xdis);
                        numPoints_right = fix((cax(2)-p1(1))/dis12_xdis);
                        
                        n=0; %% number of MaskPoints starts from 0
                        for i = -numPoints_left:numPoints_right
                                pointx = p1(1) + i*dis12_xdis;
                                pointy = p1(2) + i*dis12_ydis;
                                if pointx>0 & pointx<imagesizex & pointy>0 & pointy<imagesizey
                                    n = n+1;
                                    MaskPoints(:,n)=[pointx;pointy]; %%it's important to note that x and y are transposed in the array and in display
                                    ln = line(pointx,pointy,'marker','o','color','g','LineStyle','none',...
                                            'MarkerSize',circlesize,'LineWidth',circlesize/10); 
                                end
                        end
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

            set(handles.Interdis,'String',{[num2str(dis12_dis,'%4.2f')];...
                [vals{2}]});
            handles.MaskPoints=MaskPoints;
            guidata(hObject,handles);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%               
        case 3  %3 points selected
            %% it is important the the horizontal line between p1 and p2 are defined as the x direction.
            %% the vertical line between p2 and p3 are defined as the y direction. 
            p1=points(:,1); %% first selected point location
            p2=points(:,2); %% second selected point location
            p3=points(:,3); %% third selected point location
            
            prompt = {'#Features between 1-2 point','#Features between 1-3 points'}; 
            dlg_title = 'Number of repeats between points';
            num_lines= 1;
            dis12 = sqrt((p2(1)-p1(1))^2+(p2(2)-p1(2))^2);
            dis13 = sqrt((p3(1)-p1(1))^2+(p3(2)-p1(2))^2);
            vals = get(handles.Interdis,'String');
            interdistance_x = str2num(vals{1});
            interdistance_y = str2num(vals{2});
            nfeatures12 = round(dis12/interdistance_x); %%#repeats between points1 and points2
            nfeatures13 = round(dis13/interdistance_y); %%#repeats between points2 and points3
            def     = {num2str(nfeatures12),num2str(nfeatures13)};
            answer  = inputdlg(prompt,dlg_title,num_lines,def); 
            NumFeatures_x = sscanf(answer{1},'%d');
            NumFeatures_y = sscanf(answer{2},'%d');
          
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%             
         %%%% this part is to calculate and plot out the theoretically calculated mask %%%%% 
                dis12_dis = dis12/NumFeatures_x; %%#recalculate pair interdistance from 1-2 pocations
                dis12_xdis = (p2(1)-p1(1))/NumFeatures_x;
                dis12_ydis = (p2(2)-p1(2))/NumFeatures_x;
                dis13_dis = dis13/NumFeatures_y; %%#recalculate pair interdistance from 1-3 pocations
                dis13_xdis = (p3(1)-p1(1))/NumFeatures_y;
                dis13_ydis = (p3(2)-p1(2))/NumFeatures_y;
                        pointx = p1(1);
                        pointy = p1(2); 
                        %% calculatign the number of musk points within the axis range
                        %% calculating from point(1)
                        numPoints_left = fix((p1(1)-cax(1))/dis12_xdis);
                        numPoints_right = fix((cax(2)-p1(1))/dis12_xdis);
                        numPoints_top = fix((p1(2)-cax(3))/dis13_ydis);
                        numPoints_down = fix((cax(4)-p1(2))/dis13_ydis);
                        
                        n=0; %% number of MaskPoints starts from 0
                        for i = -numPoints_left:numPoints_right
                            for j = -numPoints_top:numPoints_down
                                pointx = p1(1) + i*dis12_xdis + j*dis13_xdis;
                                pointy = p1(2) + i*dis12_ydis + j*dis13_ydis;
                                if pointx>0 & pointx<imagesizex & pointy>0 & pointy<imagesizey
                                    n = n+1;
                                    MaskPoints(:,n)=[pointx;pointy]; %%it's important to note that x and y are transposed in the array and in display
                                    ln = line(pointx,pointy,'marker','o','color','g','LineStyle','none',...
                                            'MarkerSize',circlesize,'LineWidth',circlesize/10); 
                                end
                            end 
                        end
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
                 
            set(handles.Interdis,'String',{[num2str(dis12_dis,'%4.2f')];...
                [num2str(dis13_dis,'%4.2f')]});
            handles.MaskPoints=MaskPoints;
            guidata(hObject,handles);
    end



% --- Executes on button press in RemovePoint.
function RemovePoint_Callback(hObject, eventdata, handles)
% hObject    handle to RemovePoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
      set(handles.DisplayText,'String','Select a polygon left button. Right botton to stop.');
      MaskPoints = handles.MaskPoints;    %%it's important to note that x and y are switched when saved into MaskPoints
      n_MaskPoints = numel(MaskPoints(1,:));
      RemovePoints=[];
      numRemovePoints=0;
          %%% draw polygon around an area to be removed. 
            xy = [];
            n = 0;
            % Loop, picking up the points.
            but = 1;
            while but == 1
                [xi,yi,but] = ginput(1);    %Graphical input from a mouse or cursor
                n = n+1;
                xy(:,n) = [xi;yi];
                if n > 1 & but == 1
                    a = (xy(2,n)-xy(2,n-1))/(xy(1,n)-xy(1,n-1));
                    b = xy(2,n) - a*xy(1,n);
                    ln = line(xy(1,:),xy(2,:),'marker','o','color','g');           
                end
            end
            n=n-1;
            xy=round(xy(:,1:n));
            imagesizex = handles.imagesizex;
            imagesizey = handles.imagesizey;
            %%% create a polygon mask from the selected points. 
            mask_bw = poly2mask(xy(1,:), xy(2,:), imagesizex, imagesizey);
            %%% Identify the Maskpoint inside the polygon. 
            for p=1:n_MaskPoints
                xpos=round(MaskPoints(1,p));
                ypos=round(MaskPoints(2,p));
                if mask_bw(ypos, xpos)>0
                        numRemovePoints=numRemovePoints+1;
                        RemovePoints=[RemovePoints, p];
                        ln = line(xpos,ypos,'marker','o','color','g','LineStyle','none');
                end
            end
        %%% end of generating polygon mask  
        MaskPoints(:,RemovePoints)=[];
        handles.MaskPoints = MaskPoints;
        guidata(hObject,handles);
    
    
 
% --- Executes on button press in ShowMask.
function ShowMask_Callback(hObject, eventdata, handles)
% hObject    handle to ShowMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    axes(handles.axes1);
    if isfield(handles,'MaskPoints')
        axes(handles.axes1);
        MaskPoints=handles.MaskPoints;
        NumPoints=numel(MaskPoints(1,:));
        circlesize = str2num(get(handles.CircleSize,'String'));
        ln = line(round(MaskPoints(1,:)),round(MaskPoints(2,:)),'marker','o','color','m','LineStyle','none',...
                'MarkerSize',circlesize,'LineWidth',circlesize/10);
        NumPoints=numel(handles.MaskPoints(1,:));
        set(handles.DisplayText,'String',['# MaskPoints: ', num2str(NumPoints)]);
    else
        set(handles.DisplayText,'String',['No MaskPoints selected']);
    end
 

% --- Executes on button press in HideMask.
function HideMask_Callback(hObject, eventdata, handles)
% hObject    handle to HideMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        axes(handles.axes1);
        image_t = get(handles.imagehandle,'CData');
        axes(handles.axes1);
        ax=handles.axes1;
        cax=axis(ax);        
        handles.imagehandle=imshow(image_t);
        set(handles.axes1,'CLim',[get(handles.ColorSlider,'min') get(handles.ColorSlider,'value')]);
        axis(ax,handles.axrange);
        colormap(gray);
        guidata(hObject,handles);


% --- Executes on button press in ResetMask.
function ResetMask_Callback(hObject, eventdata, handles)
% hObject    handle to ResetMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        axes(handles.axes1);
        handles.nSelectedPoints=0;
        handles.SelectedPoints=[];
        handles.MaskPoints=[];
        if isfield(handles,'insideMaskPoints')
            handles.insideMaskPoints=[];
        end
        image_t = get(handles.imagehandle,'CData');
        axes(handles.axes1);
        handles.imagehandle=imshow(image_t);
        set(handles.axes1,'CLim',[get(handles.ColorSlider,'min') get(handles.ColorSlider,'value')]);
        colormap(gray);
        axis(handles.axes1,handles.axrange);
        set(handles.DisplayText,'String',{['Mask reseted'];['Selected 0 point']});
        guidata(hObject,handles);

  

function Interdis_Callback(hObject, eventdata, handles)
% hObject    handle to Interdis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Interdis as text
%        str2double(get(hObject,'String')) returns contents of Interdis as a double


% --- Executes during object creation, after setting all properties.
function Interdis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Interdis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Threshhold_Callback(hObject, eventdata, handles)
% hObject    handle to Threshhold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Threshhold as text
%        str2double(get(hObject,'String')) returns contents of Threshhold as a double


% --- Executes during object creation, after setting all properties.
function Threshhold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Threshhold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CircleSize_Callback(hObject, eventdata, handles)
% hObject    handle to CircleSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CircleSize as text
%        str2double(get(hObject,'String')) returns contents of CircleSize as a double


% --- Executes during object creation, after setting all properties.
function CircleSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CircleSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveMask.
function SaveMask_Callback(hObject, eventdata, handles)
% hObject    handle to SaveMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
      MaskPoints = handles.MaskPoints;
      NameInfo=handles.filename;
      temp = strrep(NameInfo,'.tif','.txt');
      temp = strrep(temp,'.TIF','.txt');
      [savefile,savepath]=uiputfile('*.txt','Save Mask Locations',['MaskLoc-',temp]);   
      if savefile ~= 0
           writematrix(MaskPoints,savefile);
      end

    
% --- Executes on button press in OpenMask.
function OpenMask_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    axes(handles.axes1);
    [filename,pathname]=uigetfile('MaskLoc-*','Load Mask location data','MultiSelect','on');
    cdirec = cd;
    cd(pathname);
    circlesize = str2num(get(handles.CircleSize,'String'));
     
    if iscell(filename)  %%if multiple files are selected
        LargeMask=[];
        for i=1:numel(filename)
            MaskPoints=dlmread(filename{i});
            if i==1
                LargeMask=MaskPoints;
            else
                LargeMask=cat(2,LargeMask,MaskPoints);
            end
        end
        %%% remove duplicated points due to overlap of multiple mask files   
        RemovePoints=[];
        n_MaskPoints = numel(LargeMask(1,:));
            for i=1:n_MaskPoints-1
                pointx = LargeMask(1,i);
                pointy = LargeMask(2,i);
                for j=i+1:n_MaskPoints
                    dis_ij=sqrt((LargeMask(1,j)-pointx)^2+(LargeMask(2,j)-pointy)^2);
                        if dis_ij < circlesize/2
                            RemovePoints = [RemovePoints,j];
                        end
                end
            end
            LargeMask(:,RemovePoints)=[];          
        ln = line(LargeMask(1,:),LargeMask(2,:),'marker','o','color','g','LineStyle','none'); 
        handles.MaskPoints=LargeMask;    
    else
        MaskPoints=dlmread(filename);
        ln = line(MaskPoints(1,:),MaskPoints(2,:),'marker','o','color','g','LineStyle','none'); 
        handles.MaskPoints=MaskPoints;
    end
    
    guidata(hObject,handles);

  
% --- Executes on button press in InsideCell.
function InsideCell_Callback(hObject, eventdata, handles)
% hObject    handle to InsideCell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        image_t = get(handles.imagehandle,'CData');
        MaskPoints=handles.MaskPoints;
        goodpoints=0;
        goodMaskPoints=[];

        NumPoints=numel(MaskPoints(1,:));
        circlesize = str2num(get(handles.CircleSize,'String'));
        halfrange = round(circlesize/2);
        masksize = halfrange*2+1;
        subimg=zeros(masksize,masksize);
        Threshhold_value = str2num(get(handles.Threshhold,'String'));

        %%% draw polygon around a single cell. 
            xy = [];
            n = 0;
            % Loop, picking up the points.
            but = 1;
            while but == 1
                [xi,yi,but] = ginput(1);    %Graphical input from a mouse or cursor
                n = n+1;
                xy(:,n) = [xi;yi];
                if n > 1 & but == 1
                    a = (xy(2,n)-xy(2,n-1))/(xy(1,n)-xy(1,n-1));
                    b = xy(2,n) - a*xy(1,n);
                    ln = line(xy(1,:),xy(2,:),'marker','o','color','w');           
                end
            end
            n=n-1;
            xy=round(xy(:,1:n));
            imagesizex = handles.imagesizex;
            imagesizey = handles.imagesizey;
            %%% create a polygon mask from the selected points. 
            mask_bw = poly2mask(xy(1,:), xy(2,:), imagesizex, imagesizey);
            masked_image = mask_bw.*image_t;
            %%% Identify the Maskpoint inside the polygon. 
            for p=1:NumPoints
                xpos=round(MaskPoints(1,p));
                ypos=round(MaskPoints(2,p));
                if xpos>=halfrange+1 & xpos<=handles.imagesizey-halfrange &...
                        ypos>=halfrange+1 & ypos<=handles.imagesizex-halfrange 
                    subimg = double(image_t(ypos-halfrange:ypos+halfrange,xpos-halfrange:xpos+halfrange));
                    if mean(mean(subimg))>Threshhold_value &mask_bw(ypos, xpos)>0
                        goodpoints=goodpoints+1;
                        goodMaskPoints(:,goodpoints)=[xpos;ypos];
                    end
                end
            end
        %%% end of generating polygon mask
        NumPoints=numel(goodMaskPoints(1,:));
        handles.MaskPoints=goodMaskPoints;
        handles.imagehandle=imshow(masked_image,[]); %%do not transpose
        ln = line(goodMaskPoints(1,:),goodMaskPoints(2,:),'marker','o','color','y','LineStyle','none',...
                'MarkerSize',circlesize,'LineWidth',circlesize/10);
        guidata(hObject,handles);

   
% --- Executes on button press in CalBackground.
function CalBackground_Callback(hObject, eventdata, handles)
% hObject    handle to CalBackground (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    axes(handles.axes1);
        image_t = get(handles.imagehandle,'CData');
        %%% draw polygon around a single cell. 
            xy = [];
            n = 0;
            % Loop, picking up the points.
            but = 1;
            while but == 1
                [xi,yi,but] = ginput(1);    %Graphical input from a mouse or cursor
                n = n+1;
                xy(:,n) = [xi;yi];
                if n > 1 & but == 1
                    a = (xy(2,n)-xy(2,n-1))/(xy(1,n)-xy(1,n-1));
                    b = xy(2,n) - a*xy(1,n);
                    ln = line(xy(1,:),xy(2,:),'marker','o','color','y','EraseMode','background');           
                end
            end
            n=n-1;
            xy=round(xy(:,1:n));
            imagesizex = handles.imagesizex;
            imagesizey = handles.imagesizey;
            %%% create a polygon mask from the selected points. 
            mask_bw = poly2mask(xy(1,:), xy(2,:), imagesizex, imagesizey);
            masked_image = mask_bw.*image_t;
         %%% end of generating polygon mask
            wpos = find(mask_bw > 0);
            bkgr_value = mean(image_t(wpos));
        set(handles.DisplayText,'String',['Bkgr valueclcc: ', num2str(bkgr_value)]);
        vals = get(handles.Interdis,'String');
        interdistance_x = str2num(vals{1});
        interdistance_y = str2num(vals{2});
        circlesize = str2num(get(handles.CircleSize,'String'));
        BkgrInfo = [interdistance_x, interdistance_y, circlesize, bkgr_value];
        NameInfo=handles.filename;
        temp = strrep(NameInfo,'.tif','.txt');
        temp = strrep(temp,'.TIF','.txt');        
        %%[savefile,savepath]=uiputfile('*.txt','Save Mask Locations',['BkgrInfo-',temp]);
        savefile = ['BkgrInfo-',temp];
        if savefile ~= 0
           writematrix(BkgrInfo,savefile);
        end       
        handles.bkgr_value=bkgr_value;
        guidata(hObject,handles);
    
    
% --- Executes on button press in MaskAverage.
function MaskAverage_Callback(hObject, eventdata, handles)
% hObject    handle to MaskAverage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        axes(handles.axes1);
        image_t = get(handles.imagehandle,'CData');
        MaskPoints=handles.MaskPoints;
        NumPoints=numel(MaskPoints(1,:));
        circlesize = str2num(get(handles.CircleSize,'String'));
        halfrange = round(circlesize/2);
        masksize = halfrange*2+1;
        MaskAvg=zeros(masksize,masksize);
        ngoodpoints=0;
        for p=1:NumPoints
            xpos=round(MaskPoints(1,p));
            ypos=round(MaskPoints(2,p));
            if xpos>=halfrange+1 & xpos<=handles.imagesizey-halfrange &...
                    ypos>=halfrange+1 & ypos<=handles.imagesizex-halfrange 
                MaskAvg = MaskAvg + double(image_t(ypos-halfrange:ypos+halfrange,...
                    xpos-halfrange:xpos+halfrange)); %% note the x,y transpose
                ngoodpoints=ngoodpoints+1;
            end
        end
    
        axes(handles.axes2);
        image_t = MaskAvg/ngoodpoints;
        imshow(image_t,[]);
        handles.MaskAvg = image_t;
        axes(handles.axes1);
    guidata(hObject,handles);

% --- Executes on button press in SaveMaskAvg.
function SaveMaskAvg_Callback(hObject, eventdata, handles)
% hObject    handle to SaveMaskAvg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        NameInfo=handles.filename;
        [filename,pathname]=uiputfile('.TIF','Save Mask Avg image ',['MaskAvg-',NameInfo]);
        cdirec = cd;
        cd(pathname);
        maskavg = handles.MaskAvg;
        maskavg=uint16(maskavg); %%convert the array into uint16 for saving as a .tif file.
        imwrite(maskavg,filename,'TIF');

        
% --- Executes on button press in OpenMaskAvg.
function OpenMaskAvg_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMaskAvg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %%% readout previously saved MaskAvg image
        fclose all;
       [datafile,datapath]=uigetfile('MaskAvg-*','Choose a Mask Avg image');
        if datafile==0, return; end
        cd(datapath);
        AvgImg = imread(datafile);

    %%% display the previously saved MaskAvg image
        axes(handles.axes2);
        image_t = AvgImg;
        imshow(image_t,[]);
        handles.MaskAvg = image_t;
        handles.MaskAvgFilename = datafile;
        set(handles.DisplayText,'String',{['Open a MaskAvg file:'];...
            [datafile]});
    guidata(hObject,handles);


% --- Executes on button press in NanopillarMask.
function NanopillarMask_Callback(hObject, eventdata, handles)
% hObject    handle to NanopillarMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %%% readout previously saved MaskAvg image
        [datafile,datapath]=uigetfile('BkgrInfo-*','Choose the background info file');
        bkgrInfo = readmatrix(datafile);
        interdis = bkgrInfo(2);
        bkgr_value = bkgrInfo(4);
        AvgImg = handles.MaskAvg;
        sz = size(AvgImg);
        imagesizex=sz(1);
        imagesizey=sz(2);
            
    %%% create a mask for the center nanopillar and the surrounding %%%
    %%% the input parameter is CircleSize and interdis %%%%
        set(handles.DisplayText,'String','Select the nanopillar center');
            [xi,yi,but] = ginput(1);    %Graphical input from a mouse or cursor
            set(gcf,'Pointer','crosshair');
            if but == 1; %% left button is clicked
                pointx = xi;
                pointy = yi;
                ln = line(pointx,pointy,'marker','o','color','g',...
                    'LineStyle','none');
            end
             while but ~= 3; %% right button is clicked
                %%set(handles.DisplayText,'String',but);
                [xi,yi,but] = ginput(1);    %Graphical input from a mouse or cursor
                set(gcf,'Pointer','crosshair');

                if but == 28; %%
                    pointx=pointx-0.3;
                    ln.XData=pointx;
                    drawnow;
                elseif but == 30; %%
                    pointy=pointy-0.3;
                    ln.YData=pointy;
                    drawnow;
                elseif but == 29; %%
                    pointx=pointx+0.3;
                    ln.XData=pointx;
                    drawnow;
                elseif but == 31; %%
                    pointy=pointy+0.3;
                    ln.YData=pointy;
                    drawnow;
                end
             end 
                center_y = pointx; %% note the x y switch
                center_x = pointy;   
                
        %%% create a mask for the center %%%
            circlesize = str2num(get(handles.CircleSize,'String'));
            halfrange = round(circlesize/2);
            masksize = halfrange*2+1;
            MaskAvg=zeros(masksize,masksize);
            nanopillarMask = zeros(imagesizex,imagesizey);
            for i=1:imagesizex
                 for j=1:imagesizey
                     x_dis = i - center_x;
                     y_dis = j - center_y;
                     dis = sqrt(x_dis^2 + y_dis^2);
                     if dis<halfrange
                         nanopillarMask(i,j) = 1;
                     end
                 end
            end
        %%% create a mask for suroundings %%%
        %%% the input parameter is CircleSize and Interdis %%%%%
% %             vals = get(handles.Interdis,'String');
% %             interdistance_x = str2num(vals{1});
% %             interdistance_y = str2num(vals{2});
% %             interdistance = min(interdistance_x, interdistance_y);
            interdistance = interdis;
            if interdistance < 2*circlesize 
                set(handles.DisplayText,'String','Circlesize is too large!');
                return;
            end

            surroundingMask = zeros(imagesizex,imagesizey);
             for i=1:imagesizex
                 for j=1:imagesizey
                     x_dis = i - center_x;
                     y_dis = j - center_y;
                     dis = sqrt(x_dis^2 + y_dis^2);
                     if dis>circlesize & dis<(interdistance-circlesize)
                         surroundingMask(i,j) = 1;
                     end
                 end
             end
        nanopillarMask_AvgImg = double(nanopillarMask).*double(AvgImg);  
            temp = nanopillarMask_AvgImg(nanopillarMask_AvgImg~=0);
            nanopillar_mean = mean(temp);
        surroundingMask_AvgImg = double(surroundingMask).*double(AvgImg);
            temp = surroundingMask_AvgImg(surroundingMask_AvgImg~=0);
            surrounding_mean = mean(temp); 
        ratio = (nanopillar_mean-bkgr_value)/(surrounding_mean-bkgr_value);
                       
        axes(handles.axes3);
        totalMask = nanopillarMask_AvgImg + surroundingMask_AvgImg;
        low=min(min(AvgImg));
        high=max(max(AvgImg));
        imshow(totalMask,[low*0.98 high*1.02]);
        set(handles.DisplayText,'String',{['Nanopillar: ', num2str(fix(nanopillar_mean))];...
            ['Surrounding: ', num2str(fix(surrounding_mean))];...
            ['Background: ', num2str(fix(bkgr_value))];...
            ['Ratio: ', num2str(ratio)];});
       
             NameInfo= handles.MaskAvgFilename; %%datafile contains the name of the MaskAvg file. 
             temp = strrep(NameInfo,'.tif','.txt');
             temp = strrep(temp,'.TIF','.txt');
             savefile = ['PillarRatioAnalysis-',temp];
             PillarRatioInfo = [nanopillar_mean, surrounding_mean, bkgr_value, ratio]; %%4-element array
             %%[savefile,savepath]=uiputfile('*.txt','Save nanopillar ratio infomation',['PillarRatioInfo-',temp]);
             if savefile ~= 0
                 writematrix(PillarRatioInfo,savefile);
             end
        
        
     handles.nanopillarMask = nanopillarMask;
     handles.surroundingMask = surroundingMask;
     handles.bkgrInfo = bkgrInfo;
     guidata(hObject,handles);



% --- Executes on button press in IndividualNanopillar.
function IndividualNanopillar_Callback(hObject, eventdata, handles)
% hObject    handle to IndividualNanopillar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        axes(handles.axes1);
         image_t = get(handles.imagehandle,'CData');   
        if isfield(handles,'MaskPoints')
            imshow(image_t,[]);
            MaskPoints=handles.MaskPoints;
            NumPoints=numel(MaskPoints(1,:));
            circlesize = str2num(get(handles.CircleSize,'String'));
            ln = line(round(MaskPoints(1,:)),round(MaskPoints(2,:)),'marker','o','color','m','LineStyle','none',...
                    'MarkerSize',circlesize,'LineWidth',circlesize/10);
            set(handles.DisplayText,'String',['# MaskPoints: ', num2str(NumPoints)]);
        else
            set(handles.DisplayText,'String',['No MaskPoints selected']);
        end
     
     AvgImg = handles.MaskAvg;
     sz=size(AvgImg);
     subImg = zeros(sz);
     nanopillarMask = handles.nanopillarMask;
     surroundingMask = handles.surroundingMask;
     bkgrInfo = handles.bkgrInfo;
     interdis = bkgrInfo(2);
     bkgr_value = bkgrInfo(4);
 
     halfrange = round((sz(1)-1)/2);
     ngoodpoints=0;
     individual_analysis = [];
     for p=1:NumPoints
         xpos=round(MaskPoints(1,p));
         ypos=round(MaskPoints(2,p));
         if xpos>=halfrange+1 & xpos<=handles.imagesizey-halfrange &...
                 ypos>=halfrange+1 & ypos<=handles.imagesizex-halfrange
             subImg = double(image_t(ypos-halfrange:ypos+halfrange,xpos-halfrange:xpos+halfrange));
             ngoodpoints=ngoodpoints+1;
             nanopillarMask_subImg = double(nanopillarMask).*double(subImg);
             temp = nanopillarMask_subImg(nanopillarMask_subImg~=0);
             nanopillar_mean = mean(temp);
             surroundingMask_subImg = double(surroundingMask).*double(subImg);
             temp = surroundingMask_subImg(surroundingMask_subImg~=0);
             surrounding_mean = mean(temp);
             ratio = (nanopillar_mean-bkgr_value)/(surrounding_mean-bkgr_value);
             individual_analysis = [individual_analysis;[p,xpos,ypos,nanopillar_mean,surrounding_mean, ratio]];
             ngoopoints=ngoodpoints+1;
                % % % figure(1) %% for checking invididual subImg. 
                % % % imshow(subImg,[])
                % % % figure(2)
                % % % imshow(nanopillarMask_subImg,[])
                % % % figure(3)
                % % % totalMask = nanopillarMask + surroundingMask;
                % % % total_subImg = double(totalMask).*double(subImg);
                % % % imshow(total_subImg,[]);
         end
     end
     NameInfo=handles.filename;
     temp = strrep(NameInfo,'.tif','.txt');
     temp = strrep(temp,'.TIF','.txt');
     [savefile,savepath]=uiputfile('*.txt','Save Mask Locations',['IndividalPillarAnalysis-',temp]);
     if savefile ~= 0
         writematrix(individual_analysis,savefile);
     end
     
     nanopillar_mean = mean(individual_analysis(:,4));
     surrounding_mean = mean(individual_analysis(:,5));
     ratio_mean = mean(individual_analysis(:,6));
     set(handles.DisplayText,'String',{['Npoints: ', num2str(fix(ngoodpoints))];...
         ['Nanopillar: ', num2str(fix(nanopillar_mean))];...
         ['Surrounding: ', num2str(fix(surrounding_mean))];...
         ['Ratio: ', num2str(ratio_mean)];});

guidata(hObject,handles);




% --- Executes on button press in NanobarMask.
function NanobarMask_Callback(hObject, eventdata, handles)
% hObject    handle to NanobarMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %%% readout previously saved MaskAvg image
        [datafile,datapath]=uigetfile('BkgrInfo-*','Choose the background info file');
        bkgrInfo = readmatrix(datafile);
        interdis = bkgrInfo(2);
        bkgr_value = bkgrInfo(4);
        
        AvgImg = handles.MaskAvg;
        sz = size(AvgImg);
        imagesizex=sz(1);
        imagesizey=sz(2);

     %%%% select the left nanobar end
            set(handles.DisplayText,'String','Select the left nanobar end');
                [xi,yi,but] = ginput(1);    %Graphical input from a mouse or cursor
                set(gcf,'Pointer','crosshair');
                if but == 1; %% left button is clicked
                    pointx = xi;
                    pointy = yi;
                    ln = line(pointx,pointy,'marker','o','color','g',...
                        'LineStyle','none');
                end                
             while but ~= 3; %% right button is clicked
                %%set(handles.DisplayText,'String',but);
                [xi,yi,but] = ginput(1);    %Graphical input from a mouse or cursor
                set(gcf,'Pointer','crosshair');

                if but == 28; %%
                    pointx=pointx-0.3;
                    ln.XData=pointx;
                    drawnow;
                elseif but == 30; %%
                    pointy=pointy-0.3;
                    ln.YData=pointy;
                    drawnow;
                elseif but == 29; %%
                    pointx=pointx+0.3;
                    ln.XData=pointx;
                    drawnow;
                elseif but == 31; %%
                    pointy=pointy+0.3;
                    ln.YData=pointy;
                    drawnow;
                end
             end 
            leftend_y = pointx; %% note the x y switch
            leftend_x = pointy;
     %%%% select the right nanobar end
            set(handles.DisplayText,'String','Select the right nanobar end');
                [xi,yi,but] = ginput(1);    %Graphical input from a mouse or cursor
                set(gcf,'Pointer','crosshair');
                if but == 1; %% left button is clicked
                    pointx = xi;
                    pointy = yi;
                    ln = line(pointx,pointy,'marker','o','color','g',...
                       'LineStyle','none');
                end
             while but ~= 3; %% right button is clicked
                %%set(handles.DisplayText,'String',but);
                [xi,yi,but] = ginput(1);    %Graphical input from a mouse or cursor
                set(gcf,'Pointer','crosshair');
                if but == 28; %%
                    pointx=pointx-0.3;
                    ln.XData=pointx;
                    drawnow;
                elseif but == 30; %%
                    pointy=pointy-0.3;
                    ln.YData=pointy;
                    drawnow;
                elseif but == 29; %%
                    pointx=pointx+0.3;
                    ln.XData=pointx;
                    drawnow;
                elseif but == 31; %%
                    pointy=pointy+0.3;
                    ln.YData=pointy;
                    drawnow;
                end
             end  
            rightend_y = pointx;  %% note the x y switch
            rightend_x = pointy;   
                   
    %%%% create the nanobara ends mask
        %%% the input parameter is CircleSize. create the nanobar end masks %%%%
        circlesize = str2num(get(handles.CircleSize,'String'));
        halfrange = round(circlesize/2);
        masksize = halfrange*2+1;
        endMask = zeros(imagesizex,imagesizey);
            for i=1:imagesizex
                 for j=1:imagesizey
                     x_dis = i - leftend_x;
                     y_dis = j - leftend_y;
                     dis = sqrt(x_dis^2 + y_dis^2);
                     if dis<halfrange
                         endMask(i,j) = 1;
                     end
                 end
            end        
            for i=1:imagesizex
                 for j=1:imagesizey
                     x_dis = i - rightend_x;
                     y_dis = j - rightend_y;
                     dis = sqrt(x_dis^2 + y_dis^2);
                     if dis<halfrange
                         endMask(i,j) = 1;
                     end
                 end
            end        
        inverse_endMask = (-1.0)*(endMask-1);
    
    %%%% create the sidewall mask  
            side_to_center = 2; %%pixels
            x1 = leftend_x;
            y1 = leftend_y;
            x2 = rightend_x;
            y2 = rightend_y;
            dis_p12 = sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2);
            x_mid = (x1+x2)/2;
            y_mid = (y1+y2)/2;
            sideMask = zeros(imagesizex,imagesizey);
            for i=1:imagesizex
                 for j=1:imagesizey
                     x3 = i;
                     y3 = j;
                     numerator = abs((x2 - x1) * (y1 - y3) - (x1 - x3) * (y2 - y1));
                     denominator = sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2); %% denominator is the dis_p12;
                     distance = numerator ./ denominator; %% distance from point to line
 
                     dis2center = sqrt((i-x_mid)^2 + (j-y_mid)^2); 
                     if distance>2 & distance <=4 &...
                             dis2center < dis_p12/2-circlesize
                         sideMask(i,j) = 1;
                     end                     
% %                      if distance>2 & distance <=4 &...
% %                              j>y1+circlesize+4 & j<y2-circlesize-4
% %                          sideMask(i,j) = 1;
% %                      end
                 end
            end 
        inverse_sideMask = (-1.0)*(sideMask-1);
        
        axes(handles.axes3);
        totalMask = double(inverse_sideMask + inverse_endMask).*double(AvgImg)/2;
        low=min(min(AvgImg));
        high=max(max(AvgImg));
        imshow(totalMask,[low*0.98 high*1.02]);          
        
        endMask_AvgImg = double(endMask).*double(AvgImg);  
            temp = endMask_AvgImg(endMask_AvgImg~=0);
            end_mean = mean(temp);
        sideMask_AvgImg = double(sideMask).*double(AvgImg);
            temp = sideMask_AvgImg(sideMask_AvgImg~=0);
            side_mean = mean(temp);
        ratio = (end_mean-bkgr_value)/(side_mean-bkgr_value);
        set(handles.DisplayText,'String',{['Nanobar End: ', num2str(fix(end_mean))];...
            ['Nanobar Side: ', num2str(fix(side_mean))];...
            ['bkgr: ', num2str(fix(bkgr_value))];...
            ['end/side Ratio: ', num2str(ratio)];});  
        
             NameInfo= handles.MaskAvgFilename; %%datafile contains the name of the MaskAvg file. 
             temp = strrep(NameInfo,'.tif','.txt');
             temp = strrep(temp,'.TIF','.txt');
             savefile = ['BarRatioAnalysis-',temp];
             BarRatioInfo = [end_mean, side_mean, bkgr_value, ratio]; %%4-element array
             %%[savefile,savepath]=uiputfile('*.txt','Save nanopillar ratio infomation',['PillarRatioInfo-',temp]);
             if savefile ~= 0
                 writematrix(BarRatioInfo,savefile);
             end
     handles.endMask = endMask;
     handles.sideMask = sideMask;
     handles.bkgrInfo = bkgrInfo;
     guidata(hObject,handles);


% --- Executes on button press in IndividualNanobar.
function IndividualNanobar_Callback(hObject, eventdata, handles)
% hObject    handle to IndividualNanobar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %%% readout previously saved MaskAvg image
        axes(handles.axes1);
         image_t = get(handles.imagehandle,'CData');   
        if isfield(handles,'MaskPoints')
            imshow(image_t,[]);
            MaskPoints=handles.MaskPoints;
            NumPoints=numel(MaskPoints(1,:));
            circlesize = str2num(get(handles.CircleSize,'String'));
            ln = line(round(MaskPoints(1,:)),round(MaskPoints(2,:)),'marker','o','color','m','LineStyle','none',...
                    'MarkerSize',circlesize,'LineWidth',circlesize/10);
            set(handles.DisplayText,'String',['# MaskPoints: ', num2str(NumPoints)]);
        else
            set(handles.DisplayText,'String',['No MaskPoints selected']);
            return
        end       

     AvgImg = handles.MaskAvg;
     sz=size(AvgImg)
     subImg = zeros(sz);
     endMask = handles.endMask;
     sideMask = handles.sideMask;        
     bkgrInfo = handles.bkgrInfo;
     interdis = bkgrInfo(2);
     bkgr_value = bkgrInfo(4);        
     halfrange = round((sz(1)-1)/2);
     ngoodpoints=0;
     individual_analysis = [];
     for p=1:NumPoints
         xpos=round(MaskPoints(1,p));
         ypos=round(MaskPoints(2,p));
         if xpos>=halfrange+1 & xpos<=handles.imagesizey-halfrange &...
                 ypos>=halfrange+1 & ypos<=handles.imagesizex-halfrange
             subImg = double(image_t(ypos-halfrange:ypos+halfrange,xpos-halfrange:xpos+halfrange));
             ngoodpoints=ngoodpoints+1;
             endMask_subImg = double(endMask).*double(subImg);
             temp = endMask_subImg(endMask_subImg~=0);
             end_mean = mean(temp);
             sideMask_subImg = double(sideMask).*double(subImg);
             temp = sideMask_subImg(sideMask_subImg~=0);
             side_mean = mean(temp);
             ratio = (end_mean-bkgr_value)/(side_mean-bkgr_value);
             individual_analysis = [individual_analysis;[p,xpos,ypos,end_mean,side_mean, ratio]];
             ngoopoints=ngoodpoints+1;
                % % % figure(1) %% for checking invididual subImg. 
                % % % imshow(subImg,[])
                % % % figure(2)
                % % % imshow(endMask_subImg,[])
                % % % figure(3)
                % % % totalMask = endMask + sideMask;
                % % % total_subImg = double(totalMask).*double(subImg);
                % % % imshow(total_subImg,[]);
         end
     end
      NameInfo= handles.MaskAvgFilename; %%datafile contains the name of the MaskAvg file. 
     temp = strrep(NameInfo,'.tif','.txt');
     temp = strrep(temp,'.TIF','.txt');
     [savefile,savepath]=uiputfile('*.txt','Save Mask Locations',['IndividalBarAnalysis-',temp]);
     if savefile ~= 0
         writematrix(individual_analysis,savefile);
     end
     
     end_mean = mean(individual_analysis(:,4));
     side_mean = mean(individual_analysis(:,5));
     ratio_mean = mean(individual_analysis(:,6));
     set(handles.DisplayText,'String',{['Npoints: ', num2str(fix(ngoodpoints))];...
         ['Nanobar end: ', num2str(fix(end_mean))];...
         ['Nanobar side: ', num2str(fix(side_mean))];...
         ['end/side Ratio: ', num2str(ratio_mean)];});
guidata(hObject,handles);    


%%%%%%%%%%%%%%%% End of Mask Construction %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Z-Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in PlotZ.
function PlotZ_Callback(hObject, eventdata, handles)
% hObject    handle to PlotZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% PlotZ is working well. 

    h=impixelinfo;  
    delete(h);      %%these two lines to prevent an annoying small 'pixel info' window when right click
    
    ax=handles.axes1;
    cax=axis(ax);   %%get the current axis limits
    circlesize = str2num(get(handles.CircleSize,'String'));
    
    %%%%% selecting a point in the image using mouse 
    set(handles.DisplayText,'String','Select a point using left button');
        [xi,yi,but] = ginput(1);    %Graphical input from a mouse or cursor
        set(gcf,'Pointer','crosshair');
        if but == 1
            pointx = xi;
            pointy = yi;
            ln = line(pointx,pointy,'marker','o','color','g',...
                'EraseMode','background','LineStyle','none');
            daxX = (cax(2)-cax(1))/20/2; %%zoom in for 10 times
            daxY = (cax(4)-cax(3))/20/2; %%zoom in for 10 times
            axis(ax,[pointx+[-1 1]*daxX pointy+[-1 1]*daxY]);
        end
        
        circlesize = str2num(get(handles.CircleSize,'String'));
     while but ~= 3
        set(handles.DisplayText,'String',but);
        [xi,yi,but] = ginput(1);    %Graphical input from a mouse or cursor
        set(gcf,'Pointer','crosshair');
        
        if but == 28
            delete(ln);
            pointx=pointx-0.3;
            ln = line(pointx,pointy,'marker','o','color','g',...
                'EraseMode','background','LineStyle','none', ...
                'MarkerSize',circlesize,'LineWidth',circlesize/10);
        elseif but == 30
            delete(ln);
            pointy=pointy-0.3;
            ln = line(pointx,pointy,'marker','o','color','g',...
                'EraseMode','background','LineStyle','none', ...
                'MarkerSize',circlesize,'LineWidth',circlesize/10);
        elseif but == 29
            delete(ln);
            pointx=pointx+0.3;
            ln = line(pointx,pointy,'marker','o','color','g',...
                'EraseMode','background','LineStyle','none', ...
                'MarkerSize',circlesize,'LineWidth',circlesize/10);
        elseif but == 31
            delete(ln);
            pointy=pointy+0.3;
             ln = line(pointx,pointy,'marker','o','color','g',...
                'EraseMode','background','LineStyle','none',...
                'MarkerSize',circlesize,'LineWidth',circlesize/10);
        end
    end
    set(gcf,'Pointer','arrow'); %%this is important in order to return the pointer to arrow from crossline
    axis(ax,cax);   %%zoon out to the original setting
        
  
        imagesizex = handles.imagesizex;
        imagesizey = handles.imagesizey;
        NumFrames = handles.NumFrames;
        Data = handles.Data;
        intensity=zeros(2,NumFrames);
        
        xpos = round(pointx);
        avg_range=5;
        half_range=floor((avg_range-1)/2);
        xmax = min(imagesizey, xpos+half_range);
        xmin = max(1, xpos-half_range);
        ypos = round(pointy);
        ymax = min(imagesizex, ypos+half_range);
        ymin = max(1, ypos-half_range);
             
    for fr=1:NumFrames
        subarray1 = Data(ymin:ymax,xmin:xmax,fr);
        intensity(1,fr)=sum(sum(subarray1))/(xmax-xmin+1)/(ymax-ymin+1);
    end
    
    axes(handles.axes3);
    plot(intensity(1,:),'.-r');
            set( findobj(gca,'typehFig','line'), 'LineWidth', 1);
            set(gca, 'FontName', 'Arial');
            set(gca, 'FontSize', 8);
            title('Intensity vs. Time Trace');
            xlabel('time (frame)');
            ylabel('Intensity');
    
   axes(handles.axes1);
   guidata(hObject,handles);

   

% --- Executes on button press in MaskKymo.
function MaskKymo_Callback(hObject, eventdata, handles)
% hObject    handle to MaskKymo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    fclose all;
    imagesizex=handles.imagesizex;
    imagesizey=handles.imagesizey;
    NumFrames=handles.NumFrames;

    MaskPoints=handles.MaskPoints;
    NumPoints=numel(MaskPoints(1,:));
    
    Line_Pixels=11; %% draw a short line of 11 pixels crossing each maskpoint
    str = get(handles.LinePixels,'String'); %str is cell type.
    Pixels_x = str2num(char(str(1)));     %convert to char then to number
    Pixels_y = str2num(char(str(2)));
    OffPoint_x=round((Pixels_x-1)/2);
    OffPoint_y=round((Pixels_y-1)/2);
    
    
    numPixels=max(OffPoint_x*2+1,OffPoint_y*2+1)+1; %%it's a even number
    kymo = zeros(NumFrames,NumPoints*numPixels);
    
    for i=1:NumFrames
        img=squeeze(handles.Data(:,:,i));
        val = median(median(img));
        kymo(i,:)=val; %%median value, background
        for j=1:NumPoints
            markerpoint = (j-1)*numPixels;    %% the starting point in the large array for each MaskPoint
            if Pixels_x>=Pixels_y
                for k=1:numPixels-1
                    xpos = MaskPoints(1,j)+k-OffPoint_x;
                    ymin = max(1,MaskPoints(2,j)-OffPoint_x); %%note the mismatch. This is important. 
                    ymax = min(imagesizex, MaskPoints(2,j)+OffPoint_x);
                    kymo(i,markerpoint+k)=sum(img(ymin:ymax,xpos))/(ymax-ymin+1);
                end
            else
                for k=1:numPixels-1
                    ypos = MaskPoints(2,j)+k-OffPoint_y;
                    xmin = max(1,MaskPoints(1,j)-OffPoint_y);
                    xmax = min(imagesizey,MaskPoints(1,j)+OffPoint_y);
                    kymo(i,markerpoint+k)=sum(img(ypos, xmin:xmax))/(xmax-xmin+1);
                end
            end
        end
    end
    
%         [filename,pathname]=uiputfile('.tif','Save all Mask Points ',['MaskKymo-',NameInfo]);
%         imwrite(kymo,filename,'tif');
%                 NameInfo=strrep(handles.filename,'.tif','.tif');
% 

axes(handles.axes3);       
imshow(kymo,[]);
   axes(handles.axes1);
   guidata(hObject,handles);
           

   
% --- Executes on button press in ShiftMask.
function ShiftMask_Callback(hObject, eventdata, handles)
% hObject    handle to ShiftMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    str = get(handles.ShiftPosition,'String'); %str is cell type.
    shift_x = str2num(char(str(1)));     %convert to char then to number
    shift_y = str2num(char(str(2)));

    MaskPoints = handles.MaskPoints;    %%it's important to note that x and y are switched when saved into MaskPoints
    n_MaskPoints = numel(MaskPoints(1,:));
    MaskPoints_x = MaskPoints(1,:);
    MaskPoints_y = MaskPoints(2,:);
    
    NewMaskPoints=MaskPoints;
    for i=1:n_MaskPoints
        NewMaskPoints(1,i)=MaskPoints_x(i)+shift_x;
        NewMaskPoints(2,i)=MaskPoints_y(i)+shift_y;
    end
    circlesize = str2num(get(handles.CircleSize,'String'));
    ln = line(round(NewMaskPoints(1,:)),round(NewMaskPoints(2,:)),'marker','o','color','g','LineStyle','none',...
        'MarkerSize',circlesize,'LineWidth',circlesize/10);
    
    handles.MaskPoints = NewMaskPoints;
    guidata(hObject,handles);


function ShiftPosition_Callback(hObject, eventdata, handles)
% hObject    handle to ShiftPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ShiftPosition as text
%        str2double(get(hObject,'String')) returns contents of ShiftPosition as a double


% --- Executes during object creation, after setting all properties.
function ShiftPosition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ShiftPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
       
        
        


function LinePixels_Callback(hObject, eventdata, handles)
% hObject    handle to LinePixels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LinePixels as text
%        str2double(get(hObject,'String')) returns contents of LinePixels as a double


% --- Executes during object creation, after setting all properties.
function LinePixels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LinePixels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in LineKymo.
function LineKymo_Callback(hObject, eventdata, handles)
% hObject    handle to LineKymo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    fclose all;
    imagesizex=handles.imagesizex;
    imagesizey=handles.imagesizey;
    NumFrames=handles.NumFrames;
 
    xy = [];
    n = 0;
    %%%% while Loop, picking up the points.
    but = 1;
    while but == 1
        [xi,yi,but] = ginput(1);    %Graphical input from a mouse or cursor
        n = n+1;
        xy(:,n) = [xi;yi];
        if but == 1
            ln = line(xy(1,:),xy(2,:),'marker','o','color','r','EraseMode','background');
        end           
    end
        
    n=n-1;
    xy=xy(:,1:n);
    
    if n>1
        xy = xy';
        Interdis=zeros(n,1);
        for i=2:n
            Interdis(i,1)=Interdis(i-1,1)+sqrt((xy(i,1)-xy(i-1,1))^2+(xy(i,2)-xy(i-1,2))^2);
        end
        NumPixel=floor(Interdis(end,1));
        nPixel = 0;
        Line = zeros(2,NumPixel);
        for i=2:n
            while nPixel+1 < Interdis(i,1)
                nPixel = nPixel +1;
                Line(1,nPixel) = xy(i-1,1) + (xy(i,1)-xy(i-1,1))*(nPixel-Interdis(i-1,1))/(Interdis(i,1)-Interdis(i-1,1));
                Line(2,nPixel) = xy(i-1,2) + (xy(i,2)-xy(i-1,2))*(nPixel-Interdis(i-1,1))/(Interdis(i,1)-Interdis(i-1,1));
            end
        end
        
        avg_points = 9;
        xp = round(Line(1,:));
        yp = round(Line(2,:));
        xp_l = xp - (avg_points-1)/2;
        w = find(xp_l < 1);
        if numel(w) ~= 0
            xp_l(w)=1;
        end
        xp_r = xp + (avg_points-1)/2;
        w = find(xp_r > imagesizex);
        if numel(w) ~= 0
            xp_r(w)=imagesizex;
        end
        yp_l = yp - (avg_points-1)/2;
        w = find(yp_l < 1);
        if numel(w) ~= 0
         yp_l(w)=1;
        end
        yp_r = yp + (avg_points-1)/2;
        w = find(yp_r > imagesizey);
        if numel(w) ~=0
            yp_r(w)=imagesizey;
        end
        kymo = zeros(NumFrames,NumPixel);
        
        
        for i=1:NumFrames
            temp=squeeze(handles.Data(:,:,i));
            for j=1:NumPixel
                kymo(i,j) = mean(mean(temp(yp_l(j):yp_r(j),xp_l(j):xp_r(j))));
            end
            display(i);
        end
        
axes(handles.axes3);       
imshow(kymo,[]);
   axes(handles.axes1);
   guidata(hObject,handles);
    end
   
    


% --- Executes on button press in LoadTracks.
function LoadTracks_Callback(hObject, eventdata, handles)
% hObject    handle to LoadTracks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    [datafile,datapath]=uigetfile('*feature*','Choose a feature file');
    track_name = datafile;
    trackdata=c_read_gdf(track_name);
    tracknumber = 1;
    circlesize = str2num(get(handles.CircleSize,'String'));
    
    
        img = get(handles.imagehandle,'CData');
        set(handles.imagehandle,'CData',img);
        drawnow;
    
        imagesizex = handles.imagesizex;
        imagesizey = handles.imagesizey;
        NumFrames = handles.greenNumFrames;
        Data = handles.greenData;
        intensity=zeros(2,NumFrames);
        
        xpos = round(trackdata(1,tracknumber));
        xmax = min(xpos+2, imagesizex);
        xmin = max(1, xpos-2);
        ypos = round(trackdata(2,tracknumber));
        ymax = min(ypos+2, imagesizey);
        ymin = max(1, ypos-2);
   
        
        ln = line(xpos,ypos,'marker','o','color','g',...
                'EraseMode','background','LineStyle','none',...
                'MarkerSize',circlesize,'LineWidth',circlesize/10);
             
    for fr=1:NumFrames
        subarray1 = Data(xmin:xmax,ymin:ymax,fr);
        intensity(1,fr)=sum(sum(subarray1));
    end
    
    axes(handles.axes2);
    plot(intensity(1,:),'*-b');
    
    set(handles.DisplayText,'String',[num2str(tracknumber) '  out of ' num2str(numel(trackdata(1,:,1)))]);
    handles.trackdata = trackdata;
    handles.tracknumber = tracknumber;
   axes(handles.axes1);
   guidata(hObject,handles);
    

% --- Executes on button press in PlotIncrease.
function PlotIncrease_Callback(hObject, eventdata, handles)
% hObject    handle to PlotIncrease (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    filename=handles.filename;
    trackdata=handles.trackdata;
    tracknumber = min(handles.tracknumber+1,numel(trackdata(1,:,1)));
    circlesize = str2num(get(handles.CircleSize,'String'));
    
    image_t = get(handles.imagehandle,'CData');
    axes(handles.axes1);
    handles.imagehandle=imshow(image_t);
    set(handles.axes1,'CLim',[get(handles.ColorSlider,'min') get(handles.ColorSlider,'value')]);   
        
        imagesizex = handles.imagesizex;
        imagesizey = handles.imagesizey;
        NumFrames = handles.greenNumFrames;
        Data = handles.greenData;
        intensity=zeros(2,NumFrames);
        
        good_fr=find(trackdata(1,tracknumber,:)>0);
        xpos = round(trackdata(1,tracknumber));
        xmax = min(xpos+2, imagesizex);
        xmin = max(1, xpos-3);
        ypos = round(trackdata(2,tracknumber));
        ymax = min(ypos+2, imagesizey);
        ymin = max(1, ypos-3);
        ln = line(xpos,ypos,'marker','o','color','g',...
                'EraseMode','background','LineStyle','none',...
                'MarkerSize',circlesize,'LineWidth',circlesize/10);
        for fr=1:NumFrames
            subarray1 = Data(xmin:xmax,ymin:ymax,fr);
            intensity(1,fr)=sum(sum(subarray1));
        end
        axes(handles.axes2);
        xax_frame=1:NumFrames;
        plot(intensity(1,:)/49,'*-b');
        
        median_value = median(intensity(1,:));
        [st_intensity, st_index]=sort(intensity,'descend');
        std_value = std(st_intensity(1,1:round(NumFrames*0.8)));
        w=find(intensity(1,:)>median_value+3*std_value);
        if numel(w)>2
            hold on;
            plot(xax_frame(1,w), intensity(1,w)/49,'og');
            hold off;
        end
    
        if handles.redNumFrames == handles.greenNumFrames
            redData = handles.redData;
            for fr=1:NumFrames
                subarray2 = redData(xmin:xmax,ymin:ymax,fr);
                intensity(2,fr)=sum(sum(subarray2));
            end
            axes(handles.axes2);
            hold on;
            plot(intensity(2,:)/49-60,'*-r');
            hold off;
        end
        
    set(handles.DisplayText,'String',[num2str(tracknumber)  '  out of ' num2str(numel(trackdata(1,:,1)))]);
    handles.trackdata = trackdata;
    handles.tracknumber = tracknumber;
    axes(handles.axes1);
    guidata(hObject,handles);


% --- Executes on button press in PlotDecrease.
function PlotDecrease_Callback(hObject, eventdata, handles)
% hObject    handle to PlotDecrease (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    trackdata=handles.trackdata;
    tracknumber = max(handles.tracknumber-1,1);
    circlesize = str2num(get(handles.CircleSize,'String'));
    
    image_t = get(handles.imagehandle,'CData');
    axes(handles.axes1);
    handles.imagehandle=imshow(image_t);
    set(handles.axes1,'CLim',[get(handles.ColorSlider,'min') get(handles.ColorSlider,'value')]);   
        
        imagesizex = handles.imagesizex;
        imagesizey = handles.imagesizey;
        NumFrames = handles.greenNumFrames;
        Data = handles.greenData;
        intensity=zeros(2,NumFrames);
        
        xpos = round(trackdata(1,tracknumber));
        xmax = min(xpos+3, imagesizex);
        xmin = max(1, xpos-2);
        ypos = round(trackdata(2,tracknumber));
        ymax = min(ypos+3, imagesizey);
        ymin = max(1, ypos-2);
        
        ln = line(xpos,ypos,'marker','o','color','g',...
                'EraseMode','background','LineStyle','none',...
                'MarkerSize',circlesize,'LineWidth',circlesize/10);    
        for fr=1:NumFrames
            subarray1 = Data(xmin:xmax,ymin:ymax,fr);
            intensity(1,fr)=sum(sum(subarray1));
        end
        axes(handles.axes2);
        plot(intensity(1,:),'*-b');
        
        if handles.redNumFrames == handles.greenNumFrames
            redData = handles.redData;
            for fr=1:NumFrames
                subarray2 = redData(xmin:xmax,ymin:ymax,fr);
                intensity(2,fr)=sum(sum(subarray2));
            end
            axes(handles.axes2);
            hold on;
            plot(intensity(2,:)-2000,'*-r');
            hold off;
        end
    
    set(handles.DisplayText,'String',[num2str(tracknumber) '  out of ' num2str(numel(trackdata(1,:,1)))]);
    handles.trackdata = trackdata;
    handles.tracknumber = tracknumber;
   axes(handles.axes1);
   guidata(hObject,handles);


   

