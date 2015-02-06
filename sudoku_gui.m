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

% Last Modified by GUIDE v2.5 06-Feb-2015 07:00:53

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
% uiwait(handles.sudoku_gui);


% --- Outputs from this function are returned to the command line.
function varargout = sudoku_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
initialize_gui(hObject, handles, false);



% --- Executes during object creation, after setting all properties.
function tbForward_CreateFcn(hObject, eventdata, handles)
% hObject handle to tbForward (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
% See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function tbBackward_CreateFcn(hObject, eventdata, handles)
% hObject handle to tbBackward (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
% See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function tbTime_CreateFcn(hObject, eventdata, handles)
% hObject handle to tbTime (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
% See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
set(hObject,'BackgroundColor','white');
end



% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
global is_play;
global is_solved;
global backtracking_timer;
global backtracking_counter;
is_solved = false;
is_play = false;
backtracking_timer = timer();
backtracking_counter = 0;
data = cell(9, 9);
set(handles.sudokutable, 'Data', data);



% --- Executes on button press in btnSolve.
function btnSolve_Callback(hObject, eventdata, handles)
% hObject    handle to btnSolve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global time_execution;
global nb_forwards;
global nb_backwards;
global is_solved;
if is_solved
    data = dlmread('solution.csv');
    last_mat_start = ((length(data) / 9) - 1) * 9 + 1;
    last_mat_end = last_mat_start + 8;
    set(handles.sudokutable, 'Data', data(last_mat_start:last_mat_end,:));
else
    input_data = get(handles.sudokutable,'Data');
    input_data = cell_to_mat(input_data);
    output_data = sudoku_solver(input_data);
    if isequal(input_data, output_data)
        warndlg('No solution!!','!! Warning !!')
    else
        set(handles.sudokutable, 'Data', output_data);
        set(handles.tbTime, 'String', time_execution);
        set(handles.tbForward, 'String', nb_forwards);
        set(handles.tbBackward, 'String', nb_backwards);
        set(handles.btnPlay, 'Enable', 'on');
        is_solved = true;
    end
end



% --- Executes on button press in btnPlay.
function btnPlay_Callback(hObject, eventdata, handles)
% hObject    handle to btnPlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global is_play;
global backtracking_timer;
if ~is_play
    data = dlmread('solution.csv');
    delay = str2double(get(handles.tbBTDelay, 'String'));
    if isnan(delay) || delay < 0.001
        set(handles.tbBTDelay,'String', '0.1');
        delay = 0.1;
    end
    backtracking_timer = timer('Period', delay, 'ExecutionMode', 'fixedRate');
    backtracking_timer.TimerFcn = {@start_timer_backtracking, data, handles};
    start(backtracking_timer);
    is_play = true;
    set(handles.btnExample, 'Enable', 'off');
    set(handles.btnSolve, 'Enable', 'off');
else
    stop_backtracking(handles);
end


function start_timer_backtracking(obj, event, data, handles)
global backtracking_counter;
backtracking_counter = backtracking_counter + 1;
start_row = (backtracking_counter - 1) * 9 + 1;
end_row = start_row + 8;
current_state = data(start_row:end_row,:);
set(handles.sudokutable, 'Data', mat_to_cell(current_state));
if backtracking_counter == length(data) / 9
    stop_backtracking(handles);
    backtracking_counter = 0;
end



function stop_backtracking(handles)
global backtracking_timer;
global is_play;
stop(backtracking_timer);
delete(backtracking_timer);
is_play = false;
set(handles.btnExample, 'Enable', 'on');
set(handles.btnSolve, 'Enable', 'on');
    
    

% --- Executes on button press in btnExample.
function btnExample_Callback(hObject, eventdata, handles)
% hObject    handle to btnExample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global is_solved;
global backtracking_counter;
is_solved = false;
data = dlmread('examples.csv');
nb_examples = length(data) / 9;
example_id = randi([1, nb_examples]);
start_row = (example_id - 1) * 9 + 1;
end_row = (example_id - 1) * 9 + 9;
example = data(start_row:end_row,:);
set(handles.sudokutable, 'Data', mat_to_cell(example));
set(handles.btnPlay, 'Enable', 'off');
if exist('solution.csv')
    delete('solution.csv')
end
backtracking_counter = 0;



% --- Executes during object creation, after setting all properties.
function tbBTDelay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbBTDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object deletion, before destroying properties.
function sudoku_gui_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to sudoku_gui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global backtracking_timer;
if isvalid(backtracking_timer) && strcmp(backtracking_timer.Running, 'on')
    stop(backtracking_timer);
    delete(backtracking_timer);
end


% --- Executes when user attempts to close sudoku_gui.
function sudoku_gui_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to sudoku_gui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);



function su_cell = mat_to_cell(su_mat)
len = length(su_mat);
su_cell = cell(len, len);
for i=1:len
    for j=1:len
        if su_mat(i, j) ~= 0
            su_cell{i, j} = su_mat(i, j);
        end
    end
end



function su_mat = cell_to_mat(su_cell)
len = length(su_cell);
su_mat = zeros(len, len);
for i=1:len
    for j=1:len
        if ~isempty(su_cell{i, j})
            su_mat(i, j) = su_cell{i, j};
        end
    end
end



