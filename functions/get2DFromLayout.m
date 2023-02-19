function coordinates_2d = get2DFromLayout(dock_id,optode_id,baseJSONFile)
%extracts coordinates_2d from a layout (JSON) file
%dock_id : id of the dock as string ('dock_1')
%optide_id : id of the optode as string ('optode_c')
if nargin < 3 %if no layout path is given, takes a default one
    getDriveFolder;
    baseJSONFile = [driveFolder,'\NIRS\Layouts\layout.json'];
end

json_data = jsondecode(fileread(baseJSONFile));
indx = find(strcmp({json_data.docks.dock_id},dock_id)); %finds the dock_id
indx2 = find(strcmp({json_data.docks(indx).optodes.optode_id},optode_id)); %finds the optode_id
coordinates_2d = json_data.docks(indx).optodes(indx2).coordinates_2d;





