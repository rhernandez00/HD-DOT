function dissimilarity = colorProfile(sampleColor,varargin)
%calculates disimilarity vector for a sample color in RGB (from 0 to 255)
%by comparing it with a list of colors colorList. Returns dissimilarity, a
%vector of dissimilarities of the sample color against the colorList.
%optional arguments:
%colorList - list of colors to try
%distanceMeasure. Distance measure from pdist2, by default uses Euclidean
colorList = getArgumentValue('colorList',[],varargin{:});
distanceMeasure = getArgumentValue('distanceMeasure','Euclidean',varargin{:});
if isempty(colorList)%if empty, gets colors from colorlist
    colorList = getColors(27); %27 is an arbitrary number that gets a list of arbitrary colors
end

sampleColor = double(sampleColor./255); %transforms from 0 to 255 to 0 to 1
dissimilarity = zeros(1,numel(colorList)); %initializes output
for n = 1:numel(colorList)
    color = colorList{n};
    dissimilarity(n) = pdist2(sampleColor,color,distanceMeasure); %checks distance of each color
end