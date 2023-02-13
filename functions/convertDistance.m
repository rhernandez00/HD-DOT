function [tilesOut,conversion] = convertDistance(tiles,ds)
a2b = 18.7235; %this is what the distance should be in mm
conversion = a2b/ds; %transformation to mm
fieldsInTile = {'color1','color2','color3','midpoint'};
for n = 1:numel(tiles)
    for nField = 1:numel(fieldsInTile)
        fieldN = fieldsInTile{nField};
        tilesOut(n).(fieldN) = double(tiles(n).(fieldN).*conversion); %#ok<AGROW>
    end
    tilesOut(n).tileNumber = tiles(n).tileNumber;
    tilesOut(n).tileType = tiles(n).tileType;
end