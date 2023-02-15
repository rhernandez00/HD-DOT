
participant = 'Kunkun';
session = 1;
locationsFolder = ['G:\My Drive\Laugh\HD-DOT\photogrammetry'];

dataFolder = 'G:\My Drive';
% csvName = [dataFolder,'\',experiment,'\raw\',participant,'_pos.csv'];
locationsFile = [locationsFolder,'\','Kunkun_session',sprintf('%02d',session),'_realDistance_aligned.mat'];


tiles = [];
distances = [];
appProps = load(locationsFile);
appProps = appProps.appProps;
distances = [distances,appProps.distances];
tiles = appProps.tiles;


%%

dList = [];
n = 1;
for nTile = 1:numel(tiles)
    dList(n) = pdist2(tiles(nTile).color1,tiles(nTile).color2);
    n = n +1;
    dList(n) = pdist2(tiles(nTile).color1,tiles(nTile).color3);
    n = n +1;
    dList(n) = pdist2(tiles(nTile).color2,tiles(nTile).color3);
    n = n +1;
end


%%
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
%tiles = adjustCoords(tiles); %centers to zero and rotates axis so z=0
%     end
    

    
% end

% tilesOut = mergeTiles(allTiles,tilesUsedForMatch);
tilesOut = tiles;
%% Creating the csv file

optodeList = {'optode_a','optode_b','optode_c'}; %optodes to save in csv
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


% Getting 
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
%Tanatomical

T = [Tanatomical;Ttiles];

writetable(T,csvName);
disp(['file finished: ' csvName]);
