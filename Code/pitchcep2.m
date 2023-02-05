
function [f0time,f0,avgf0]=pitchcep2(freqSam,datasound,morf,fdur,ovrt,vuvt)
%in this method there is no need to compute voiced/unvoiced value of each
%frame since the computation of F0 is by threshold instead of computing ZCR
%for that part.
%We don't need Nfft in this file. Indexes are calculated in cep.m

signal=datasound-mean(datasound); %Remove DC
siglength=length(signal);
framedur=fdur;%Frame duration (msec) default:30
shiftrate=1-ovrt; %Shift rate
sampnum=freqSam/1000; %number of samples in each msec
framelength=framedur*sampnum; %Frame length (in samples)
shiftlength=shiftrate*framelength; %Shift length (in samples)
frameNum=floor((siglength-framelength)/shiftlength); %Number of short-time frames

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

k=1; %k is the index of frame start point
f0=zeros(1,frameNum);
notmedf0=zeros(1,frameNum);
f0time=zeros(1,frameNum);

m=1;
avgf0=0;

figure('Name','pitch rcep')
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.1 0.1 0.6 0.9]);

disp(['Number of frames: ',num2str(frameNum)]);
for t=1:frameNum %t is current frame number
		framesig=signal(k:k+framelength-1);
		frametime=(k:k+framelength-1)*1000/freqSam;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% with rceps%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		a=cep(framelength,freqSam,framesig,f0min,f0max,vuvt); % Use the cepstrum method
 
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

        %plot the short-time frame
        subplot(211)
        plot(frametime,framesig)
        title(['signal of frame #',num2str(t)])
        xlabel('time (msec)')
         
        %plot the short-time f0 contour
        subplot(212)
        plot(f0time,f0)
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










