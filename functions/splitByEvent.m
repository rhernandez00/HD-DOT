function e = splitByEvent(nirs,eventList,condNames,timeBefore,timeAfter)
nChannels = size(nirs.d,2);
for nEvent = 1:size(eventList,2)
    onset = eventList(nEvent).onset;
    duration = eventList(nEvent).duration;
    indx = nirs.t >= onset-timeBefore & nirs.t < onset + duration + timeAfter;
    d = nirs.d(indx,:)';
    
    e(nEvent).cond = condNames{eventList(nEvent).type};
    e(nEvent).d = d;
    e(nEvent).dLen = size(d,2);

end


% dLenMax = max([e.dLen]);
% for nEvent = 1:size(e,2)
%     newd = nan(dLenMax);
%     e(nEvent).d = 
% end
%         
% 
