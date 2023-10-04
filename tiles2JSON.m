function tiles2JSON(localization,baseJSONFile,newJSONFile,varargin)
% localization: path of the files cap and noCap files
% baseJSONFile: original layout file
% newJSONFile: new layout file
% optional: 
% 'tilesUsedForMatch': tiles used to match both localizations in numbers, default: [13,15,16] which correspond to Nz,Ar,Al;
tilesUsedForMatch = getArgumentValue('tilesUsedForMatch',[13,15,16],varargin{:});%{13-'Nz',15-'Ar',16-'Al'};


json_dataOriginal = jsondecode(fileread(baseJSONFile));
json_data = json_dataOriginal;
addpath([pwd,'\functions']);

filesPossible = {'cap','noCap'};

allTiles = [];%cell(1,numel(filesPossible));
for nFileType = 1:numel(filesPossible)
    fileType = filesPossible{nFileType};
    disp(['Processing ', fileType]);
    appProps = load([localization,'_',fileType,'.mat']);

    appProps = appProps.appProps;
    appProps = removeDuplicates(appProps);
    if isfield(appProps,'distances')
        distances = appProps.distances;
    else %this gets the distances from the files in case they are not recorded in the file
        distances = [];
        for nTile = 1:numel(appProps.tiles)
            if strcmp(appProps.tiles(nTile).tileType,'located')
                distances = [distances,appProps.tiles(nTile).ds];
            end
        end
    end
    tiles = appProps.tiles;
    ds = double(trimmean(distances,50));
    %finding the best ds
    disp('searching for best possible distance...')
    mini = @(ds)errorEstimated(tiles,ds);    
    %option 1
    dsE = fminsearch(mini,double(ds)); %searchs a ds with the lowest error
    disp('done searching')
    %option 2 for minimization
%     options = optimset('PlotFcns',@optimplotfval);
%     options.TolX = 0.000001;
%     dsE = fminbnd(mini,double(min(distances)),double(max(distances)),options); %searchs within +/-10% from the possible distances the one with the lowest error
    %[dsE,fval,exitflag,output] = fminbnd(mini,double(min(distances)),double(max(distances)),options); %searchs within +/-10% from the possible distances the one with the lowest error
    tiles = convertDistance(tiles,dsE); %transforms all the coordinates to real-life measurements using the distance calculated in the step before
    tiles = adjustCoords(tiles); %centers to zero and rotates axis so z=0
    allTiles(nFileType).tiles = tiles;
    
end
disp('Merging files...');
tilesOut = mergeTiles(allTiles,tilesUsedForMatch);
%%
disp('Saving to JSON');
optodeList = {'optode_a','optode_b','optode_c'}; %optodes to save 
markerList = {'Nz','Iz','Ar','Al','Cz'};%name of markers, tileNumbers: 13-17
anatomicalMarkers = 13:17; %tileNumber of anatomical markers

%checking which are anatomical markers and which tiles
tileIndx = find(~ismember([tilesOut.tileNumber],[anatomicalMarkers,18])); %18 added here to make an exception and not include it
anatomicalIndx = find(ismember([tilesOut.tileNumber],anatomicalMarkers));

%initializing elements for table
nRow = 1;
ID = cell(numel(tileIndx)*3,1); %identifier of source. e.g. 'dock_7-optode_a'
x = zeros(numel(tileIndx)*3,1); %coordinates of each source
y = zeros(numel(tileIndx)*3,1);
z = zeros(numel(tileIndx)*3,1);
for n = 1:anatomicalMarkers(1) - 1
    tileN = tileIndx(n);
    tile = tilesOut(tileN);
    movedTile = findOptodes(tile);%adjust the location found with the "real" location

    for nOptode = 1:numel(optodeList)
        optode = optodeList{nOptode};
        ID{nRow} = ['dock_',num2str(tile.tileNumber),'-',optode];
        x(nRow) = movedTile.(optode)(1)/10;%Divide by 10 because it should be expressed in cm
        y(nRow) = movedTile.(optode)(2)/10;
        z(nRow) = movedTile.(optode)(3)/10;
        nRow = nRow + 1;
    end
end

Ttiles = table(ID,x,y,z);%creates table for tiles

%initializing elements for table
nRow = 1;
ID = cell(numel(anatomicalIndx),1); %identifier of marker
x = zeros(numel(anatomicalIndx),1); %coordinates of the midpoint of the marker
y = zeros(numel(anatomicalIndx),1);
z = zeros(numel(anatomicalIndx),1);
optode = 'optode_3';
for n = 1:numel(anatomicalIndx)
    tileN = anatomicalIndx(n);
    tile = tilesOut(tileN);    
    movedTile = findOptodes(tile);%adjust the location found with the "real" location
    ID{nRow} = markerList{tile.tileNumber-anatomicalMarkers(1)+1}; %assigns name 
    
    x(nRow) = movedTile.(optode)(1)/10;
    y(nRow) = movedTile.(optode)(2)/10;
    z(nRow) = movedTile.(optode)(3)/10;
    nRow = nRow + 1;    
end
Tanatomical = table(ID,x,y,z);%creates table for anatomical markers
T = [Tanatomical;Ttiles];
% Adding landmarks
for nRow = 1:5
    json_data.landmarks(nRow).x = T.x(nRow)*10;
    json_data.landmarks(nRow).y = T.y(nRow)*10;
    json_data.landmarks(nRow).z = T.z(nRow)*10;
end
% Adding dock number and optode id to table
for nRow = 6:size(T,1)
    ID = T.ID{nRow};
    ID = strsplit(ID,'-');
    
    %T.dock{nRow} = ID{1};
    T.dock(nRow) = str2double(ID{1}(6:end));
    T.optode{nRow} = ID{2};
end
T2 = T(6:end,:);
%% Filling out the field docks
docksPossible = unique(T2.dock);
optodeList = {'optode_1','optode_2','optode_3','optode_4','optode_a','optode_b','optode_c'};
docks = [];
for nDock = 1:numel(docksPossible)
    dock_id = ['dock_',num2str(docksPossible(nDock))];
    docks(nDock).dock_id = dock_id; %#ok<SAGROW>
    tile = getTileFromTable(T,dock_id);
    
    for nOp = 1:numel(optodeList)
        optode_id = optodeList{nOp};
        docks(nDock).optodes(nOp).optode_id = optode_id;
        docks(nDock).optodes(nOp).coordinates_2d = get2DFromLayout(dock_id,optode_id,baseJSONFile);     
        docks(nDock).optodes(nOp).coordinates_3d = tile.(optode_id);
    end
end
json_data.docks = docks; %replacing docks

% Writting the modified data to a new json file
json_string = jsonencode(json_data);
fid = fopen(newJSONFile, 'w');
fwrite(fid, json_string, 'char');
fclose(fid);
disp(['JSON file: ', newJSONFile, ' finished']);