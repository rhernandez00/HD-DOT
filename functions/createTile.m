load('test3.mat');
tiles = appProps.tiles;



% size(outputTable,1)


%% function createTile(tileCenter,nTile)
load('test3.mat');
%currentTiles = appProps.currentTiles;
originalCloud = appProps.originalCloud;
tiles = appProps.tiles;
%colorSample = appProps.colorSample;
%recolored = appProps.recolored;
%recoloredList = appProps.recoloredList;
%%

movedTile = findOptodes(tiles(1));

%%
colorList = getColors(28);
nCenter = 1;

totalDots = 4;
colorNumber = char;%[];%cell(1,totalDots);
for nDot = 1:4
% nDot = 1;
    coords = tileCenters(nCenter).(['dot',num2str(nDot)]);
    k = dsearchn(originalCloud.Location,coords);
    colorInPoint = originalCloud.Color(k,:);
    dissimilarity = colorProfile(colorInPoint,'colorList',colorList);
    [~,nColor] = min(dissimilarity);
    colorNumber(nDot) = num2str(nColor-1);
end
tileNumber = base2dec(colorNumber,3);
tileCenters(nCenter).tileNumber;
d1 = pdist2(tileCenters(nCenter).color1,tileCenters(nCenter).color2,'euclidean');
d2 = pdist2(tileCenters(nCenter).color1,tileCenters(nCenter).color3,'euclidean');
d3 = pdist2(tileCenters(nCenter).color2,tileCenters(nCenter).color3,'euclidean');
tileCenters(nCenter).ds = [d1,d2,d3];

%y = mean([tileCenters(nCenter).color1(1),tileCenters(nCenter).color2(1),tileCenters(nCenter).color3(1)]);
%z = mean([tileCenters(nCenter).color1(1),tileCenters(nCenter).color2(1),tileCenters(nCenter).color3(1)]);




%%
totalColors = numel(fieldnames(tileCenter));
nTile = 1;

for nColor = 1:totalColors %assigns the coordinates of the colors to tile
    tile.(['color',num2str(nColor)])= tileCenter(nTile).(['color',num2str(nColor)]);
end




%% Calculate rotation
t0 = [0,0,0]; %initial values for minimization
miniZ = @(t)testRotation(tile,t);
t = fminsearch(miniZ,t0);
tileOut = rotateTile(tile,t);

locations = [tileOut.color1;tileOut.color2;tileOut.color3];
% locations(:,3) = 0;
colors = [colorList{1};colorList{2};colorList{3}];
%%
close all
ptCloudMod = pointCloud(locations,'Color',colors,'Normal',[]);
pcshow(ptCloudMod, 'MarkerSize', 300); hold on
set(gcf,'color','w');
set(gca,'color','w');
xlabel('X (mm)')
ylabel('Y (mm)')
zlabel('Z (mm)')

%%
% t =2;
% M = makehgtform('xrotate',t);
% M = M(1:3,1:3);
% 
% clf
% newLocation = ptCloud.Location;
% for nRow = 1:size(ptCloud.Location,1)
%     newLocation(nRow,:) = M*newLocation(nRow,:)';
% end
% 
% ptCloudMod = pointCloud(newLocation,'Color',ptCloud.Color,'Normal',ptCloud.Normal);
% pcshow(ptCloudMod); hold on
% set(gcf,'color','w');
% set(gca,'color','w');
% xlabel('X (mm)')
% ylabel('Y (mm)')
% zlabel('Z (mm)')