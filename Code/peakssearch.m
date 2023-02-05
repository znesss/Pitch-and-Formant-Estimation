
function [f1,f2,f3]=peakssearch(f0,smoothedframesig,fshiftP)
%findMaxArrayIdx
% if V=1 : max is pitch, max2 is f1, max3 is f2, max4 is f3;

[pks,locs]=findpeaks(smoothedframesig,fshiftP);

f1look=locs>f0 & locs<1000;
f2look=locs>1000 & locs<2000;
f3look=locs>2000 & locs<3000;

f1mag=pks(f1look);
f2mag=pks(f2look);
f3mag=pks(f3look);

[max1,ind1]=max(f1mag); %local index of greatest magnitude. for F1 its fine
[max2,ind2]=max(f2mag); %local index of greatest magnitude. I have to add indexes that has happened before:
ind2=ind2+length(f1mag);
[max3,ind3]=max(f3mag); %local index of greatest magnitude. I have to add indexes that has happened before:
ind3=ind3+length(f1mag)+length(f2mag);

f1=locs(ind1);
f2=locs(ind2);
f3=locs(ind3);