function nirs2 = cutNIRS(nirsFileName,endTime)
% cuts the nirs file using the events s (for start) and e (for end). If
% endTime is introduced, it cuts the file endTime s after the s
nirs = load(nirsFileName,'-mat');

sIndx = find(strcmp(nirs.CondNames,'s')); %finds which column stores the event s
eIndx = find(strcmp(nirs.CondNames,'e')); %finds which column stores the event s

initialIndx = find(nirs.s(:,sIndx) == 1);
if numel(initialIndx) ~= 1
    error(['Wrong number of s. ', num2str(numel(initialIndx)) ' found, it should be 1']);
end

%correcting the timeline so it matches the start
nirs.t = nirs.t - nirs.t(initialIndx);

if (nargin == 1) %if no endTime is introduced, initializes endTime
    endTime = [];
end

if isempty(endTime)%if no endTime is provided, it checks for the letter e
    finalIndx = find(nirs.s(:,eIndx) == 1);
    disp('No end time provided, getting the end from the last e event')
    if isempty(finalIndx)
        error('Must provide either an endTime or the letter e should be registered, neither one happened here');
    end
elseif endTime == 0 %0 signals using the entire file
    finalIndx = numel(nirs.t); %the final index will be the very last index in the file
    disp('The end is marked as the end of the file')
else
    disp('End time provided, using it');
    finalIndx = find(nirs.t <= endTime);
    finalIndx = finalIndx(end);
end

nirs2 = nirs;
if isfield(nirs,'aux')
    nirs2.aux = nirs.aux(initialIndx:finalIndx,:);
else % I don't know why this is necessary, I added it for the nirs-toolbox to work
    nirs2.aux = zeros(numel(initialIndx:finalIndx,8)); 
end
if isfield(nirs,'ErrorFlags')
    nirs2.ErrorFlags = nirs.ErrorFlags(initialIndx:finalIndx,:);
end

nirs2.d = nirs.d(initialIndx:finalIndx,:);
nirs2.s = nirs.s(initialIndx:finalIndx,:);
nirs2.t = nirs.t(initialIndx:finalIndx,:);

% nirs2 = rmfield(nirs2,'aux');

nirs = nirs2;
save(nirsFileName,'-struct','nirs','-v7.3');
disp([nirsFileName, ' was successfully cut']);
