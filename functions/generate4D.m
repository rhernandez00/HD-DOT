function generate4D(experiment,participant,runN,imgType,varargin)
dataFolder = getArgumentValue('dataFolder','D:\Raul\data',varargin{:});
volumes = getArgumentValue('volumes',[],varargin{:}); %Overwrite volumes to process for step 11

preproFolder =[dataFolder,'\',experiment,'\preprocessed']; 
filesFolder = [preproFolder,'\',participant,...
    '_run',sprintf('%02d',runN)];
T = readtable([preproFolder,'\',participant,...
    '_run',sprintf('%02d',runN),'.xlsx']);

fileList = cell(T.volumeF(end),1);
minList = zeros(T.volumeF(end),1);
maxList = zeros(T.volumeF(end),1);
for nRow = 1:size(T,1)
    for nVol = T.volumeI(nRow):T.volumeF(nRow)
        fileList{nVol} = [filesFolder,'\',T.fileName{nRow},'_',sprintf('%05d',nVol),imgType,'.nii.gz'];
        minList(nVol) = T.minVal(nRow);
        maxList(nVol) = T.maxVal(nRow);
    end
end

output4D = [preproFolder,'\',participant,'_run',sprintf('%02d',runN),'_',imgType,'.nii.gz'];

% Load the nifti file
mapNii = load_nii(fileList{i});


if ~isempty(volumes)
    disp(['4D will contain volumes from: ', num2str(volumes(1)), ' to ',num2str(volumes(end))])
    fileList = fileList(volumes);
end

% Initialize the 4D matrix to hold the loaded and cropped nifti files
numFiles = length(fileList);
nifti4D = zeros(size(mapNii.img,1),size(mapNii.img,2),size(mapNii.img,3),numFiles);


% Loop through the fileList and load, crop, and save each nifti file
for i = 1:numFiles
    % Load the nifti file
    nii = load_nii(fileList{i});
    
    %remaps from pixel values to hemoglobin concentration
    minValue = min(nii.img(:));
    maxValue = max(nii.img(:));    
    nii.img = (nii.img - minValue) * ((maxList(i) - minList(i)) / (maxValue - minValue)) + minList(i);
    
    % Save nifti file to the 4D matrix
    nifti4D(:,:,:,i) = nii.img;
end

% Create a new nifti struct for the 4D nifti
nii4D = make_nii(nifti4D);

% Save the 4D nifti
save_nii(nii4D, output4D);
disp([output4D,' saved']);

