function VUV = VUVZCR(ZCRthresh,framesig,framelength)
ZCR=sum(abs(diff(sign(framesig)))/(2*framelength)); %Short-time ZCR %%A NUMBER%%
%if short-time ZCR is lower than the threshold ==>Voiced frame, otherwise it's unvoiced
VUV=ZCR<(ZCRthresh/framelength); %%A NUMBER: 0 or 1%%