% function [optode_1, optode_2, optode_3, optode_4] = calculateOptodes(optode_a, optode_b, optode_c)
function [outputTile] = calculateOptodes(inputTile)
optode_a = inputTile.optode_a;
optode_b = inputTile.optode_b;
optode_c = inputTile.optode_c;
distance = 8.8800;
% distance = 0;
% distance = 88.800;

% Find the midpoint of optode_b and optode_c
optode_3 = mean([optode_a;optode_b;optode_c]);

% calculate vectors for optode_a to optode_3 and optode_b to optode_3
% calculate the midpoint of the line formed by optode_a and optode_b
midpoint_ab = (optode_a + optode_b) / 2;

% calculate the vector that goes from optode_3 to the midpoint
v = midpoint_ab - optode_3;
v = v / norm(v);

% calculate the end point by starting from optode_3 and moving along the 
% direction of the vector for a distance of 8.88
optode_2 = optode_3 + v * distance;

% calculate the midpoint of the line formed by optode_a and optode_c
midpoint_ac = (optode_a + optode_c) / 2;

% calculate the vector that goes from optode_3 to the midpoint
v = midpoint_ac - optode_3;
v = v / norm(v);

% calculate the end point by starting from optode_3 and moving along the 
% direction of the vector for a distance of 8.88
optode_4 = optode_3 + v * distance;

% calculate the midpoint of the line formed by optode_b and optode_c
midpoint_bc = (optode_b + optode_c) / 2;

% calculate the vector that goes from optode_3 to the midpoint
v = midpoint_bc - optode_3;
v = v / norm(v);

% calculate the end point by starting from optode_3 and moving along the 
% direction of the vector for a distance of 8.88
optode_1 = optode_3 + v * distance;
inputTile.optode_1 = optode_1;
inputTile.optode_2 = optode_2;
inputTile.optode_3 = optode_3;
inputTile.optode_4 = optode_4;

optodeList = {'optode_1','optode_2','optode_3','optode_4','optode_a','optode_b','optode_c'};
axList = {'x','y','z'};
for nOp = 1:numel(optodeList)
    optode_id = optodeList{nOp};
    for nAx = 1:numel(axList)
        outputTile.(optode_id).(axList{nAx}) = inputTile.(optode_id)(nAx);
    end
end
% 
% outputTile = inputTile;
% 
% 
% outputTile.optode_1 = optode_1;
% outputTile.optode_1.x = optode_1(1);
% outputTile.optode_1.y = optode_1(2);
% outputTile.optode_1.z = optode_1(1);
% outputTile.optode_2 = optode_2;
% outputTile.optode_3 = optode_3;
% outputTile.optode_4 = optode_4;