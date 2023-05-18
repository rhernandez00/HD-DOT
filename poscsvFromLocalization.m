clear
getDriveFolder;
addpath([driveFolder,'\HD-DOT\HD-DOT\functions']);

participant = 'Odin';
specie = 'D';
session = 2;
experiment = 'Voice_sens2';
locationsFolder = [driveFolder,'\',experiment,'\photogrammetry'];

dataFolder = 'G:\My Drive';

locationsFile = [locationsFolder,'\',participant,'_session',sprintf('%02d',session),'_realDistance_aligned.mat'];
layoutsPath = [driveFolder,'\',experiment,'\layouts'];
if ~exist(layoutsPath, 'dir')
    disp("layouts folder doesn't exist, creating one: ");
    disp(layoutsPath);
    mkdir(layoutsPath);
end
csvName = [layoutsPath,'\',participant,'_session',sprintf('%02d',session),'_pos.csv'];
meshType = [specie,participant];
[~,mesh] = getMesh(meshType,true);


appProps = load(locationsFile);
appProps = appProps.appProps;
distances = appProps.distances;
tiles = appProps.tiles;


% This gets the distances between dots. Used to make sure that the distances are close to what is expected
dList = zeros(1,numel(tiles)*3);
n = 1;
for nTile = 1:numel(tiles)
    dList(n) = pdist2(tiles(nTile).color1,tiles(nTile).color2);
    n = n +1;
    dList(n) = pdist2(tiles(nTile).color1,tiles(nTile).color3);
    n = n +1;
    dList(n) = pdist2(tiles(nTile).color2,tiles(nTile).color3);
    n = n +1;
end

% Creating the csv file

optodeList = {'optode_a','optode_b','optode_c'}; %optodes to save in csv
fieldList = {'color1','color2','color3'}; %the names in the structure tile corresponding to optodeList
landmarksNames = {'Nz','Iz','Ar','Al','Cz'};%name of landmarks
%checking which are anatomical markers and which tiles

% --- Creates with the locations of the optodes ---
tileIndx = [tiles.tileNumber];
%initializing elements for table
nRow = 1;
ID = cell(numel(tileIndx)*3,1); %identifier of source. e.g. 'dock_7-optode_a'
x = zeros(numel(tileIndx)*3,1); %coordinates of each source
y = zeros(numel(tileIndx)*3,1);
z = zeros(numel(tileIndx)*3,1);
for n = 1:numel(tileIndx)
    tileN = tileIndx(n);
    tile = tiles(n);
    %This is used to improve the localization of the dots, however, the
    %algorithm needs improvement, so I will use the localizations obtained
    %from the scan
    %movedTile = findOptodes(tile);%adjust the location found with the "real" location
    for nOptode = 1:numel(optodeList)
        optode = optodeList{nOptode};
        fieldName = fieldList{nOptode};
        
        ID{nRow} = ['dock_',num2str(tile.tileNumber),'-',optode];
        x(nRow) = tile.(fieldName)(1)/10;%Divide by 10 because it should be expressed in cm
        y(nRow) = tile.(fieldName)(2)/10;
        z(nRow) = tile.(fieldName)(3)/10;
        
        %This is to use the adjusted localization
        %x(nRow) = movedTile.(optode)(1)/10;%Divide by 10 because it should be expressed in cm
        %y(nRow) = movedTile.(optode)(2)/10;
        %z(nRow) = movedTile.(optode)(3)/10;
        nRow = nRow + 1;
    end
end

Ttiles = table(ID,x,y,z);%creates table for tiles
% --- -----------------------------------------------------
% ----------- Creates the table for the landmarks ----------
%initializing elements for table
ID = cell(numel(landmarksNames),1); %identifier of marker
x = zeros(numel(landmarksNames),1); %coordinates of the midpoint of the marker
y = zeros(numel(landmarksNames),1);
z = zeros(numel(landmarksNames),1);
for nRow = 1:numel(landmarksNames)
    ID{nRow} = landmarksNames{nRow}; %assigns name 
    x(nRow) = mesh.landmarks(nRow,1)/10; %Divide by 10 because it should be expressed in cm
    y(nRow) = mesh.landmarks(nRow,2)/10;
    z(nRow) = mesh.landmarks(nRow,3)/10;
end
Tanatomical = table(ID,x,y,z);%creates table for anatomical markers
% ----------------------------------------------------------
T = [Tanatomical;Ttiles]; %appending both tables on final table T

writetable(T,csvName);
disp(['file finished: ' csvName]);
