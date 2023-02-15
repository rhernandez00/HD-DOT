function tileOut = moveTile(tile,m,fields)
%applies movement "m" to the fields listed in "fields" of a structure
%"tile". m is a 6 number vector. Translation and rotation planes in x, y and z
%the first three are translations, the final 3 are rotations
if nargin < 3
    fields = fieldnames(tile);
end

for nField = 1:numel(fields)
    currentField = fields{nField};
    tile.(currentField) = moveCoord(tile.(currentField),m);
end

tileOut = tile;