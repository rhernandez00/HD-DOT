function coords = getLandmarksR(participant)
%This function reads the landmarks from the scanned _noCap_aligned file
% clear
getDriveFolder;
% participant = 'Odin';
propsFile = [driveFolder,'\NIRS\Shared\',participant,'_noCap_aligned.mat'];
appProps = load(propsFile);
tiles = appProps.appProps.tiles;

tileNumbers = [tiles.tileNumber];
tilesToUse = 13:17;

coords = zeros(numel(tilesToUse),3); %This is where the coordinates of landmarks will be saved
for nTile = 1:numel(tilesToUse)
    tileN = tilesToUse(nTile); %specific tile number to read
    tileIndx = find(tileNumbers == tileN);
    if isempty(tileIndx)
        error(['Tile not found: ', num2str(tileN)]);
    end
    if numel(tileIndx) > 1
        error(['More than one found: ', num2str(numel(tileIndx))]);
    end
    coords(nTile,1) = tiles(tileIndx).midpoint(1);
    coords(nTile,2) = tiles(tileIndx).midpoint(2);
    coords(nTile,3) = tiles(tileIndx).midpoint(3);    
end


