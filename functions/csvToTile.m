% function csvToTile(csvFile)
csvFile = 'C:\Users\Hallgato\Desktop\HDDOT_tests\data\Original\raw\Kunkun_pos.csv';
T = readtable(csvFile);
markerList = {'Nz','Iz','Ar','Al','Cz','Nose'};%name of markers, tileNumbers: 13-17
anatomicalMarkers = 13:18; %tileNumber of anatomical markers
dotList = {'color1','color2','color3'};
totalTiles = size(T,1);


nTile = 7;


tile = [];
ID = T.ID{nTile};
if sum(strcmp(ID,markerList))
    tileNumber = anatomicalMarkers(strcmp(ID,markerList));
    for nDot = 1:numel(dotList)
        dotName = dotList{nDot};
        tile.(dotName) = [T.x(nTile),T.y(nTile),T.z(nTile)];
    end
    tile.midpoint = [T.x(nTile),T.y(nTile),T.z(nTile)];
else
    indx1 = strfind(ID,'_');
    indx2 = strfind(ID,'-');
    tileNumber = str2double(ID(indx1(1)+1:indx2(1)-1));
    for nDot = 1:numel(dotList)
        dotName = dotList{nDot};
        tile.(dotName) = [T.x(nTile),T.y(nTile),T.z(nTile)];
        nTile = nTile + 1;
    end
    tile.midpoint = [mean([tile.color1(1),tile.color2(1),tile.color3(1)]),...
        mean([tile.color1(2),tile.color2(2),tile.color3(2)]),...
        mean([tile.color1(3),tile.color2(3),tile.color3(3)])];
end
tile.tileNumber = tileNumber;
tile




