function [f0] = cep(framelen,fs,framesig,f0min,f0max,vuvt)

% disp(['framelen',num2str(framelen),'framesig',num2str(length(framesig))]);

isvoicedthresh=vuvt;%Threshold that is used to decide about voicing activity 0.1 is a nice choice

framesig=hamming(framelen).*framesig;
framecep=rceps(framesig);

indf0min=floor(fs/f0max); %%Index of f0min 500
indf0max=floor(fs/f0min); %%Index of f0max 70

cepinterval=framecep(indf0min:indf0max);
[Cepmax, indmax]=max(cepinterval);


if Cepmax > isvoicedthresh %& indmax >indf0min
  f0= fs/(indf0min+indmax);
else
  f0=0;
end


