
function [ftime,fo1,fo2,fo3]= formantlpc(freqSam,datasound,morf,fdur,ovrt,vuvmethod,vuvt,nfrq)

%%%%%%%%%%%%%%%%%%%%I need pitch to detect formants for only Voiced frames
[f0time,f0,avgf0]=pitchcep1(freqSam,datasound,morf,fdur,ovrt,vuvmethod,vuvt);

signal=datasound-mean(datasound);
siglength=length(signal);
framedur=fdur;%Frame duration (msec) 30
shiftrate=1-ovrt; %Shift rate
sampnum=freqSam/1000; %number of samples in each msec
framelength=framedur*sampnum; %Frame length (in samples)
shiftlength=shiftrate*framelength; %Shift length (in samples)
frameNum=floor(siglength-framelength)/shiftlength; %Number of short-time frames

ncoeff=2+sampnum;           % rule of thumb for formant estimation

k=1;

figure('Name','Formants by LPC method')
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.1 0.1 0.6 0.9]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for t=1:frameNum
    
    framesig=signal(k:k+framelength-1);
    frametime=(k:k+framelength-1)*1000/freqSam;
    %framewin{t}=framesig.*hamming(framelength); %signnal of each frames (windowed)
    
    % get Linear predictive filter
    a=lpc(framesig,ncoeff);%lpc(x,p) finds the coefficients of a pth-order linear predictor, that : will be transfer function coeffs.
    [myLPC,Freq]=freqz(1,a,nfrq,freqSam);%
    %find peaks by root-solving
    r=roots(a); %find roots of polynomial a
    r=r(imag(r)>0.01); %only look for roots >0Hz up to fs/2
    ffreq=sort(atan2(imag(r),real(r))*freqSam/(2*pi)); %convert to Hz and sort
    
    %We now have desired Frequencies.
    %But we don't extract them for Unvoiced Frames, So we have to set
    %them to 0 in Unvoiced Frames.
    if f0(t)==0 %Unvoiced
        fo1(t)=0;
        fo2(t)=0;
        fo3(t)=0;
    else  
        fo1(t)=ffreq(1); %the smallest
        fo2(t)=ffreq(2);
        fo3(t)=ffreq(3);
    end
   
    ftime(t)=((t-1)*shiftlength+1)*1000/freqSam; %time of the beginning of each frame
    k=k+shiftlength; %move the frame forward
    
    subplot(511)
    plot(frametime,framesig)
    title(['Signal of frame #',num2str(t)])
    xlabel('time (msec)')
    
    subplot(512)
    plot(Freq,20*log10(abs(myLPC)+eps))
    title(['LP filter of frame #',num2str(t)]);
    xlabel('Frequency (Hz)');
    ylabel('Gain (dB)');
    
    subplot(513)
    plot(ftime,fo1)
    title('F1')
    xlabel('time (msec)')
    ylabel('F1 (Hz)')
    
    subplot(514)
    plot(ftime,fo2)
    title('F2')
    xlabel('time (msec)')
    ylabel('F2 (Hz)')
    
    subplot(515)
    plot(ftime,fo3)
    title('F3')
    xlabel('time (msec)')
    ylabel('F3 (Hz)')
    
    pause(0.05)

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
