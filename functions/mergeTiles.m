function tilesOut = mergeTiles(allTiles,tilesUsedForMatch)
%finds best match between the tilesUsedForMatch. Then takes all tiles from
%tiles2 (anatomical) and merges them with tiles1 replacing existing anatomical tiles in tiles1
tiles1 = allTiles(1).tiles;
tiles2 = allTiles(2).tiles;

coords1 = zeros(numel(tilesUsedForMatch),3);
for nTile = 1:numel(tilesUsedForMatch)
    tileN = tilesUsedForMatch(nTile);
    indx = find([tiles1.tileNumber] == tileN);
    coords1(nTile,:) = tiles1(indx).midpoint; 
end

coords2 = zeros(numel(tilesUsedForMatch),3);
for nTile = 1:numel(tilesUsedForMatch)
    tileN = tilesUsedForMatch(nTile);
    indx = find([tiles2.tileNumber] == tileN);
    coords2(nTile,:) = tiles2(indx).midpoint; 
end
%

%Finding the best rotation so coords2 matches coords1 (quicker)
options.MaxFunEvals = 100000;
options.MaxIter = 100000;
rz0 = 0;
miniZ = @(rz)rotateCoordAndCheck2(coords1,coords2,rz);
rz = fminsearch(miniZ,rz0,options);

% %Finding the best movement so coords2 matches coords1 (slower but more
% accurate)
m0 = [0,0,0,0,0,rz];
miniZ = @(m)moveAndCheck(coords1,coords2,m);
m = fminsearch(miniZ,m0,options);


fieldsToMove = {'color1','color2','color3','midpoint'};
tiles2Moved = [];
for nTile = 1:numel(tiles2)
    tile = tiles2(nTile);
    for nField = 1:numel(fieldsToMove)
        fieldName = fieldsToMove{nField};
        tiles2Moved(nTile).(fieldName) = moveCoord(tile.(fieldName),m);  %#ok<SAGROW>
    end
    tiles2Moved(nTile).tileNumber = tiles2(nTile).tileNumber; %#ok<SAGROW>    
end

%% Takes anatomical tiles from tiles2Moved and the remaining from tiles1
tilesOut = [];
allTiles2 = [tiles1,tiles2Moved];
tilesPossible = unique([allTiles2.tileNumber]);
fieldsPossible = {'color1','color2','color3','midpoint','tileNumber'};
anatomicalTiles = 13:17;

for nTile = 1:numel(tilesPossible)
    tileN = tilesPossible(nTile);
    if ismember(tileN,anatomicalTiles)
        indx = find([tiles2Moved.tileNumber] == tileN);
        currentTile = tiles2Moved(indx);
    else
        indx = find([tiles1.tileNumber] == tileN);
        currentTile = tiles1(indx);
    end
    
    for nField = 1:numel(fieldsPossible)
        currentField = fieldsPossible{nField};
        tilesOut(nTile).(currentField) = currentTile.(currentField);
    end
end

