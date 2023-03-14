function nirs = addStimuliToNIRS(nirs,eventList,groupingVar,condNames,condNumbers)
% The function adds (or replaces) the field s in the nirs structure 
% according to the stimuli onsets found in eventList. It also adds/replaces
% the field CondNames.
% eventList is a table-like structure that contains a field with the 
% name as the string input groupingVar. This field represents the possible
% stimuli categories. Each row in eventList contains an onset and duration
% fields.
% condNames is a cell with the names of each of the conditions
% condNumbers is a vector that contains the numbers for each of the
% conditions as found in eventList

nirs.CondNames = condNames;
s = zeros(numel(nirs.t),numel(condNames)); %vector that marks the presence of stimuli

for nCond = 1:numel(condNames)
    condition = condNumbers(nCond);
    eventListF = eventList([eventList.(groupingVar)] == condition);
    
    for nEvent = 1:size(eventListF,2)
        onset = eventListF(nEvent).onset;
        duration = eventListF(nEvent).duration;
        indx = nirs.t >= onset & nirs.t < onset + duration;
        s(indx,nCond) = 1;
    end

end
nirs.s = s; %adds s to nirs