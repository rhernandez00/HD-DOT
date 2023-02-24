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
clear
getDriveFolder
participant = 'Odin';
specie = 'D';
runN = 1;
experiment = 'Laugh';
dataPath = 'D:\Raul\data';
dataPath = 'G:\My Drive\Laugh\HD-DOT\workingFolder';
[origMeshFileName] = getMesh([specie,participant]);
SD3DFileName = [dataPath,'\',experiment,'\preprocessed\',participant,'_run',sprintf('%02d',runN),'_default.SD3D'];
[rmap, rmapFileName] = DOTHUB_meshRegistration(SD3DFileName,origMeshFileName);


%%
markerSize = 60;
% [~,mesh] = getMesh([specie,participant],true);
mesh = rmap;

templateMesh = mesh.headVolumeMesh;
% plotmesh(templateMesh.node,templateMesh.face,'FaceColor',[0 0.85 0.75],'EdgeColor',[0.3 0.3 0.3]);

SD3D = load(SD3DFileName,'-mat');
SD3D = SD3D.SD3D;
% landmarksToPlot = mesh.landmarks;
landmarksToPlot = SD3D.Landmarks;
% landmarksToPlot = jsonLandmarks;
% [~,landmarks] = getMeshProps([specie,participant]);
% landmarksToPlot = landmarks.coords;

% for nSub = 1:2
%     subplot(1,2,nSub)
    clf
    
    plotmesh(templateMesh.node,templateMesh.face,'FaceColor',[0 0.85 0.75],'EdgeColor',[0.3 0.3 0.3]);
    alpha(0.1)
    hold on
    for n = 1:size(landmarksToPlot,1)

%         plot3(landmarksToPlot(n,1),landmarksToPlot(n,2),landmarksToPlot(n,3),'o','MarkerFaceColor','r')
        scatter3(landmarksToPlot(n,1),landmarksToPlot(n,2),landmarksToPlot(n,3),...
            markerSize,'MarkerEdgeColor','r','MarkerFaceColor','r')
    end
% end
srcPos = SD3D.SrcPos;
detPos = SD3D.DetPos;
%plotting sources
for n = 1:size(srcPos,1)
%     for nn = 1:2
%         subplot(1,2,nn) 
        hold on
        x = srcPos(n,1); y = srcPos(n,2); z = srcPos(n,3);
        scatter3(x,y,z,markerSize,'MarkerEdgeColor','b','MarkerFaceColor','b');
%     end
end

%plotting detectors
for n = 1:size(detPos,1)
%     for nn = 1:2
%         subplot(1,2,nn)
        hold on
        x = detPos(n,1); y = detPos(n,2); z = detPos(n,3);
        scatter3(x,y,z,markerSize,'MarkerEdgeColor','r','MarkerFaceColor','r');
%     end
end
%%

clear
getDriveFolder
% participant = 'Odin';
specie = 'D';
% runN = 1;
% experiment = 'Laugh';
% dataPath = 'D:\Raul\data';
dataPath = 'G:\My Drive\Laugh\HD-DOT\workingFolder';
[~,mesh] = getMesh([driveFolder,'\Laugh\HD-DOT\workingFolder\Kunkun.rmap'],true);
templateMesh = mesh.headVolumeMesh;
markerSize = 60;

landmarksToPlot = mesh.SD3Dmesh.Landmarks;
clf

plotmesh(templateMesh.node,templateMesh.face,'FaceColor',[0 0.85 0.75],'EdgeColor',[0.3 0.3 0.3]);
alpha(0.1)
hold on
for n = 1:size(landmarksToPlot,1)
    scatter3(landmarksToPlot(n,1),landmarksToPlot(n,2),landmarksToPlot(n,3),...
        markerSize,'MarkerEdgeColor','r','MarkerFaceColor','r')
end

srcPos = mesh.SD3Dmesh.SrcPos;
detPos = mesh.SD3Dmesh.DetPos;
%plotting sources
for n = 1:size(srcPos,1)
    hold on
    x = srcPos(n,1); y = srcPos(n,2); z = srcPos(n,3);
    scatter3(x,y,z,markerSize,'MarkerEdgeColor','b','MarkerFaceColor','b');
end

%plotting detectors
hold on
for n = 1:size(detPos,1)
    x = detPos(n,1); y = detPos(n,2); z = detPos(n,3);
    scatter3(x,y,z,markerSize,'MarkerEdgeColor','r','MarkerFaceColor','r');
end
%%

clear
getDriveFolder
participant = 'Kunkun';
specie = 'D';
% runN = 1;
% experiment = 'Laugh';`
% dataPath = 'D:\Raul\data';
dataPath = 'G:\My Drive\Laugh\HD-DOT\workingFolder';
rmapPath = [dataPath,'\',participant,'.rmap'];
rmapPathOut = [dataPath,'\',participant,'M.rmap'];
[~,rmap] = getMesh(rmapPath,true);
[~,mesh] = getMesh([specie,participant],true);

fieldsToCopy = {'headVolumeMesh','gmSurfaceMesh','scalpSurfaceMesh','vol2gm'};

for nField = 1:numel(fieldsToCopy)
    fieldName = fieldsToCopy{nField};
    rmap.(fieldName) = mesh.(fieldName);
end

save(rmapPathOut,'-struct','rmap');
disp([rmapPathOut, ' saved'])

%%


clear
getDriveFolder
participant = 'Kunkun';
specie = 'D';
% runN = 1;
% experiment = 'Laugh';`
% dataPath = 'D:\Raul\data';
dataPath = 'G:\My Drive\Laugh\HD-DOT\workingFolder';
dotimgPath = [dataPath,'\',participant,'_run01_001.dotimg'];

dotimg = load(dotimgPath, '-mat');

rmapPath = [dataPath,'\',participant,'.rmap'];
[~,rmap] = getMesh(rmapPath,true);
