function tileOut = rotateTile(tile,t)
%applies rotation of plane in x (t(1)), y(t(2)) and z(t(3)) to tile
totalColors = 3;%numel(fieldnames(tile));
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
tileOut = tile;


