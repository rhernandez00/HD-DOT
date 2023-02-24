% This script loads the positions of the landmarks and the sources/detectors
% from the mesh and the modified-csv files. Overwrites the positions
% in the .nirs and .SD3D files
%Author: Raul
%19/Feb/2023

clear
getDriveFolder
participant = 'Odin';
runN = 1;

experiment = 'Laugh';
dataPath = 'D:\Raul\data';
% workingFolder = [driveFolder,'\',experiment,'\HD-DOT\workingFolder'];
workingFolder = [dataPath,'\',experiment,'\preprocessed'];
% SD3DPath = [dataPath,'\',experiment,'\preprocessed\',participant,...
%     '_run',sprintf('%02d',runN),'_default.SD3D']; %original layout file
% SD3DPathBackup = [dataPath,'\',experiment,'\preprocessed\',participant,...
%     '_run',sprintf('%02d',runN),'_orig.SD3D']; %original layout file
% nirsFilePath = [dataPath,'\',experiment,'\preprocessed\',participant,...
%     '_run',sprintf('%02d',runN),'.nirs']; %original nirs file

basePath = [workingFolder,'\',participant,...
    '_run',sprintf('%02d',runN)];

SD3D = load([basePath,'_orig.SD3D'],'-mat'); %loads the original SD3D file
SD3D = SD3D.SD3D;

nirs = load([basePath,'.nirs'],'-mat'); %loads the .nirs file

[~,mesh] = getMesh(['D',participant],true); %loads the mesh to get the landmarks
SD3D.Landmarks = mesh.landmarks; %changes the landmarks in the SD3D file

alignedPos = readtable([basePath,'_SD3Dpos_aligned.txt']); %reads the aligned source/detector positions
tableCols = alignedPos.Properties.VariableNames;

%loads the original sources and detectors table
positionsTable = getSourcesAndDetectorsPos([basePath,'_orig.SD3D']); 
alignedPos.ID = positionsTable.ID; %uses the first column to know which row corresponds to which det/src

for nRow = 1:size(alignedPos,1) %This loop assigns each det/src position from the csv to SD3D .DetPos and .SrcPos
    ID = alignedPos.ID{nRow};
    posType = ID(1:3);    
    for ax = 1:3
        colName = tableCols{ax};
        SD3D.([ID(1:3),'Pos'])(str2double(ID(4:5)),ax) = alignedPos.(colName)(nRow);
    end 
end

nirs.SD3D = SD3D;

save([basePath,'.nirs'],'-struct','nirs'); %overwrites the .nirs file with a version with the real landmarks and src/det positions
disp([basePath,'.nirs', ' saved with corrected landmarks']);
SD3Dtmp = SD3D;
SD3D = [];
SD3D.SD3D = SD3Dtmp;
save([basePath,'_default.SD3D'],'-struct','SD3D'); 
disp([basePath,'_default.SD3D', ' saved with corrected landmarks']);

