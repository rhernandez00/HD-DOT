This MATLAB function translates all points so Iz is at 0,0,0 and rotates them so Cz is aligned to Z. Modify it so at the end reverses the translation 
to 0,0,0 and rotation Cz of all points in SrcPos and DetPos 
function [SrcPos,DetPos] = calculatePos(allPos)
 
%Crop out landmarks and polhemus measurement points
landmarks = allPos(1:5,:);
PolPoints = allPos(6:end,:);
nTiles = size(PolPoints,1)/3;
offset = ones(nTiles,1)*18.75; 

%Translate and Rotate so that Iz is at 0 0 0, Nz is at 0 y 0, Ar and Al have same z
%value and Cz is on top
Iz = landmarks(2,:);
landmarks = landmarks - repmat(Iz,size(landmarks,1),1);
PolPoints = PolPoints - repmat(Iz,size(PolPoints,1),1);
Cz = landmarks(5,:);
%Rotate Cz to be in +ve z;
[azimuth,elevation,r] = cart2sph(Cz(1),Cz(2),Cz(3));
landmarks = rotz(landmarks,90-rad2deg(azimuth),[0 0 0]);
PolPoints = rotz(PolPoints,90-rad2deg(azimuth),[0 0 0]);
landmarks = rotx(landmarks,-rad2deg(elevation),[0 0 0]);
PolPoints = rotx(PolPoints,-rad2deg(elevation),[0 0 0]);

Nz = landmarks(1,:);
Iz = landmarks(2,:);
Cz = landmarks(5,:);
[azimuth,elevation,r] = cart2sph(Nz(1)-Iz(1),Nz(2)-Iz(2),Nz(3)-Iz(3));
landmarks = rotz(landmarks,90-rad2deg(azimuth),[0 0 0]);
landmarks = rotx(landmarks,-rad2deg(elevation),[0 0 0]);
PolPoints = rotz(PolPoints,90-rad2deg(azimuth),[0 0 0]);
PolPoints = rotx(PolPoints,-rad2deg(elevation),[0 0 0]);

%ADD ROTATION FOR Ar Al
%Rotate so Ar and Al have same z
Ar = landmarks(3,:);
Al = landmarks(4,:);
[azimuth,elevation,r] = cart2sph(Ar(1)-Al(1),Ar(2)-Al(2),Ar(3)-Al(3));
landmarks = roty(landmarks,rad2deg(elevation),[0 0 0]);
PolPoints = roty(PolPoints,rad2deg(elevation),[0 0 0]);


tile(1,:) = [0 10.81 0];
tile(2,:) = [-10.81*cosd(30) -10.81*sind(30) 0];
tile(3,:) = [10.81*cosd(30) -10.81*sind(30) 0];
tile(4,:) = [0 -8.88 0];
tile(5,:) = [-8.88*cosd(30) 8.88*sind(30) 0];
tile(6,:) = [0 0 0];
tile(7,:) = [8.88*cosd(30) 8.88*sind(30) 0];

%Tile loop;
SrcPos = [];
DetPos = [];

for i = 1:nTiles
    
    p1 = PolPoints(1+(i-1)*3,:);
    p2 = PolPoints(2+(i-1)*3,:);
    p3 = PolPoints(3+(i-1)*3,:);
    PolPoints_tmp = ([p1; p2; p3]);
    midpoint = mean(PolPoints_tmp);
 
    %define vector perpendicular to plane containing 3 measured positions
    plane = [];
    
    x1 = p1(1);
    y1 = p1(2);
    z1 = p1(3);
    
    x2 = p2(1);
    y2 = p2(2);
    z2 = p2(3);
    
    x3 = p3(1);
    y3 = p3(2);
    z3 = p3(3);
    
    % Calculate equation of the plane containing p1, p2, p3 and normal to
    % plane
    A = y1 * (z2 - z3) + y2 * (z3 - z1) + y3 * (z1 - z2);
    B = z1 * (x2 - x3) + z2 * (x3 - x1) + z3 * (x1 - x2);
    C = x1 * (y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2);
    D = -(x1 * (y2 * z3 - y3 * z2) + x2 * (y3 * z1 - y1 * z3) + x3 * (y1 * z2 - y2 * z1));
    
    plane = [A B C D];
    normal = [A B C];
    normnorm = normal./sqrt(sum(normal.^2));
    
    %Use rigid transformation
    H = tile(1:3,:)'*((PolPoints_tmp - repmat(midpoint,3,1)));
    [U,~,V] = svd(H);
    Rot = V*U';
    mappedTile = (Rot*tile')' + repmat(midpoint',1,size(tile,1))';
    
    %Now projection tile in along normal
    projMappedTile = mappedTile - normnorm.*offset(i);
        
    SrcPos = [SrcPos ; projMappedTile(1:3,:)];
    DetPos = [DetPos ; projMappedTile(4:7,:)];
end
