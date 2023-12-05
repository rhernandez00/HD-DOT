function finalDif = testRotation(tile,t)
%applies rotation of plane in x (t(1)), y(t(2)) and z(t(3)) for the points in tile. Gives back
%sum of difference between points in z and between y of points 2 and 3
totalColors = numel(fieldnames(tile));
tx = t(1); ty = t(2); tz = t(3);
M = makehgtform('xrotate',tx);%rotation in x
M = M(1:3,1:3);
for nColor = 1:totalColors
    tile.(['color',num2str(nColor)]) = (M*tile.(['color',num2str(nColor)])')';
end

M = makehgtform('yrotate',ty);%rotation in y
M = M(1:3,1:3);
for nColor = 1:totalColors
    tile.(['color',num2str(nColor)]) = (M*tile.(['color',num2str(nColor)])')';
end

M = makehgtform('zrotate',tz);%rotation in z
M = M(1:3,1:3);
for nColor = 1:totalColors
    tile.(['color',num2str(nColor)]) = (M*tile.(['color',num2str(nColor)])')';
end

pairs = combinator(totalColors,2,'c'); %to determine which differences to calculate
allDifs = zeros(1,size(pairs,1)); %vector to save the differences between z of points
for nPair = 1:size(pairs,1)
    nColor1 = pairs(nPair,1);
    nColor2 = pairs(nPair,2);
    allDifs(nPair) = abs(tile.(['color',num2str(nColor1)])(3) - tile.(['color',num2str(nColor2)])(3));    
end

difZ = sum(allDifs)*5; %final result
difY = abs(tile.color2(2) - tile.color3(2)); %difference in Y for points 2 and 3 (base of the triangle)
finalDif = difZ + difY;
