function coordOut = moveCoord(coordIn,m)
%applies translation and rotation planes in x, y and z
%the first three are translations, the final 3 are rotations

rx = m(4); ry = m(5); rz = m(6); %rotations
M = makehgtform('xrotate',rx);%rotation in x
M = M(1:3,1:3);

coordOut = coordIn*M;

M = makehgtform('yrotate',ry);%rotation in y
M = M(1:3,1:3);

coordOut = coordOut*M;

M = makehgtform('zrotate',rz);%rotation in z
M = M(1:3,1:3);
coordOut = coordOut*M;


tx = m(1); ty = m(2); tz = m(3); %translations
coordOut(1) = coordOut(1) + tx;
coordOut(2) = coordOut(2) + ty; 
coordOut(3) = coordOut(3) + tz;
