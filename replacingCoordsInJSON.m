%% This script takes a layout file, replaces the coordinates of the tiles 
%and optodes. Then writes a new .json file

clear
getDriveFolder
baseJSONFile = [driveFolder,'\NIRS\Layouts\layout.json']; %original layout file
newJSONFile = [driveFolder,'\NIRS\Layouts\Kunkun_session01.json']; %new layout file

json_dataOriginal = jsondecode(fileread(baseJSONFile));
json_data = json_dataOriginal;

% tableFile = [driveFolder,'\NIRS\Shared\Kunkun_pos.csv']; %table used to replace the coordinates
tableFile = [driveFolder,'\Laugh\HD-DOT\photogrammetry\Kunkun_session01_pos.csv']; %table used to replace the coordinates
T = readtable(tableFile);
for nRow = 1:5
    json_data.landmarks(nRow).x = T.x(nRow)*10;
    json_data.landmarks(nRow).y = T.y(nRow)*10;
    json_data.landmarks(nRow).z = T.z(nRow)*10;
end

%% Adding dock number and optode id to table
for nRow = 6:size(T,1)
    ID = T.ID{nRow};
    ID = strsplit(ID,'-');
    
    %T.dock{nRow} = ID{1};
    T.dock(nRow) = str2double(ID{1}(6:end));
    T.optode{nRow} = ID{2};
end
T2 = T(6:end,:);
%% Filling out the field docks
docksPossible = unique(T2.dock);
optodeList = {'optode_1','optode_2','optode_3','optode_4','optode_a','optode_b','optode_c'};
docks = [];
for nDock = 1:numel(docksPossible)
    dock_id = ['dock_',num2str(docksPossible(nDock))];
    docks(nDock).dock_id = dock_id; %#ok<SAGROW>
    tile = getTileFromTable(T,dock_id);
    
    for nOp = 1:numel(optodeList)
        optode_id = optodeList{nOp};
        docks(nDock).optodes(nOp).optode_id = optode_id;
        docks(nDock).optodes(nOp).coordinates_2d = get2DFromLayout(dock_id,optode_id,baseJSONFile);     
        docks(nDock).optodes(nOp).coordinates_3d = tile.(optode_id);
    end
end
json_data.docks = docks; %replacing docks

% Writting the modified data to a new json file
json_string = jsonencode(json_data);
fid = fopen(newJSONFile, 'w');
fwrite(fid, json_string, 'char');
fclose(fid);
disp(['JSON file: ', newJSONFile, ' finished']);
%%
