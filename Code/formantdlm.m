
function [ftime,fo1,fo2,fo3]=formantdlm(freqSam,datasound,morf,fdur,ovrt,vuvmethod,vuvt)
%In this method, we need to stop before applying DFTinv, smooth the frames
%which are in frequency, then use the maximums.
%Note: the first maximum in Voiced Frames is the Pitch!--------->Carefull

%%%%%%%%%%%%%%%%%%%%I need pitch to detect formants for only Voiced frames
[f0time,f0,avgf0]=pitchcep1(freqSam,datasound,morf,fdur,ovrt,vuvmethod,vuvt);

signal=datasound-mean(datasound);
siglength=length(signal);
framedur=fdur;%Frame duration (msec) 30
shiftrate=1-ovrt; %Shift rate
sampnum=freqSam/1000; %number of samples in each msec
framelength=framedur*sampnum; %Frame length (in samples)
shiftlength=shiftrate*framelength; %Shift length (in samples)
frameNum=floor((siglength-framelength)/shiftlength); %Number of short-time frames

Nfft=2^nextpow2(framelength);%Number of point of FFT (the nearest power of 2 to framelength %Next higher power of 2. ex480-->512
f=(0:Nfft-1)*freqSam/Nfft;%(Nfft)Frequency values to perform stft
fshift=f-freqSam/2;%Centering the frequecies on 0

k=1;

figure('Name','Formants by log-FFT method')
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.1 0.1 0.6 0.9]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for t=1:frameNum
    
    framesig=signal(k:k+framelength-1);
    frametime=(k:k+framelength-1)*1000/freqSam;
    framewin{t}=framesig.*hamming(framelength); %signnal of each frames (windowed)
    
    framesigF=fft(framewin{t},Nfft);%stft
    framesigFlog=log((abs(framesigF)));%log(Magnitude) spectrum

    %Shifting and removing Negative part, equals to a lowpass filter:
    framesigFlogSh=fftshift(framesigFlog); %stft of signal in frame
    
    framesigFlogShP=framesigFlogSh(fshift>0); %after plotting - is saved to be smoothed
    fshiftP= fshift(fshift>0); %len=nfft, from 0 to fs/2
    smoothedframesig=smooth(framesigFlogShP);
    smoothedframesig=smoothedframesig*2;
    %F is ready to be used.

    %call for peaks search
    disp(t)
    [fo1(t),fo2(t),fo3(t)]=peakssearch(f0(t),smoothedframesig,fshiftP);
    %We now have Indices in which desired Frequencies exist.
    %But we don't extract them for Unvoiced Frames, So we have to Multiply
    %them by 0 to obtain zero in Unvoiced Frames:
    if f0(t)==0 %Unvoiced
        fo1(t)=0;
        fo2(t)=0;
        fo3(t)=0;
    end
 
    ftime(t)=((t-1)*shiftlength+1)*1000/freqSam; %time of the beginning of each frame
    k=k+shiftlength; %move the frame forward

    subplot(411)
    plot(frametime,framesig)
    title(['Signal of frame #',num2str(t)])
    xlabel('time (msec)')

    subplot(412)
    plot(fshift,framesigFlogSh);
    title(['Centered Dft log mag of frame #',num2str(t)]);
    xlabel('Frequency (Hz)');
    
    subplot(413)
    plot(fshiftP,smoothedframesig);
    title(['Positive part of Smoothed Dft log mag of frame #',num2str(t)]);
    xlabel('Frequency (Hz)');

    subplot(414)
    plot(ftime,fo3);
    hold on
    plot(ftime,fo2);
    hold on
    plot(ftime,fo1);
    legend('F3','F2','F1')
    title('Formants');
    xlabel('time');
    ylabel('Hz');
 
    pause(0.05)

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
