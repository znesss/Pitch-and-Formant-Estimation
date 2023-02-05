
%https://www.mathworks.com/matlabcentral/fileexchange/53443-simple-audio-player-gui

function varargout = main(varargin)
% main MATLAB code for main.fig
%      main, by itself, creates a new main or raises the existing
%      singleton*.
%
%      H = main returns the handle to a new main or the handle to
%      the existing singleton*.
%
%      main('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in main.M with the given input arguments.
%
%      main('Property','Value',...) creates a new main or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 22-Jun-2020 20:15:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.

handles.output = hObject;

guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%File Control

% --- Executes on button press in record.
function record_Callback(hObject, eventdata, handles)

myGui=guidata(handles.figure1);
rec = audiorecorder(16000,16,1,-1);
disp('Recording for 5 Seconds...');
recordblocking (rec,5); %5 Seconds
disp('Finished Recording.')
myrecording = getaudiodata(rec);
plot(handles.axes1,myrecording);
audiowrite('RecordedSound.wav',myrecording, 16000);
%Some process like load
[x,fs] = audioread('RecordedSound.wav');
myGui.freqSam=fs;
myGui.datasound=x;
myGui.player=audioplayer(myGui.datasound,myGui.freqSam); %datasound is the signal
myGui.flag=2;
set(handles.text3,'String', 'Succefully Saved');
%set(handles.text11,'String',fs); %ok
x=x-mean(x);
Ns=length(x);
time=(0:Ns-1)*1000/fs;%time in msec
disp(['sampling frequency is ',num2str(fs)]);
plot(handles.axes1,time/1000,x);
title(handles.axes1,'Speech Signal');
xlabel('time (msec)');
%to be sure we have recorded a file then we can click on pitchcep1
set(handles.pitchcep1,'Enable','on');
%to be sure we have recorded a file then we can click on pitchcep2
set(handles.pitchcep2,'Enable','on');
%to be sure we have recorded a file then we can click on formants
set(handles.formantlpc,'Enable','on');
%to be sure we have recorded a file then we can click on formants
set(handles.formantdlm,'Enable','on');


guidata(handles.figure1,myGui);


% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles) %Load from file,show what,plot signal,ready to play

myGui=guidata(handles.figure1);
[file,path] = uigetfile('*.wav','Select a wave file');
[x,fs] = audioread([path file]);
myGui.freqSam=fs;
myGui.datasound=x;
myGui.player=audioplayer(myGui.datasound,myGui.freqSam); %datasound is the signal
myGui.flag=2;
set(handles.text3,'String',[path file]);
%set(handles.text11,'String',fs); %ok
x=x-mean(x);
Ns=length(x);
time=(0:Ns-1)*1000/fs;%time in msec
disp(['sampling frequency is ',num2str(fs)]);
plot(handles.axes1,time/1000,x);
title(handles.axes1,'Speech Signal');
xlabel('time (msec)');
%to be sure we have recorded a file then we can click on pitchcep1
set(handles.pitchcep1,'Enable','on');
%to be sure we have recorded a file then we can click on pitchcep2
set(handles.pitchcep2,'Enable','on');
%to be sure we have recorded a file then we can click on formantlpc
set(handles.formantlpc,'Enable','on');
%to be sure we have recorded a file then we can click on formants
set(handles.formantdlm,'Enable','on');

guidata(handles.figure1,myGui)


% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles) %play, pause, resume

%myplot=guidata(handles.axes1)
myGui=guidata(handles.figure1);
if(myGui.flag==2)
    myGui.flag=1;
    %set(handles.text7,'String',myGui.flag); %ok
    disp('2:play mode');
    play(myGui.player);
    %run('');
else
    if(myGui.flag == 1)
        disp('1:pause mode');
        myGui.flag=0;
        pause(myGui.player);
    else
        disp('0:resume mode');
        myGui.flag=1;
        resume(myGui.player)
    end
end

guidata(handles.figure1,myGui);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%pitchcep1 & Formant Extraction


% --- Executes on button press in pitchcep1.
function pitchcep1_Callback(hObject, eventdata, handles) % pass signal to pitch file to compute pitch

myGui=guidata(handles.figure1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Get and Check the inputs:

myGui.morf = get(handles.gender, 'value');
disp(myGui.morf);

selfdur = get(handles.frdur,'value');
allfdur =  get(handles.frdur,'String');
myGui.fdur = str2double(allfdur(selfdur));
disp(myGui.fdur);

selovrt = get(handles.ovrate, 'value');
allovrt = get(handles.ovrate, 'String');
myGui.ovrt = str2double(allovrt(selovrt));
disp(myGui.ovrt);

myGui.meth = get(handles.vuvmethod, 'value');
disp(myGui.meth);

selvuvt = get(handles.vuvthreshold, 'value');
allvuvt = get(handles.vuvthreshold, 'String');
myGui.vuvt = str2double(allvuvt(selvuvt));
disp(myGui.vuvt);

[f0time,f0,f0avg]=pitchcep1(myGui.freqSam,myGui.datasound,myGui.morf,myGui.fdur,myGui.ovrt,myGui.meth,myGui.vuvt);  %based on what we did in the labs+median
%[f0timeacf,f0acf]=pitchacf(myGui.freqSam,myGui.datasound,myGui.morf,myGui.fdur,myGui.ovrt,myGui.vuvt);

%f0num=size(nonzeros(f0)); %noneed
%f0avg=sum(f0)/f0num(1);  %noneed
set(handles.text25,'String',['Average value of F0 by cep is: ' , num2str(f0avg)]);

plot(handles.axes4,f0time,f0)
title(handles.axes4,'F0 values of Signal based on cep + median')
xlabel('time (msec)')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

guidata(handles.figure1,myGui);



% --- Executes on button press in pitchcep2.
function pitchcep2_Callback(hObject, eventdata, handles)

myGui=guidata(handles.figure1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Get and Check the inputs:

myGui.morf = get(handles.gender, 'value');
disp(myGui.morf);

selfdur = get(handles.frdur,'value');
allfdur =  get(handles.frdur,'String');
myGui.fdur = str2double(allfdur(selfdur));
disp(myGui.fdur);

selovrt = get(handles.ovrate, 'value');
allovrt = get(handles.ovrate, 'String');
myGui.ovrt = str2double(allovrt(selovrt));
disp(myGui.ovrt);

myGui.meth = get(handles.vuvmethod, 'value');
disp(myGui.meth);

selvuvt = get(handles.vuvthreshold, 'value');
allvuvt = get(handles.vuvthreshold, 'String');
myGui.vuvt = str2double(allvuvt(selvuvt));
disp(myGui.vuvt);

[f0time,f0,f0avg]=pitchcep2(myGui.freqSam,myGui.datasound,myGui.morf,myGui.fdur,myGui.ovrt,myGui.vuvt); %based on rcep+median
%[f0timeacf,f0acf]=pitchacf(myGui.freqSam,myGui.datasound,myGui.morf,myGui.fdur,myGui.ovrt,myGui.vuvt);

%f0num=size(nonzeros(f0)); %noneed
%f0avg=sum(f0)/f0num(1);  %noneed
set(handles.text29,'String',['Average value of F0 by rcep is: ' , num2str(f0avg)]);

hold( handles.axes4, 'on' )
plot(handles.axes4,f0time,f0)
title(handles.axes4,'F0 values of Signal based on rcep + median')
xlabel('time (msec)')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

guidata(handles.figure1,myGui);



% --- Executes on button press in formantlpc.
function formantlpc_Callback(hObject, eventdata, handles)
% hObject    handle to formantlpc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myGui=guidata(handles.figure1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Get and Check the inputs:

myGui.morf = get(handles.gender, 'value');
disp(myGui.morf);

selfdur = get(handles.frdur,'value');
allfdur =  get(handles.frdur,'String');
myGui.fdur = str2double(allfdur(selfdur));
disp(myGui.fdur);

selovrt = get(handles.ovrate, 'value');
allovrt = get(handles.ovrate, 'String');
myGui.ovrt = str2double(allovrt(selovrt));
disp(myGui.ovrt);

myGui.meth = get(handles.vuvmethod, 'value');
disp(myGui.meth);

selvuvt = get(handles.vuvthreshold, 'value');
allvuvt = get(handles.vuvthreshold, 'String');
myGui.vuvt = str2double(allvuvt(selvuvt));
disp(myGui.vuvt);

selnfrq = get(handles.nfreq, 'value');
allnfrq = get(handles.nfreq, 'String');
myGui.nfrq = str2double(allnfrq(selnfrq));
disp(myGui.nfrq);

[ftime,fo1,fo2,fo3]= formantlpc(myGui.freqSam,myGui.datasound,myGui.morf,myGui.fdur,myGui.ovrt,myGui.meth,myGui.vuvt,myGui.nfrq);

f1num=size(nonzeros(fo1));
fo1avg=sum(fo1)/f1num(1);
set(handles.text26, 'String', ['Average value of f1 is ' , num2str(fo1avg)]);

f2num=size(nonzeros(fo2));
fo2avg=sum(fo2)/f2num(1);
set(handles.text27, 'String', ['Average value of f2 is ' , num2str(fo2avg)]);

f3num=size(nonzeros(fo3));
fo3avg=sum(fo3)/f3num(1);
set(handles.text28, 'String', ['Average value of f3 is ' , num2str(fo3avg)]);

plot(handles.axes5,ftime,fo1);
title(handles.axes5,'F1 values of Signal');
xlabel('time (msec)');
plot(handles.axes6,ftime,fo2);
title(handles.axes6,'F2 values of Signal');
xlabel('time (msec)');
plot(handles.axes7,ftime,fo3);
title(handles.axes7,'F3 values of Signal');
xlabel('time (msec)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

guidata(handles.figure1,myGui);



% --- Executes on button press in formantdlm.
function formantdlm_Callback(hObject, eventdata, handles)
% hObject    handle to formantlpc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myGui=guidata(handles.figure1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Get and Check the inputs:
myGui.morf = get(handles.gender, 'value');
disp(myGui.morf);

selfdur = get(handles.frdur,'value');
allfdur =  get(handles.frdur,'String');
myGui.fdur = str2double(allfdur(selfdur));
disp(myGui.fdur);

selovrt = get(handles.ovrate, 'value');
allovrt = get(handles.ovrate, 'String');
myGui.ovrt = str2double(allovrt(selovrt));
disp(myGui.ovrt);

selvuvt = get(handles.vuvthreshold, 'value');
allvuvt = get(handles.vuvthreshold, 'String');
myGui.vuvt = str2double(allvuvt(selvuvt));
disp(myGui.vuvt);

myGui.meth = get(handles.vuvmethod, 'value');
disp(myGui.meth);

[ftime,fo1,fo2,fo3]=formantdlm(myGui.freqSam,myGui.datasound,myGui.morf,myGui.fdur,myGui.ovrt,myGui.meth,myGui.vuvt);

f1num=size(nonzeros(fo1));
fo1avg=sum(fo1)/f1num(1);
set(handles.text31, 'String', ['Average value of f1 is ' , num2str(fo1avg)]);

f2num=size(nonzeros(fo2));
fo2avg=sum(fo2)/f2num(1);
set(handles.text32, 'String', ['Average value of f2 is ' , num2str(fo2avg)]);

f3num=size(nonzeros(fo3));
fo3avg=sum(fo3)/f3num(1);
set(handles.text33, 'String', ['Average value of f3 is ' , num2str(fo3avg)]);

hold( handles.axes5, 'on' )
plot(handles.axes5,ftime,fo1);
title(handles.axes5,'F1 values of Signal');
xlabel('time (msec)');

hold( handles.axes6, 'on' )
plot(handles.axes6,ftime,fo2);
title(handles.axes6,'F2 values of Signal');
xlabel('time (msec)');

hold( handles.axes7, 'on' )
plot(handles.axes7,ftime,fo3);
title(handles.axes7,'F3 values of Signal');
xlabel('time (msec)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

guidata(handles.figure1,myGui);

% --- Executes on selection change in gender.
function gender_Callback(hObject, eventdata, handles)
% myGui=guidata(handles.figure1);
% hObject    handle to gender (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% myGui.gender = get(handles.gender, 'value');
% clear('handles.gender.value');
% Hints: contents = cellstr(get(hObject,'String')) returns gender contents as cell array
%        contents{get(hObject,'Value')} returns selected item from gender


% --- Executes during object creation, after setting all properties.
function gender_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gender (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in frdur.
function frdur_Callback(hObject, eventdata, handles)
% hObject    handle to frdur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns frdur contents as cell array
%        contents{get(hObject,'Value')} returns selected item from frdur


% --- Executes during object creation, after setting all properties.
function frdur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frdur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ovrate.
function ovrate_Callback(hObject, eventdata, handles)
% hObject    handle to ovrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns ovrate contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ovrate


% --- Executes during object creation, after setting all properties.
function ovrate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ovrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in vuvthreshold.
function vuvthreshold_Callback(hObject, eventdata, handles)
% hObject    handle to vuvthreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns vuvthreshold contents as cell array
%        contents{get(hObject,'Value')} returns selected item from vuvthreshold


% --- Executes during object creation, after setting all properties.
function vuvthreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vuvthreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in nfreq.
function nfreq_Callback(hObject, eventdata, handles)
% hObject    handle to nfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns nfreq contents as cell array
%        contents{get(hObject,'Value')} returns selected item from nfreq


% --- Executes during object creation, after setting all properties.
function nfreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in vuvmethod.
function vuvmethod_Callback(hObject, eventdata, handles)
% hObject    handle to vuvmethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns vuvmethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from vuvmethod


% --- Executes during object creation, after setting all properties.
function vuvmethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vuvmethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in clear1.
function clear1_Callback(hObject, eventdata, handles)
% hObject    handle to clear1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myGui=guidata(handles.figure1);
cla(handles.axes4,'reset');


% --- Executes on button press in clear2.
function clear2_Callback(hObject, eventdata, handles)
% hObject    handle to clear2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myGui=guidata(handles.figure1);
cla(handles.axes5,'reset');

% --- Executes on button press in clear3.
function clear3_Callback(hObject, eventdata, handles)
% hObject    handle to clear3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myGui=guidata(handles.figure1);
cla(handles.axes6,'reset');

% --- Executes on button press in clear4.
function clear4_Callback(hObject, eventdata, handles)
% hObject    handle to clear4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myGui=guidata(handles.figure1);
cla(handles.axes7,'reset');
