% This script is used to correct the coordinates of the mesh as it is generated far from
%the origin and the DOT-HUB toolbox expects the mesh to be centered in the
%origin.
%% 
%Step 1. Get the landmarks as expected in the DOT-HUB toolbox (two csv files will be saved)
%Step 2. Find the transformation M from LandmarksMesh.csv to SD3D.csv using
%CloudCompare. 
%Step 3. Generate csv files with the coordinates that constitute the mesh
%Step 4. Load the csv files of Step 3 and apply the transformation M to the
%csv files
%Step 5. Save the coordinates transformed. Load them back and apply them to
%the mesh

clear
getDriveFolder
participant = 'Odin';
runN = 1;

meshPath = [driveFolder,'\NIRS\Shared']; %folder where all the files are and will be saved
SD3DOut = [meshPath,'\',participant,'SD3D.csv']; %SD3D coords saved as csv
meshDOut = [meshPath,'\',participant,'LandmarksMesh.csv']; %mesh coords saved as csv

SD3DPath = [driveFolder,'\NIRS\Layouts\',participant,'_run',sprintf('%02d',runN),'_default.SD3D']; %original layout file
SD3D = load(SD3DPath,'-mat');
SD3DLandmarks = SD3D.SD3D.Landmarks;
colorList = [1,0,0;0,1,0;0,0,1;1,1,0;0,1,1].*255; %Colors added to identify the dots
combinated = [SD3DLandmarks,colorList];

csvwrite(SD3DOut,combinated);
disp([SD3DOut ' done'])
meshFilePath = getMesh(['D',participant]);
mesh = load(meshFilePath,'-mat');
meshLandmarks = mesh.landmarks;
combined2 = [meshLandmarks,colorList];
csvwrite(meshDOut,combined2);
disp([meshDOut ' done'])

%% Step 3. Getting the coordinates from the mesh and saving them into csv files

fieldsToUse = {'headVolumeMesh','scalpSurfaceMesh','gmSurfaceMesh'};

for nField = 1:numel(fieldsToUse)
    fieldName = fieldsToUse{nField};
    coordList = zeros(size(mesh.(fieldName).node,1),3);
    for ax = 1:3
        coordList(:,ax) = mesh.(fieldName).node(:,ax);
    end
    csvName = [meshPath,'\',participant,'_',fieldName,'.csv'];
    csvwrite(csvName,coordList);
    disp([csvName, ' saved']);
end
disp('done')
%% Step 4. In CloudCompare. 
%% Step 5. Load the csv's and apply the changes to the mesh

for nField = 1:numel(fieldsToUse)
    fieldName = fieldsToUse{nField};
    csvName = [meshPath,'\',participant,'_',fieldName,'_transformed.txt'];
    coordList = readtable(csvName);
    tableCols = coordList.Properties.VariableNames;
    for ax = 1:3
        colName = tableCols{ax};
        mesh.(fieldName).node(:,ax) = coordList.(colName);
    end   
    disp([csvName, ' applied']);
end

mesh.landmarks = SD3DLandmarks; %Applies the coordinates of the landmarks from the SD3D file to the mesh

save(meshFilePath,'-struct','mesh');
disp([meshFilePath, ' corrected'])
%%

