function preprocessRun(experiment,participant,runN,stepsToRun,specie,sessionNumber,meshFolder,varargin)
% stepsToRun - vector of steps to run (vector with number from 1 to 7)

dataFolder = getArgumentValue('dataFolder','D:\Raul\data',varargin{:});
toolboxFolder = getArgumentValue('toolboxFolder',['G:\My Drive','\NIRS\DOT-HUB_toolbox-master'],varargin{:});
endTime = getArgumentValue('endTime',[],varargin{:}); %moment where the acquisition ends after the s
lumoDir = [dataFolder,'\',experiment,'\raw\',participant,'_run',sprintf('%02d',runN),'.LUMO'];
meshType = getArgumentValue('meshType','HAdult',varargin{:}); %also takes DKunkun
filesToProcess = getArgumentValue('filesToProcess',[],varargin{:}); %which files from the slices to process. Default, all
newFs = getArgumentValue('newFs',[],varargin{:}); %resample nirs file? default no.
layoutPath = getArgumentValue('layoutPath',[dataFolder,'\',experiment,'\layouts\'],varargin{:});
runFull4D = getArgumentValue('runFull4D',true,varargin{:}); %true - saves every voxel in the 4D (slower), false - skips non-brain tissue (faster, requires 10- rmap2nii)
volumes = getArgumentValue('volumes',[],varargin{:}); %Overwrite volumes to process for step 11
posFile = getArgumentValue('posFile','both',varargin{:});

if isempty(meshFolder)
    error('You should provide the path to the meshFolder, it is the argument after sessionNumber');
end

%initilize preprocessing steps to run
runConvertLUMO = false; %1. run LUMO2nirs?
runCutNIRS = false; %2. cut nirs according to s and e (or endTime)?
runResample = false; %2.5 run resample? If yes, newFs must be provided
runPreprocess = false; %3. run preprocess nirs (and output .prepro)?
runMeshRegistration = false; %4. run mesh registration?
runJacobian = false; %5. run calculate Jacobian?
runInvertJacobian = false; %6. run invert Jacobian?
runSlice = false; %7. slices the prepro file so the reconstruction fits in the RAM
runReconstruction = false; %8. run reconstruction?
runMesh2nii = false; %9. run mesh2nii
run4D = false; %10. create 4D file from independent-volume nifti?

for nStep = 1:numel(stepsToRun) %check which steps are required
    step = stepsToRun(nStep);
    switch step
        case 1
            runConvertLUMO = true; %run LUMO2nirs?
        case 2 
            runCutNIRS = true; %cut nirs according to s and e (or endTime)?
        case 2.5
            runResample = true;
        case 3
            runPreprocess = true; %run preprocess nirs (and output .prepro)?
        case 4
            runMeshRegistration = true; %run mesh registration?
        case 5
            runJacobian = true; %run calculate Jacobian?
        case 6
            runInvertJacobian = true; %run invert Jacobian?
        case 7
            runSlice = true;
        case 8
            runReconstruction = true; %run reconstruction?
        case 9
            runMesh2nii = true;
        case 10
            run4D = true;
        otherwise
            error('The only steps possible are 1:7')
    end
end

preproFolder = [dataFolder,'\',experiment,'\preprocessed'];
if ~exist(preproFolder,'dir')
    disp([preproFolder, ' not found, creating']);
    mkdir(preproFolder);
end
baseName = [preproFolder,'\',participant,'_run',sprintf('%02d',runN)];
nirsFileName = [baseName,'.nirs'];

origMeshFileName = getMesh(meshType,meshFolder); %gets filename of mesh according to the meshType requested

addpath(genpath(toolboxFolder)); %adds all the subfolders of the toolbox

if runConvertLUMO
    %These correct the spacing in the output files from lumo.
    layoutFileName = [layoutPath,'\',participant,'_session',sprintf('%02d',sessionNumber),'.json'];
    posCSVFileName = [layoutPath,'\',participant,'_session',sprintf('%02d',sessionNumber),'_pos.csv'];
    disp(['Using file: ', posCSVFileName]);
    disp(['Using file: ', layoutFileName]);
    if exist(lumoDir,'dir')
        LUMOType = 'LUMO';
    else
        LUMOType = 'lufr';
    end
    switch LUMOType
        case 'LUMO'
            %corrects details on the .LUMO folder
            correctEvents(lumoDir); 
            correctHardware(lumoDir);
            correctRecordingData(lumoDir);
            correctMetadata(lumoDir);
            %makes the conversion
            switch posFile
                case 'both'
                    [nirs, nirsFileName2, SD3DFileName] = DOTHUB_LUMO2nirs(lumoDir,layoutFileName,posCSVFileName);%converts .LUMO to nirs file
                case 'csv'
                    disp('running csv')
                    [nirs, nirsFileName2, SD3DFileName] = DOTHUB_LUMO2nirs(lumoDir,[],posCSVFileName);%converts .LUMO to nirs file
                case 'json'
                    [nirs, nirsFileName2, SD3DFileName] = DOTHUB_LUMO2nirs(lumoDir,layoutFileName,[]);%converts .LUMO to nirs file
                otherwise
                    error("No posFile selected. Possibles are 'both', 'csv' or 'json'");
            end
            movefile(nirsFileName2,nirsFileName);
            
        case 'lufr'
            %This part was taken from the function lumoConversionFunction
            %writen by Liam Collins-Jones, UCL. It uses the Lumomat toolbox on Github
            lufrFileName = [dataFolder,'\',experiment,'\raw\',participant,'_run',sprintf('%02d',runN),'.lufr'];
            switch posFile
                case 'both'
                    [nirs,SD3DFileName] = lufr2nirs(lufrFileName,nirsFileName,layoutFileName,posCSVFileName);
                case 'csv'
                    [nirs,SD3DFileName] = lufr2nirs(lufrFileName,nirsFileName,[],posCSVFileName);
            end
            
    end
    
    movefile(SD3DFileName,[baseName,'_default.SD3D']);
end
%% cutting and resampling nirs file using recorded s and e (or endTime)
if runCutNIRS
    cutNIRS(nirsFileName,endTime); %cuts the nirs file using the events 's' (start) and 'e' (end) and saves it
end

if runResample
    if ~isempty(newFs) %only resamples if a new frequency is provided
        resampleNIRS(nirsFileName,newFs);
    else
        error('Resample requested but no new frequency provided. Add optional parameter newFs or turn off resample')
    end
end
%% Preprocessing:

preproFileName = [baseName,'.prepro'];
if runPreprocess
    nirs = load(nirsFileName,'-mat');
    dod = double(hmrIntensity2OD(nirs.d)); %Converts raw data to optical density. 
    SD3D = enPruneChannels(nirs.d,nirs.SD3D,ones(size(nirs.t)),[0 1e11],12,[0 100],0); %prunes noisy channels
    %Force MeasListAct to be the same across wavelengths
    nWavs = length(SD3D.Lambda);
    tmp = reshape(SD3D.MeasListAct,length(SD3D.MeasListAct)/nWavs,nWavs);
    tmp2 = ~any(tmp'==0)';
    SD3D.MeasListAct = repmat(tmp2,nWavs,1);
    SD2D = nirs.SD; 
    SD2D.MeasListAct = SD3D.MeasListAct;
    dod = hmrBandpassFilt(dod,nirs.t',0,0.5); %Bandpass filter
    dc = hmrOD2Conc(dod,SD3D,[6 6]); %convert optical density to
    %hemoglobin concentration
    %Creating prepro file
    DOTHUB_writePREPRO(preproFileName,[],dc,nirs.t,SD3D);
end

%% Registering chosen mesh to subject SD3D and creating rmap

if runMeshRegistration
    DOTHUB_meshRegistration(nirsFileName,origMeshFileName);
end

%% Calculate Jacobian. 
% This step takes from 25 to 45 minutes. It is necessary for each cap repositioning. 
% However, this script assumes that the entire experiment was run in a
% single session, so the Jacobian is only run once and used for all tasks
%jacFileName = [preproFolder,'\',participant,'.jac'];
jacFileName = [baseName,'.jac'];
rmapFileName = [baseName,'.rmap'];
% jacFileName = [participant,'_run',sprintf('%02d',runN)];

if runJacobian
    if exist(jacFileName,'file') %checks if the file was already created
        disp([jacFileName, ' exist, this will be used...']);
    else %if the file doesn't exist, it calculates the Jacobian
        disp([jacFileName, ' doesnt exist, creating one...']);
        basis = [30 30 30];
        tic
        DOTHUB_makeToastJacobian(rmapFileName,basis);
        disp('Jacobian is done! It only costed you: ');
        disp([num2str(toc), ' seconds']);
    end
end
%% 7. Invert Jacobian

invjacFileName = [baseName,'.invjac'];
if runInvertJacobian
    DOTHUB_invertJacobian(jacFileName,preproFileName,'saveFlag',true,'reconMethod','multispectral','hyperParameter',0.01);
end
%% 7. Slicing prepro so RAM can make the conversion
if runSlice
    fileName = [participant,'_run',sprintf('%02d',runN)];
    slicePrepro(preproFolder,fileName,true);
end
%% 8. Reconstruction
rmapFileName = [baseName,'.rmap'];

if runReconstruction
    rmap = load(rmapFileName,'-mat'); %loads rmap
    GMNum = find(strcmp(rmap.headVolumeMesh.labels,'GM')); %#ok<EFIND> %finds the GM number
    if isempty(GMNum)
        disp('Labels available:');
        disp(rmap.headVolumeMesh.labels);
        error('Couldnt find GM label');
    end
    GMIndx = rmap.headVolumeMesh.node(:,4) == GMNum;
    
    fileName = [participant,'_run',sprintf('%02d',runN)];
    dataTable = readtable([preproFolder,'\',fileName,'.xlsx']);
  
    for nFile = 1:size(dataTable,1)
        if isempty(dataTable.fileName{nFile}) %the table is empty, skipping file
            disp('the table is empty, skipping file')
            continue
        else
            preproFileName = [preproFolder,'\',fileName,'\',dataTable.fileName{nFile},'.prepro'];
            dotimgFileName = [preproFolder,'\',fileName,'\',dataTable.fileName{nFile},'.dotimg'];
            disp(preproFileName)
            disp(rmapFileName)
            if exist(dotimgFileName,'file')
                disp(['File: ', dotimgFileName, ' exist, skipping']);

            else
                fclose(fopen([dotimgFileName],'w')); %creates an empty file
                disp(['File: ', dotimgFileName, ' doesnt exist creating temporal file']);
                dotimg = DOTHUB_reconstruction(preproFileName,[],invjacFileName,rmapFileName,'saveVolumeImages',true);
                disp(['dotimg saved to: ',dotimgFileName]);
                
                minVal1 = min(dotimg.hbo.vol(:,:));
                minVal2 = min(dotimg.hbo.vol(:,:));
                maxVal1 = max(dotimg.hbr.vol(:,:));
                maxVal2 = max(dotimg.hbr.vol(:,:));
            
                minVal = min([minVal1,minVal2]);
                maxVal = max([maxVal1,maxVal2]);
                dataTable.minVal(nFile) = minVal;
                dataTable.maxVal(nFile) = maxVal;
                writetable(dataTable,[preproFolder,'\',fileName,'.xlsx']);
            end
        end
        
    end
end

%% 9. Mesh to nii

if runMesh2nii
    
    
    fileName = [participant,'_run',sprintf('%02d',runN)];
    outputFolder = [dataFolder,'\',experiment,'\preprocessed\',fileName];
    dataTable = readtable([preproFolder,'\',fileName,'.xlsx']);
    minVal = min(dataTable.minVal);
    maxVal = max(dataTable.maxVal);
    
    if mean(dataTable.minVal == minVal) ~= 1 || mean(dataTable.maxVal == maxVal) ~= 1
        dataTable.minVal = minVal.*ones(numel(dataTable.minVal),1);
        dataTable.maxVal = maxVal.*ones(numel(dataTable.minVal),1);
        writetable(dataTable,[preproFolder,'\',fileName,'.xlsx']);
        disp('dataTable updated')
    end
    if isempty(filesToProcess)
        filesToProcess = 1:size(dataTable,1);
    end
    
    for n = 1:numel(filesToProcess)
        nFile = filesToProcess(n);
        inputFile = dataTable.fileName{nFile};
        if isempty(inputFile)
            continue
        end
        volumesInFile = dataTable.volumeI(nFile):dataTable.volumeF(nFile);
        if isempty(volumes)
            volumesToUse = volumesInFile;
        else
            volumesToUse = volumesInFile.*ismember(volumesInFile,volumes);
        end
        minVal = dataTable.minVal(nFile); %gets the minimum and maximum to create the plot
        maxVal = dataTable.maxVal(nFile);
        if runFull4D
            mesh4D2nifti(inputFile,outputFolder,specie,volumesToUse,rmapFileName,minVal,maxVal,[],[],meshFolder);
        else
            
            rmapNiiPath = [preproFolder,'\',participant,'_run',sprintf('%02d',runN),'_rmap.nii.gz'];
            [initialZ,finalZ] = determineRange(rmapNiiPath);
            mesh4D2nifti(inputFile,outputFolder,specie,volumesToUse,rmapFileName,minVal,maxVal,initialZ,finalZ,meshFolder);
        end
        
        
    end
end


%% 10. single volume nifti to 4D
if run4D
    imgTypes = {'hbo','hbr'};
    for nType = 1:numel(imgTypes)
        imgType = imgTypes{nType};
        generate4D(experiment,participant,runN,imgType,'dataFolder',dataFolder,'volumes',volumes);
    end
end