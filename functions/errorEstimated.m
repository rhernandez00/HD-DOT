function totalError = errorEstimated(inputTiles,ds,onlyLocated)
%applies ds to transform the inputTiles into transformedTile and estimates the
%error (totalError) between it and the expected tile
%onlyLocated - use only the tiles flagged as 'located'
if nargin < 3
    onlyLocated = true;
end

if onlyLocated
    indx = strcmp({inputTiles.tileType},'located');
else
    indx = ones(1,numel(tiles));
end
inputTiles = inputTiles(indx);
tilesOut = convertDistance(inputTiles,ds);
difList = zeros(1,numel(tilesOut));%
baseTile = getBaseTile(); %initializes baseTile
for nTile = 1:numel(tilesOut)
    %disp(['checking ', num2str(nTile), ' / ',num2str(numel(tilesOut))]);
    transformedTile = tilesOut(nTile);
    [~,dif] = findOptodes(transformedTile,baseTile); %gives back the adjusted tile (ignored here) and the difference between the adjusted and the input
    difList(nTile) = dif;
end
totalError = sum(difList);

