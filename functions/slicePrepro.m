function [preproFileList,dotImgFileList] = slicePrepro(folder,fileName,saveFiles,maxTimePoints)
%takes a prepro file, slices it in new prepro files with a maximum of time
%points defined by maxTimePoints. Saves the new prepro files using the same
%folder and fileName but adding a number at the end _001, _002
%outputs preproFileList and dotImgFileList, cells with the filenames of the
%prepro files created and the filenames of the dotImg files to be created
%in the next step
%if saveFiles is false the function only outputs the file lists

%Adding the toolbox and other functions
%getDriveFolder
%toolboxFolder = [driveFolder,'\NIRS\DOT-HUB_toolbox-master'];
%addpath(genpath(toolboxFolder)); %adds all the subfolders of the toolbox
%functionsPath = [driveFolder,'\GemmaLab\functions']; %path to the functions I sent you
%addpath(functionsPath);

%folder = 'G:\My Drive\Complex\tmp';
%fileName = 'Kunkun_run01';

prepro = load([folder,'\', fileName,'.prepro'], '-mat');
if nargin < 4
    maxTimePoints = 20;
end
minVal = min(prepro.dod(:));
maxVal = max(prepro.dod(:));

dataTable = table('Size',[ceil(numel(prepro.tDOD)/maxTimePoints),5],...
    'VariableNames',{'fileName','volumeI','volumeF','minVal','maxVal'},...
    'VariableTypes',{'string','uint64','uint64','double','double'});

initial = 1;
nFile = 1;
while initial < numel(prepro.tDOD)
    final = initial + maxTimePoints-1;
    if final > numel(prepro.tDOD)
        final = numel(prepro.tDOD);
    end
    
    subFile = [fileName,'_',sprintf('%03d',nFile)];
    if ~exist([folder,'\',fileName],'dir')
        mkdir([folder,'\',fileName]);
    end
    subPreproFile = [folder,'\',fileName,'\',subFile,'.prepro'];
    
    disp(['slicing from timepoint: ', num2str(initial), ' to ',num2str(final)]);
    preproSlice.SD3D = prepro.SD3D;
    preproSlice.dod = prepro.dod(initial:final,:);
    preproSlice.tDOD = prepro.tDOD(initial:final);
    preproSlice.logData = prepro.logData;
    preproSlice.fileName = subPreproFile;
    
    dataTable.fileName(nFile) = subFile;
    dataTable.volumeI(nFile) = initial;
    dataTable.volumeF(nFile) = final;
    dataTable.minVal(nFile) = minVal;
    dataTable.maxVal(nFile) = maxVal;
    

    if saveFiles
        save(subPreproFile,'-struct','preproSlice','-v7.3');
        disp(['file ',subPreproFile, ' saved']);
    end
    initial = final + 1;
    nFile = nFile + 1;
end
disp('Slicing done');
tableName = [folder,'\',fileName,'.xlsx'];
writetable(dataTable,tableName);
disp([tableName, ' done'])


% if correctRange
%     preproFileName = [folder,'\', fileName,'.prepro'];
%     [dotimg, dotimgFileName] = DOTHUB_reconstruction(preproFileName,[],invjacFileName,rmapFileName,'saveVolumeImages',true);
%     
% end