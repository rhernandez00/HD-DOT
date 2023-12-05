function diff = moveAndCheck(coords1,coords2,m)
%applies movement and rotations m to coords2. Then calculates
%difference with coord1.
%m = [0,0,0,0,0,rz];
coordOut = zeros(size(coords2));
for nCoord = 1:size(coords2,1)
    coordOut(nCoord,:) = moveCoord(coords2(nCoord,:),m);
end

diff = zeros(1,size(coords1,1));
for nDif = 1:size(coords1,1)
    diff(nDif) = pdist2(coords1(nDif,:),coordOut(nDif,:),'Euclidean');
end
diff = sum(diff);

