%This script loads  the .mat file with some of the tiles located to
%calculate the real world distance in the pointcloud and then transform the
%distances in it. The file is saved as [cloudName]_realDistance.ply
clc
clear
getDriveFolder;
% cloudFolder = [driveFolder,'\Laugh\HD-DOT\photogrammetry'];
cloudFolder = ['G:\My Drive\Voice_sens2\photogrammetry'];
participant = 'Kunkun';
sessionN = 2;
cloudName = [participant,'_session',sprintf('%02d',sessionN)];


propsFile = [cloudFolder,'/',cloudName,'_distances.mat'];
cloudFile = [cloudFolder,'/',cloudName,'.ply'];
newCloudFile = [cloudFolder,'/',cloudName,'_realDistance.ply'];

appProps = load(propsFile);
appProps = appProps.appProps;

distances = [];
for nTile = 1:numel(appProps.tiles)
    if strcmp(appProps.tiles(nTile).tileType,'located')
        distances = [distances,appProps.tiles(nTile).ds];
    end
end
tiles = appProps.tiles;

ds = double(mean(distances));
%This part estimates the ds with the lowest error
disp('searching for the best possible distance...')
mini = @(ds)errorEstimated(tiles,ds);
dsE = fminsearch(mini,double(ds)); %searchs a ds with the lowest error
disp('done searching')

%calculates the conversion using dsE
[~,conversion] = convertDistance(tiles,dsE);

%Loading the original cloud, applying the conversion and saving the
%converted cloud
originalCloudRead = pcread(cloudFile);
newLocation = originalCloudRead.Location.*conversion;
ptCloud = pointCloud(newLocation,Color=originalCloudRead.Color,Normal=originalCloudRead.Normal);
pcwrite(ptCloud,newCloudFile);
disp([newCloudFile, ' file saved']);