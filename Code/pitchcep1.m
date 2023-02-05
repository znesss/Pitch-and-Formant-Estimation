
function [f0time,f0,avgf0]=pitchcep1(freqSam,datasound,morf,fdur,ovrt,vuvmethod,vuvt)
%in this function we compute short time Cepstrum,
%Then if the user decides to determine Voiced/Unvoiced frames by ZCR, it is done,
%other wise, the Cepstrum itself is used to threshold the maximum and
%report the Voiced/Unvoiced activity.

signal=datasound-mean(datasound); %Remove DC
siglength=length(signal);
framedur=fdur; %Frame duration (msec) defaut:30
shiftrate=1-ovrt; %Shift rate
sampnum=freqSam/1000; %number of samples in each msec
framelength=framedur*sampnum; %Frame length (in samples)
shiftlength=shiftrate*framelength; %Shift length (in samples)
frameNum=floor((siglength-framelength)/shiftlength); %Number of short-time frames
ZCRthresh=40;%Threshold that will be used for voicing activity 
%detection (VUV:voiced/unvoiced)
%This threshold is suggested as a value between ZCR=14 for voiced phonemes
%(vowels and some consonants like /b/, /d/, /g/) and
%ZCR=49 for unvoiced phonemes (most of consonnants)

Nfft=2^nextpow2(framelength);%Number of point of FFT :Next higher power of 2. ex480-->512

switch morf
case 1 %both ranges
     f0min=70;
     f0max=500;
case 2 
     f0min=80;
     f0max=200;
case 3 
     f0min=150;
     f0max=350;
end
%f0min=60; %Minimum f0 value for men85 for women165
%f0max=300; %Maximum f0 value for men180 for women 255

indf0min=round(freqSam/(f0min));%Index of f0min
indf0max=round(freqSam/(f0max));%Index of f0 max
isvoicedthresh=vuvt;%Threshold that is used to decide about voicing activity 0.1 is a nice choice

k=1;
f0=zeros(1,frameNum);
notmedf0=zeros(1,frameNum);
f0time=zeros(1,frameNum);

m=1;
avgf0=0;

figure('Name','pitch Ourcep')
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.1 0.1 0.6 0.9]);

disp(['Number of frames: ',num2str(frameNum)]);
for t=1:frameNum
      framesig=signal(k:k+framelength-1);
      frametime=(k:k+framelength-1)*1000/freqSam;
            
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% without rceps%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      [potf0 ,isvuv ,indCepSh ,CepSh] = cepvuvandf0(framesig,framelength,Nfft,indf0max,indf0min,freqSam,isvoicedthresh);
      if vuvmethod == 2 %ZCR     
         [isvuv] = VUVZCR(ZCRthresh,framesig,framelength);
      end
                  
      VUV(t)=isvuv;
      notmedf0(t)=potf0;
      a=notmedf0(t)*VUV(t);%The final value of f0
             
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % Calculate the median of 3 adjacent frames
      %and also summing f0 s up, to take the avg

      notmedf0(t)=a;
      if t>2 && frameNum>3 %--do some median filtering
		  z=notmedf0(t-2:t); 
		  md=median(z);
		  f0(t-2)=md;
		  if md > 0
		     avgf0=avgf0+md;
		     m=m+1;
          end
	   elseif frameNum<=3
		  f0(t)=a;
		  avgf0=avgf0+a;
		  m=m+1;
       end

	   f0time(t)=((t-1)*shiftlength+1)*(1000/freqSam);%Instant of f0 at the beginning of each frame
       k=k+shiftlength; %move the frame forward

       subplot(311)
       plot(frametime,framesig)
       title(['Signal of frame #',num2str(t)])
       xlabel('time (msec)')
       
       subplot(312)
       plot(indCepSh,CepSh)
       title(['Centered cepstrum of frame #',num2str(t)])
       xlabel('Quefrency (Hz^-^1)')
       
       subplot(313)
       plot(f0time,f0) %not only the current value, the whole!
       title('F0')
       xlabel('time (msec)')
       ylabel('F0 (Hz)')
    
       pause(0.05)
    
end
 
if m==1
    avgf0=0;
else
    avgf0=avgf0/(m-1);
end










