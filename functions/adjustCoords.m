function tilesOut = adjustCoords(tiles)
%takes tiles. Uses anatomical markers Ar, Al and Nz to move all the tiles
%so the center of the head is zero and then finds the rotation so z = 0;

tilesUsedForMatch = [13,15,16]; %{'Nz','Ar','Al'};

coords1 = zeros(numel(tilesUsedForMatch),3);

for nTile = 1:numel(tilesUsedForMatch)
    tileN = tilesUsedForMatch(nTile);
    indx = find([tiles.tileNumber] == tileN);
    coords1(nTile,:) = tiles(indx).midpoint; %#ok<FNDSB>
end

%Displacing to zero
mid1 = mean(coords1);
coords1(:,1) = coords1(:,1) - mid1(1);
coords1(:,2) = coords1(:,2) - mid1(2);
coords1(:,3) = coords1(:,3) - mid1(3);

%Finding right rotation
coords = coords1;
options.MaxFunEvals = 100000;
options.MaxIter = 100000;
m0 = [0,0,0];
miniZ = @(m)rotateCoordAndCheck(coords,m);
mr = fminsearch(miniZ,m0,options);
m = [0,0,0,mr(1),mr(2),mr(3)];

fieldsToMove = {'color1','color2','color3','midpoint'};
for nTile = 1:numel(tiles)
    for nField = 1:numel(fieldsToMove)
        fieldName = fieldsToMove{nField};
        tilesOut(nTile).(fieldName) = tiles(nTile).(fieldName) - mid1; %#ok<AGROW>
        tilesOut(nTile).(fieldName) = moveCoord(tilesOut(nTile).(fieldName),m); %#ok<AGROW>
    end
    tilesOut(nTile).tileNumber = tiles(nTile).tileNumber;
    %tilesOut(nTile).tileType= tiles(nTile).tileType;
end


% 
% function [errorOut] = adjustCoords(coords,mr)
% %applies rotation mr to the three coords. Then calculates the sum of all y
% %and all z
% m = [0,0,0,mr(1),mr(2),mr(3)];
% coordOut = zeros(size(coords));
% for nC = 1:size(coords,1)
%     coordOut(nC,:) = moveCoord(coords(nC,:),m);
%     
% end
% 
% 
% %errorOut = pdist2(mean(coordOut),[0,0,0],'Euclidean');%sum(mean(coordOut));
% %disp(errorOut)
% errorOut = sum(abs(coordOut(:,3))) + abs(coordsOut(2,2) - coords(3,2)); 
% %errorOut = abs(coordOut(1,2)) + abs(coordOut(2,2)) + abs(coordOut(3,2)) + abs(coordOut(1,3)) + abs(coordOut(2,3)) + abs(coordOut(3,3));
% 
% % errorOut = sum(abs(coordOut(:,3)));% + sum(abs(coordOut(:,2))); %so that y = 0, z = 0