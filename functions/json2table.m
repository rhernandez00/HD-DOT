function T = json2table(jsonFile,tableOut)
%Loads the 2D coordinates of a layout json file and writes a xlsx with the
%coordinates in a table format. If no file name for the output table is introduced
%it will use the same path as the jsonFile

if nargin < 2 %if no filename for the table output is suministred, it will use the same as the json file
    tableOut = [jsonFile,'.xlsx'];
end
json_data = jsondecode(fileread([jsonFile,'.JSON']));

%Initializing the output table
colNames = {'dockID','optodeID','x','y','elementType','elementID'};
varTypes = {'string','string','double','double','string','uint8'};
totalRows = numel(json_data.docks)*numel(json_data.docks(1).optodes);
T = table('size',[totalRows,numel(colNames)],'VariableNames',colNames,'VariableTypes',varTypes);

nRow = 1;
for nDock = 1:numel(json_data.docks)
    dock_id = json_data.docks(nDock).dock_id;
    for nOptode = 1:numel(json_data.docks(nDock).optodes)
        optode_id = json_data.docks(nDock).optodes(nOptode).optode_id;
        T.dockID{nRow} = dock_id;
        T.optodeID{nRow} = optode_id;
        T.x(nRow) = json_data.docks(nDock).optodes(nOptode).coordinates_2d.x;
        T.y(nRow) = json_data.docks(nDock).optodes(nOptode).coordinates_2d.y;
        nRow = nRow + 1;
    end
end

srcNum = 1; detNum = 1;
srcTypes = ["optode_a","optode_b","optode_c"];
detTypes = ["optode_1","optode_2","optode_3","optode_4"];
for nRow = 1:size(T,1)
    if ismember(T.optodeID(nRow),srcTypes)
        elementType = 'src';
        T.elementID(nRow) = srcNum;
        srcNum = srcNum + 1;
    elseif ismember(T.optodeID(nRow),detTypes)
        elementType = 'det';
        T.elementID(nRow) = detNum;
        detNum = detNum + 1;
    else
        T.optodeID(nRow)
        error('Neither src or det');
    end
    T.elementType(nRow) = elementType;
end


writetable(T,tableOut)
disp([tableOut, ' written']);

