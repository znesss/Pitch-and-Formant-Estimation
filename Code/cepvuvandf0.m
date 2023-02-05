
function [notmedf0,VUV,indCepSh,CepSh]=cepvuvandf0(framesig,framelength,Nfft,indf0max,indf0min,freqSam,isvoicedthresh)


framewin=framesig.*hamming(framelength); %signnal of each frames (windowed)
framesigF=fft(framewin,Nfft);%stft
% framesigF=fft(framesig,Nfft);%stft
framesigFlog=log((abs(framesigF)));%log(Magnitude) spectrum
Cep=real(ifft(framesigFlog));%The real cepstrum = real(inverseDFT(lof(magnitude(DFT)))) 

indCep=(1:length(Cep));%The time indexes of the cepstrum (the quefrencies)
CepSh=fftshift(Cep);%The centred cepstrum
indCepSh=indCep-floor(length(Cep)/2);%The zero-centered quefrencies %like f-fs/2
CepShP=CepSh(indCepSh>=0);%The part of the centred cepstrum located in the postive quefrencies
[Cepmax,indmax]=max(CepShP(indf0max:indf0min));%Search for the local maximum of the cepstrum located beyond indf0max

notmedf0=freqSam/(indf0max+indmax);%the potential f0 value! %Actually, indf0max is the beginning of interval.

%Voicind decision based on the comaprison of the local maximum of the cepstrum with the threshold:
if Cepmax>isvoicedthresh
 VUV=1;%voiced frame
else
 VUV=0;%unvoiced frame
end

