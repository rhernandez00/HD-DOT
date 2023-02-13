function [adjustedTile,dif] = findOptodes(inputTile,baseTile)
%finds the best adjustment (m) so inputTile's dots match the optodes of
%baseTile, gives back the adjustedTile and calculates the mismatch (dif)
if nargin < 2
    baseTile = getBaseTile(); %initializes baseTile
end
options.MaxFunEvals = 100000;
options.MaxIter = 100000;
mt = [inputTile.midpoint(1),inputTile.midpoint(2),inputTile.midpoint(3)];
%m0 = [inputTile.midpoint(1),inputTile.midpoint(2),inputTile.midpoint(3),0,0,0];
m0 = [0,0,0];
miniZ = @(mr)calculateMatch(inputTile,mt,mr,baseTile); %,mt,mr,
mr = fminsearch(miniZ,m0,options);
if nargin < 2
    baseTile = getBaseTile();%creates a baseTile
end
fieldsInBaseTile = {'optode_a','optode_b','optode_c','optode_1','optode_2','optode_3','optode_4'}; %fields to move
m = [mt(1),mt(2),mt(3),mr(1),mr(2),mr(3)];
adjustedTile = moveTile(baseTile,m,fieldsInBaseTile); %applies the adjustment (m) to the fields (fieldsInBaseTile) in baseTile

dif = calculateMatch(inputTile,mt,mr,baseTile); %calculates difference between inputTile and adjusted tile (only uses the 4 fields related to color1-3 and midpoint)


%%
% load('test3.mat');
% tiles = appProps.tiles;
% ds = trimmean([tiles.ds],10); %median distance between dots for all tiles
% a2b = 18.7235; %this is what the distance should be in mm
% conversion = a2b/ds; %transformation to mm
% nTile = 1;
% tile = tiles(nTile);
% tile.color1 = double(tile.color1.*conversion);
% tile.color2 = double(tile.color2.*conversion);
% tile.color3 = double(tile.color3.*conversion);
% tile.midpoint = double(tile.midpoint.*conversion);
% movedTile = findOptodes(tile);



