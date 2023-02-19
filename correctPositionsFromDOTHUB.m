% This script loads the positions of the landmarks and the sources/detectors
% from the mesh and the modified-csv files. Overwrites the positions
% in the .nirs and .SD3D files
%Author: Raul
%19/Feb/2023
%% Step 1. Output in csv the landmark coordinates from the mesh and the ones
% in the SD3D file.
% Step 2. Correct the landmarks in the SD3D file
clear
getDriveFolder
participant = 'Kunkun';
runN = 1;

experiment = 'Laugh';
dataPath = 'D:\Raul\data';
workingFolder = [driveFolder,'\',experiment,'\HD-DOT\workingFolder'];

SD3DOut = [workingFolder,'\',participant,'_run',sprintf('%02d',runN),'_SD3D.csv']; %SD3D coords saved as csv
meshDOut = [workingFolder,'\',participant,'_run',sprintf('%02d',runN),'_LandmarksMesh.csv']; %mesh coords saved as csv


% SD3DPath = [dataPath,'\',experiment,'\preprocessed\',participant,...
%     '_run',sprintf('%02d',runN),'_default.SD3D']; %original layout file
% SD3DPathBackup = [dataPath,'\',experiment,'\preprocessed\',participant,...
%     '_run',sprintf('%02d',runN),'_orig.SD3D']; %original layout file
SD3DPath = [workingFolder,'\',participant,...
    '_run',sprintf('%02d',runN),'_default.SD3D']; %original layout file
SD3DPathBackup = [workingFolder,'\',participant,...
    '_run',sprintf('%02d',runN),'_orig.SD3D']; %original layout file

SD3D = load(SD3DPath,'-mat');
movefile(SD3DPath,SD3DPathBackup);
SD3D = SD3D.SD3D;

colorList = [1,0,0;0,1,0;0,0,1;1,1,0;0,1,1].*255; %Colors added to identify the dots
SD3DOriginalLandmarks = [SD3D.Landmarks,colorList];

[~,mesh] = getMesh(['D',participant],true); %loads the mesh to get the landmarks
SD3D.Landmarks = mesh.landmarks; %changes the landmarks in the SD3D file
save(SD3DPath,'-struct','SD3D'); %overwrites the file
disp([SD3DPath, ' saved with corrected landmarks']);

%Creates two csv files one to be moved (SD3D) and one for reference (mesh)
csvwrite(SD3DOut,SD3DOriginalLandmarks); %Writes csv with original SD3D landmarks to be moved
disp([SD3DOut ' done']);

meshLandmarks = [mesh.landmarks,colorList];
csvwrite(meshDOut,meshLandmarks); %writes reference csv
disp([meshDOut ' done']);


%% Step 3. Load the coordinates from the sources and detectors in the .nirs and the SD3D file


% SD3DPath = [dataPath,'\',experiment,'\preprocessed\',participant,...
%     '_run',sprintf('%02d',runN),'_default.SD3D']; %original layout file
T = getSourcesAndDetectorsPos(SD3DPath);

%%

clear
getDriveFolder;
participant = 'Odin';
nContrast = 2;
contrastsPossible = {'Sound','Laugh'};

contrastName = contrastsPossible{nContrast};

%Loading a prepro to replicate its structure
filesPath = 'G:\My Drive\Laugh\HD-DOT\tmp';
filesPath = 'D:\Raul\data\Laugh\preprocessed';
%preproFileName = [filesPath,'\',participant,'_run01.prepro'];
preproFileName = [filesPath,'\',participant,'_run01.prepro'];
preproFolder = [driveFolder,'\Laugh\HD-DOT\nirsFiles'];
preproOut = [filesPath,'\',participant,'_',contrastName,'.prepro'];
prepro = load(preproFileName,'-mat');

%Initializes resTable. Which will contain tstats for each
%source*dectector*lambda possible
variableNames = {'source','detector','lambda','tstat'};
variableTypes = {'uint16','uint16','uint16','double'};
resTable = table('Size',[size(prepro.SD3D.MeasList,1),numel(variableNames)],'VariableNames',...
    variableNames,'VariableTypes',variableTypes);
resTable.source(:) = prepro.SD3D.MeasList(:,1);
resTable.detector(:) = prepro.SD3D.MeasList(:,2);
resTable.lambda(:) = prepro.SD3D.Lambda(prepro.SD3D.MeasList(:,4));

%Loads data from the fixEffect GLM and saves it in resTable
dataPath = [driveFolder,'\Laugh\HD-DOT\nirsFiles'];
switch contrastName
    case 'Sound'
        if strcmp(participant,'Rohan')
            fixEffectRes = load([dataPath,'\tstatsRohan.mat'],'tstats','link');
        else
            fixEffectRes = load([dataPath,'\tstats.mat'],'tstats','link');
        end
    case 'Laugh'
        if strcmp(participant,'Rohan')
            fixEffectRes = load([dataPath,'\tstats_Laugh-ShuffledRohan.mat'],'tstats','link');
        else
            fixEffectRes = load([dataPath,'\tstats_Laugh-Shuffled.mat'],'tstats','link');
        end
end

if isfield(fixEffectRes,'link') %checks if link is in the file
    link = fixEffectRes.link; %link is in the file, use it
else %link is not in the file, use one from another file
    link = load([dataPath,'\tstats.mat'],'link');
    link = link.link;
end
tstats = fixEffectRes.tstats;

for nRow = 1:size(resTable,1)
    source = resTable.source(nRow);
    detector = resTable.detector(nRow);
    lambda = resTable.lambda(nRow);
    indx = find((link.source == source).*(link.detector == detector).*(link.type == lambda));
    if numel(indx) ~= 1
        error(['Wrong number of rows in link, expected 1, found ',num2str(numel(indx))]);
    end
    resTable.tstat(nRow) = tstats.(participant)(indx);
end

prepro.tDOD = prepro.tDOD(1);
prepro.dod = resTable.tstat';
% prepro
prepro.fileName = preproOut;

save(preproOut,'-struct','prepro');
disp([preproOut, ' done']);