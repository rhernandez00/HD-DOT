function indx = checkWithinTile(tilesE,nTile,Location)
%takes a tile, determines a sphere surrounding it and determines which dots from
%a point cloud (location) are located within the radius of the center of the tile
%inputs: tilesE structure with data for each tile, output of createTile.m
%nTile: number of tile from structure tilesE
%Location: point cloud coordinates

proportionOfRad = 1; %proportion of the distance between color 1,2,3 to use
%as radius

d1 = pdist2(tilesE(nTile).color1,tilesE(nTile).color2,'euclidean');
d2 = pdist2(tilesE(nTile).color1,tilesE(nTile).color3,'euclidean');
d3 = pdist2(tilesE(nTile).color2,tilesE(nTile).color3,'euclidean');
ds = [d1,d2,d3];
radius = mean(ds)*proportionOfRad;

center=tilesE(nTile).midpoint;

indx = zeros(size(Location,1),1);
for nPoint = 1:size(Location,1)
    point = Location(nPoint,:);
    inside=(radius^2>=sum((point-center).^2));
    indx(nPoint) = inside;
end
indx = logical(indx);
