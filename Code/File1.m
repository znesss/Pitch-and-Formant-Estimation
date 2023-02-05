function varargout = File1(varargin)
% File1 MATLAB code for File1.fig
%      File1, by itself, creates a new File1 or raises the existing
%      singleton*.
%
%      H = File1 returns the handle to a new File1 or the handle to
%      the existing singleton*.
%
%      File1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in File1.M with the given input arguments.
%
%      File1('Property','Value',...) creates a new File1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before File1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to File1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help File1

% Last Modified by GUIDE v2.5 25-Jun-2020 10:34:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @File1_OpeningFcn, ...
                   'gui_OutputFcn',  @File1_OutputFcn, ...
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


% --- Executes just before File1 is made visible.
function File1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to File1 (see VARARGIN)

% Choose default command line output for File1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes File1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = File1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%  Upload File  %%%%%%%%%
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[s, fs] = uigetfile(('*.wav;*.mp3'),'file selector');
if isequal(s, 0)
  disp('User aborted choosing a file');
  return;  
end
global nn;
nn=s;
fullpathname = strcat(fs, s);
%disp(s)

set(handles.edit1, 'String',num2str(fullpathname))



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get(hObject,'String') %returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%  Formant Estimation  %%%%%%
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nn;
n=nn;
[s,Fs]=audioread(n);
s=s-mean(s);
Ns=length(s); 
Time=(0:Ns-1)*1000/Fs;
Ds=Ns*1000/Fs;
FrameDur=30;
FrameLength=round(FrameDur*Fs/1000);
Nfft=2^(nextpow2(FrameLength));%Nfft taken nearest power of 2 to frame length
overlap=0.5;%Overlapping rate beween successive frame
shift=1-overlap;%Shift is the rate of sliding the window
FrameShift=round(FrameLength*shift);%shift length
FrameNb=round((Ns-FrameLength)/FrameShift);%Number of overlapping frames
Window=hamming(FrameLength);% window to be applied on each frame

Freq=(0:Nfft-1)*Fs/Nfft;%frequency values (for which the STFT will be computed) 
Freqshift=Freq-Fs/2;%Shifted frequency values


for k=1:100 %FrameNb %% had issues with the system so only ran 100 frames
    Frame=s((k-1)*FrameShift+1:(k-1)*FrameShift+FrameLength);
    FrameTime{k}=Time(((k-1)*FrameShift+1:(k-1)*FrameShift+length(Frame)));%Time axis of the frame
    FrameWin{k}=Frame.*Window;%Windowed frame
    SFrame =fft(FrameWin{k},Nfft);%Calculate the DFT at the windowed frame
    SFrameMag{k}=abs(SFrame);%Magnitude spectrum of the windowed frame
    SFrameMaglog{k}=log(SFrameMag{k});% log magnitude spectrum
    SFrameMagShift{k}=fftshift(SFrameMag{k});% shift
    ZZZ{k}=SFrameMagShift{k}(Freqshift>0); %after plotting - is saved to be smoothed
    fzzz= Freqshift(Freqshift>0); %len=nfft, from 0 to fs/2
    
    SmoothFrame=smooth(ZZZ{k});
        
    [f1(k),f2(k),f3(k)] = formant(SmoothFrame, fzzz);
    
    time(k) = ((k-1)*FrameShift+1)*1000/Fs;
    
    subplot(411)
    plot(FrameTime{k},FrameWin{k},'b')
    title(['Speech signal at frame ',num2str(k)])
    xlabel('time (msec)')
    
    
    %Plot the magnitude spectrum of the wondowed frame
    subplot(412)
    bar(Freqshift,SFrameMagShift{k},'r')
    title(['Centered DFT log magnitude at frame ',num2str(k)])
    xlabel('frequency(Hz)')
    
   
    subplot(413)
    %kk=smooth(SFrameMaglog{k});
    plot(fzzz,SmoothFrame,'c')
    title(['Smoothed DFT log magnitude at frame ',num2str(k)])
    xlabel('frequency(Hz)')
    
    subplot(414)
    plot(time, f1);
    hold on
    plot(time, f2);
    hold on
    plot(time, f3);
    legend('F1', 'F2', 'F3');
    title('Formants');
    xlabel('time');
    
    set(handles.edit6, 'String',num2str((f1)))
    set(handles.edit7, 'String',num2str((f2)))
    set(handles.edit8, 'String',num2str((f3)))

    pause(0.05)

end
    

function [f1, f2, f3] = formant(Smoothed, Frqshft)
[peaks, locs] = findpeaks(Smoothed, Frqshft);
f1loc=locs>500 & locs<1000;
f2loc=locs>1000 & locs<2000;
f3loc=locs>2000 & locs<3000;

f1mag=peaks(f1loc);
f2mag=peaks(f2loc);
f3mag=peaks(f3loc);

[max1,ind1]=max(f1mag); %local index at which greatest magnitude
[max2,ind2]=max(f2mag); %local index at which greatest magnitude
ind2=ind2+length(f1mag);%add previous indices
[max3,ind3]=max(f3mag); 
ind3=ind3+length(f1mag)+length(f2mag);

f1=locs(ind1);
f2=locs(ind2);
f3=locs(ind3);




%%%% Pitch detection using ACF   %%%%%
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nn;
n=nn;
[s,fs]=audioread(n);
s=s-mean(s);% normalization
Ns=length(s);%number of samples
time=(0:Ns-1)*1000/fs;%time 
framedur=30;%Frame duration 
shift=0.5; %Shift rate
framelength=framedur*fs/1000; %Frame length 
shiftlength=shift*framedur*fs/1000; %Shift length 
frameNb=floor(Ns-framelength)/shiftlength; %Number frames

f0min=50;%minimum value of f0 
f0max=500;%maximum value of f0 

%Plots
subplot(512)
plot(time,s)
title('speech signal')
xlabel('time (msec)')
for k=1:100%frameNb
    frame=s((k-1)*shiftlength+1:(k-1)*shiftlength+framelength);%Short-time frame
    frametime=((k-1)*shiftlength+1:(k-1)*shiftlength+framelength)*1000/fs;%frame interval 
    [ACF,lags]=xcorr(frame);%Cal of Autocorrelation function wrt lags
    ACF2=ACF(lags>=0);%ACF on the positive lags [0,framelength]
    indf0min=round(fs/f0min);%Index of f0min 
    indf0max=round(fs/f0max);%index of f0max (f0max>f0min==>indf0max<indf0min!)
    [ACF2max,indmax]=max(ACF2(indf0max:indf0min));%The index of f0 corresponds
    %to the index of the local maximum of ACF located beween the indexes of
    %f0max and f0min
    indf0=indf0max+indmax;%potential index of f0
    f0(k)=fs/indf0;%potential value of f0
    % check for voiced and unvoiced
    if ACF2max>max(ACF)/2 
        VUV(k)=1;%Then the frame is voiced    
    else
        VUV(k)=0; %otherwise the frame is unvoiced ()
    end
    f0(k)=f0(k)*VUV(k);
    f0time(k)=((k-1)*shiftlength+1)*1000/fs;
    
    pks(k,1) = f0(k);
   
    
%Plot signal
subplot(513)
plot(frametime,frame)
title(['signal of frame ',num2str(k)])
xlabel('time(msec)')

%Plot ACF 
subplot(514)
plot(lags,ACF)
title(['Autocorrelation function of frame ',num2str(k)])
xlabel('lags')

%Plot f0 contour 
subplot(515)
plot(f0time,f0)
title('F0 contour by autocorrelation function')
xlabel('time (msec)')
ylabel('F0 (Hz)')

F0acf = max(pks);
% disp([F0acf,'is the pitch'])
set(handles.edit2, 'String',num2str(F0acf))

pause(0.1)


end

%%%%%%  Pitch Detection using Cepstrum  %%%%%
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nn;
n=nn;
[s,fs]=audioread(n);
s=s-mean(s);
Ns=length(s);
time=(0:Ns-1)*1000/fs;
framedur=30;
shift=0.5; 
framelength=framedur*fs/1000; 
shiftlength=shift*framedur*fs/1000; 
frameNb=floor(Ns-framelength)/shiftlength;
Nfft=2^nextpow2(framelength);
f=(0:Nfft-1)*fs/Nfft;
fshift=f-fs/2;
f0min=50;
f0max=500;
indf0min=round(fs/f0min);
indf0max=round(fs/f0max);
threshold=0.1;%Threshold that will used to decide about voicing activity


%Plot the signal
subplot(512)
plot(time,s)
title('speech signal')
xlabel('time (msec)')


for k=1:100%frameNb
    frame=s((k-1)*shiftlength+1:(k-1)*shiftlength+framelength);
    frametime=((k-1)*shiftlength+1:(k-1)*shiftlength+framelength)*1000/fs;%time interval of the frame    
    S=fft(frame,Nfft);%DFT of the frame
    Smaglog=log((abs(S)));%log(Magnitude) spectrum
    Cep=real(ifft(Smaglog));%inverseDFT(log(magnitude(DFT)))
    indCep=(1:length(Cep));%The time indexes of the cepstrum (the quefrencies)
    Cepshift=fftshift(Cep);%The centred cepstrum
    indCepshift=indCep-floor(length(Cep)/2);%The zero-centered quefrencies 
    Cep2=Cepshift(indCepshift>=0);%The part of the centred cepstrum located in the postive quefrencies
    [Cep2max,indmax]=max(Cep2(indf0max:end));%local maximum of cepstrum beyond indf0max
    f0(k)=fs/(indf0max+indmax);%potential f0 value
    
    %check for voiced or unvoiced based on local maximum of
    %cepstrum with the threshold
    if Cep2max>threshold
        VUV_Cep(k)=1;%voiced frame
    else
        VUV_Cep(k)=0;%unvoiced frame
    end
    f0(k)=f0(k)*VUV_Cep(k);%The final value of f0
    f0time(k)=((k-1)*shiftlength+1)*1000/fs;%Instant of f0
    
    pks(k,1) = f0(k);

    subplot(311)
    %plot signal
    plot(frametime,frame)
    title(['signal of frame ',num2str(k)])
    xlabel('time (msec)')
    
    %plot cepstrum
    subplot(312)
    plot(indCepshift,Cepshift)
    title(['Centered cepstrum of frame ',num2str(k)])
    xlabel('Quefrency (Hz^-^1)')
    
    %plot the f0 contour
    subplot(313)
    plot(f0time,f0)
    title('F0 contour by Cepstrum')
    xlabel('time (msec)')
    ylabel('F0 (Hz)')
    
    F0 = max(pks);
    disp(F0)
    set(handles.edit3, 'String',num2str(F0))
    
    pause(0.1)
    
end


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



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





