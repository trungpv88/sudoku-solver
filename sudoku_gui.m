function varargout = sudoku_gui(varargin)
% SUDOKU_GUI MATLAB code for sudoku_gui.fig
%      SUDOKU_GUI, by itself, creates a new SUDOKU_GUI or raises the existing
%      singleton*.
%
%      H = SUDOKU_GUI returns the handle to a new SUDOKU_GUI or the handle to
%      the existing singleton*.
%
%      SUDOKU_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SUDOKU_GUI.M with the given input arguments.
%
%      SUDOKU_GUI('Property','Value',...) creates a new SUDOKU_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sudoku_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sudoku_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sudoku_gui

% Last Modified by GUIDE v2.5 05-Feb-2015 09:14:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sudoku_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @sudoku_gui_OutputFcn, ...
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


% --- Executes just before sudoku_gui is made visible.
function sudoku_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sudoku_gui (see VARARGIN)

% Choose default command line output for sudoku_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sudoku_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sudoku_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
initialize_gui(hObject, handles, false);

% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
data = [0 1 0 2 0 0 0 0 0;
        3 0 0 8 0 0 0 4 0;
        8 0 0 6 0 0 0 5 0;
        0 0 6 0 3 0 2 0 0;
        0 0 1 0 9 0 6 0 0;
        0 0 7 0 4 0 8 0 0;
        0 4 0 0 0 5 0 0 9;
        0 5 0 0 0 1 0 0 6;
        0 0 0 0 0 7 0 3 0;];
set(handles.sudokutable, 'Data', data);

% --- Executes on button press in solveBtn.
function solveBtn_Callback(hObject, eventdata, handles)
% hObject    handle to solveBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global time_execution;
global nb_forwards;
global nb_backwards;
input_data = get(handles.sudokutable,'Data');
output_data = sudoku_solver(input_data);
if isequal(input_data, output_data)
    warndlg('No solution!!','!! Warning !!')
else
    set(handles.sudokutable, 'Data', output_data);
    set(handles.tbTime, 'String', time_execution);
    set(handles.tbForward, 'String', nb_forwards);
    set(handles.tbBackward, 'String', nb_backwards);
end

% --- Executes when entered data in editable cell(s) in sudokutable.
function sudokutable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to sudokutable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)



function tbTime_Callback(hObject, eventdata, handles)
% hObject    handle to tbTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbTime as text
%        str2double(get(hObject,'String')) returns contents of tbTime as a double


% --- Executes during object creation, after setting all properties.
function tbTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbForward_Callback(hObject, eventdata, handles)
% hObject    handle to tbForward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbForward as text
%        str2double(get(hObject,'String')) returns contents of tbForward as a double


% --- Executes during object creation, after setting all properties.
function tbForward_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbForward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbBackward_Callback(hObject, eventdata, handles)
% hObject    handle to tbBackward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbBackward as text
%        str2double(get(hObject,'String')) returns contents of tbBackward as a double


% --- Executes during object creation, after setting all properties.
function tbBackward_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbBackward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnStep.
function btnStep_Callback(hObject, eventdata, handles)
% hObject    handle to btnStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btnPlay.
function btnPlay_Callback(hObject, eventdata, handles)
% hObject    handle to btnPlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = dlmread('solution.dat');
for i = 1:(length(data) / 9)
    start_row = (i - 1) * 9 + 1;
    end_row = (i - 1) * 9 + 9;
    current_state = data(start_row:end_row,:);
    set(handles.sudokutable, 'Data', current_state);
    pause(0.5);
end
