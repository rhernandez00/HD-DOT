function resampleNIRS(nirsFileName,newFs,nirsFileNameOut)
% Loads nirsFileName, resamples it according to newFS. If no output filename is provided, 
% it overwrites the original file
% Note. The function currently erases the field s (events) and ErrorFlags
% as they are not used later in this repository. Should correct eventually.
% Author: Raul Hernandez
if nargin < 3
    nirsFileNameOut = nirsFileName;
end

nirsIn = load(nirsFileName,'-mat'); %loads the nirs file
fieldList = fieldnames(nirsIn); %gets a list of the fields in the file

%Removes the fields that will not be copied
leavedOutFields = {'ErrorFlags','d','s','t'};
fieldList(ismember(fieldList,leavedOutFields)) = [];

% makes a copy of all other fields
for nField = 1:numel(fieldList)
    fieldName = fieldList{nField};
    nirs.(fieldName) = nirsIn.(fieldName);
end

originalFs = 1/mean(nirsIn.t(2:end) -nirsIn.t(1:end-1)); %calculates the frequency using the timming data
totalChannels = size(nirsIn.d,2); %number of channels 

%calculates the number of samples in the new file
d = resample(double(nirsIn.d(:,1)),nirsIn.t,newFs);
nSamples = numel(d);

nirs.d = zeros(nSamples,totalChannels); %initializes d which will contain the resampled data

for nChan = 1:size(nirs.d,2) %resamples every channel and saves it into the new nirs structure
    [nirs.d(:,nChan),tOut]=resample(double(nirsIn.d(:,nChan)),nirsIn.t,newFs);
end

% nirs.d = single(nirs.d); %transforms back to single
nirs.t = tOut; %saves the new time vector

save(nirsFileNameOut,'-struct','nirs','-v7.3'); %saves output file
disp(['File ', nirsFileName, ' resampled from ', num2str(originalFs), ' Hz to ', num2str(newFs), ' Hz and saved as ',nirsFileNameOut]);