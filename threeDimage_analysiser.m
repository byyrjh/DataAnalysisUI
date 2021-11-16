function varargout = threeDimage_analysiser(varargin)
% THREEDIMAGE_ANALYSISER MATLAB code for threeDimage_analysiser.fig
%      THREEDIMAGE_ANALYSISER, by itself, creates a new THREEDIMAGE_ANALYSISER or raises the existing
%      singleton*.
%
%      H = THREEDIMAGE_ANALYSISER returns the handle to a new THREEDIMAGE_ANALYSISER or the handle to
%      the existing singleton*.
%
%      THREEDIMAGE_ANALYSISER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in THREEDIMAGE_ANALYSISER.M with the given input arguments.
%
%      THREEDIMAGE_ANALYSISER('Property','Value',...) creates a new THREEDIMAGE_ANALYSISER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before threeDimage_analysiser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to threeDimage_analysiser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help threeDimage_analysiser

% Last Modified by GUIDE v2.5 28-Mar-2019 23:06:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @threeDimage_analysiser_OpeningFcn, ...
                   'gui_OutputFcn',  @threeDimage_analysiser_OutputFcn, ...
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


% --- Executes just before threeDimage_analysiser is made visible.
function threeDimage_analysiser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to threeDimage_analysiser (see VARARGIN)

% Choose default command line output for threeDimage_analysiser
handles.peaks=peaks(35);
handles.image_disp=handles.peaks;
surf(handles.image_disp);
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes threeDimage_analysiser wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = threeDimage_analysiser_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ima_read.
function ima_read_Callback(hObject, eventdata, handles)
% hObject    handle to ima_read (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
