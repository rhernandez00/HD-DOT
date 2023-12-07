function outputTile = getTileFromTable(T,dock_id)
%Reads a table from a _pos.csv file. Generates a structure outputTile
%which has as fields each of the optodes (a,b,c,1,2,3,4).
dockNum = str2double(dock_id(6:end));
fieldsInTile = {'optode_a','optode_b','optode_c'};
T2 = T([T.dock]==dockNum,:);

inputTile = [];
for nField = 1:numel(fieldsInTile)
    indx = find(strcmp(T2.optode,fieldsInTile{nField}));
    inputTile.(fieldsInTile{nField}) = [T2.x(indx),T2.y(indx),T2.z(indx)];
end

%option 1. Using geometry. It failed. Should correct
outputTile = calculateOptodes(inputTile); 

%option 2. Using brute force and not very accurate
% inputTile2.color1 = inputTile.optode_a;
% inputTile2.color2 = inputTile.optode_b;
% inputTile2.color3 = inputTile.optode_c;
% inputTile2.midpoint = mean([inputTile.optode_a;inputTile.optode_b;inputTile.optode_c]);
% inputTile2 = findOptodes(inputTile2);
% optodeList = {'optode_1','optode_2','optode_3','optode_4','optode_a','optode_b','optode_c'};
% axList = {'x','y','z'};
% for nOp = 1:numel(optodeList)
%     optode_id = optodeList{nOp};
%     for nAx = 1:numel(axList)
%         outputTile.(optode_id).(axList{nAx}) = inputTile2.(optode_id)(nAx);
%     end
% end