function tilesE = findTiles(e,nColor,originalCloud)
%Finds the closest centers of the other colors for all centers of nColor.
%Each group becomes a tile. The function gives back tileCenter, an
%structure that contains the center of each of the colors
%tilesE contains:
%.tileNumber: number of tile identified through the dots color code
%.color1,.color2,.color3:  coordinates of dots magenta, blue and yellow.
%.dot1, .dot2, .dot3, .dot4: coordinates of dots 1-4;
%.ds distances between color1-color2, color1-color3 and color2-color3
%.midpoint center of the tile

if nargin < 2 %if no nColor is specified, uses the first one as default
    nColor = 1;
end

allColors  = 1:size(e,2); %gets all possible colors
allCenters = 1:size(e(nColor).centers,1);%all centers for the choosen color
colorList = getColors(29); %list of colors that code the number of tile

for nTile = 1:numel(allCenters)
    coords = e(nColor).centers(nTile,:); %coordinates of the center
    tilesE(nTile).(['color',num2str(nColor)]) = coords;  %#ok<AGROW>

    otherColors = allColors(~(allColors == nColor)); %finds out which colors are not nColor
    closestCenters = zeros(1,numel(otherColors)); %vector that will store the index of the other centers for the corresponding tile
    for k = 1:numel(otherColors)
        nColor2 = otherColors(k);
        otherCenters = 1:size(e(nColor2).centers,1);
        distances = zeros(1,numel(otherCenters));
        for n = 1:numel(otherCenters)
            testCenter = otherCenters(n);
            coords2 = e(nColor2).centers(testCenter,:);
            d = pdist2(coords,coords2, 'euclidean'); %calculates distance between current center and test center
            distances(n) = d;
        end

        [~,indx] = min(distances);
        closestCenters(k) = indx;

        tilesE(nTile).(['color',num2str(nColor2)]) = e(nColor2).centers(indx,:); 
    end
end

for nTile = 1:numel(allCenters)
    coords = zeros(1,3);
    for nCoord = 1:3
        coords(nCoord) = mean([tilesE(nTile).color1(nCoord),tilesE(nTile).color2(nCoord),tilesE(nTile).color3(nCoord)]);
    end
    
    tilesE(nTile).midpoint = coords;
    dot4 = coords;
    
    dot1 = zeros(1,3);
    for nCoord = 1:3
        dot1(nCoord) = mean([tilesE(nTile).color1(nCoord),tilesE(nTile).color2(nCoord)]);
    end
    dot2 = zeros(1,3);
    for nCoord = 1:3
        dot2(nCoord) = mean([tilesE(nTile).color1(nCoord),tilesE(nTile).color3(nCoord)]);
    end
    dot3 = zeros(1,3);
    for nCoord = 1:3
        dot3(nCoord) = mean([tilesE(nTile).color2(nCoord),tilesE(nTile).color3(nCoord)]);
    end
    tilesE(nTile).dot1 = dot1;
    tilesE(nTile).dot2 = dot2;
    tilesE(nTile).dot3 = dot3;
    tilesE(nTile).dot4 = dot4;
    tilesE(nTile).tileType = 'located'; %defines whether the tile was located or created
    


    colorNumber = char;%variable that will save in base 3 the number of tile
    for nDot = 1:4 %identifies the closest point to the estimated coordinates of each dot
        coords = tilesE(nTile).(['dot',num2str(nDot)]);
        k = dsearchn(originalCloud.Location,coords);
        colorInPoint = originalCloud.Color(k,:);
        dissimilarity = colorProfile(colorInPoint,'colorList',colorList); %finds best match
        [~,nColor] = min(dissimilarity);
        colorNumber(nDot) = num2str(nColor-1);
    end
    
    tileNumber = base2dec(colorNumber,3) + 1;
    tilesE(nTile).tileNumber = tileNumber; %adds the tile number in base 3 to structure
    %This is to calculate the distances between the dots of colors 1,2,3
    d1 = pdist2(tilesE(nTile).color1,tilesE(nTile).color2,'euclidean');
    d2 = pdist2(tilesE(nTile).color1,tilesE(nTile).color3,'euclidean');
    d3 = pdist2(tilesE(nTile).color2,tilesE(nTile).color3,'euclidean');
    tilesE(nTile).ds = [d1,d2,d3];
    
end




