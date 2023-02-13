function finalDif = calculateMatch(tile,mt,mr,baseTile)
%applies the movement and rotation vector m to baseTile and compares it
%with tile for each matching fields (the name of the fields is different
%between them). Outputs finalDif, which is sum of the distance each matching field
if nargin < 3
    baseTile = getBaseTile();
    m = mt;
else
    m = [mt(1),mt(2),mt(3),mr(1),mr(2),mr(3)];
end

fieldsInTile = {'color1','color2','color3','midpoint'};
fieldsInBaseTile = {'optode_a','optode_b','optode_c','optode_3'};

baseTile = moveTile(baseTile,m,fieldsInBaseTile); %applies the movement to the fields

%calculates the difference between the coordinates on each field
alldifs = zeros(1,numel(fieldsInTile));
for nDif = 1:numel(fieldsInTile)
    currentField = fieldsInTile{nDif};
    currentFieldB = fieldsInBaseTile{nDif};
    alldifs(nDif) = pdist2(tile.(currentField),baseTile.(currentFieldB));
end

finalDif = sum(alldifs); %calculates the sum of all differences
