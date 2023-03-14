function nirs = convertToHemo(nirs)
%Transforms the signal in nirs.d to hemoglobin concentration
%Most of the code is copied from the DOT_HUB toolbox
dod = double(hmrIntensity2OD(nirs.d)); %Converts raw data to optical density.
dod = hmrBandpassFilt(dod,nirs.t',0,0.5); %Bandpass filter
if isfield(nirs,'SD3D')
    dc = hmrOD2Conc(dod,nirs.SD3D,[6 6]); %convert optical density to
else
    dc = hmrOD2Conc(dod,nirs.SD,[6 6]); %convert optical density to
end
%This next part rearranges the matrix dc to the original organization of
%nirs.d
d = zeros(size(nirs.d));
for n = 1:size(d,1)
    for sd = 1:size(dc,3)
        d(n,sd) = dc(n,1,sd);
        d(n,sd+size(dc,3)) = dc(n,2,sd);
    end
end
nirs.d = d;%overwrites nirs.d