function newTile = createCustomTile(ds)
%creates a custom tile
baseTile = getBaseTile();
if isempty(ds)
    ds = 0.0566;
else
    ds = mean(ds);
end
a2b = 18.7235; %this is what the distance should be in mm
conversion = ds/a2b;%transformation from mm to the space of the dotcloud


newTile.dotList = {'color1','color2','color3','midpoint'};
newTile.color1 = baseTile.optode_a.*conversion;
newTile.color2 = baseTile.optode_b.*conversion;
newTile.color3 = baseTile.optode_c.*conversion;
newTile.midpoint = baseTile.optode_3.*conversion;
newTile.colorList = getColors(28);
newTile.colorList{4} = [0,0,0];
newTile.tileType = 'created'; %defines whether the tile was located or created
