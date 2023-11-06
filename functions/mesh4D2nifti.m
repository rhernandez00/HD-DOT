function mesh4D2nifti(inputFile,folder,specie,volumes,rmapFileName,minVal,maxVal,initialZ,finalZ)
%Loads a dotimg 4D file and transforms it to nifti

voxSize = 1;
% rmap = load(origMeshFileName,'-mat'); %loads the atlas mesh
[~,rmap] = getMesh(rmapFileName,true);
disp(['Loading: ', folder,'\',inputFile,'.dotimg ...']);
dotimg = load([folder,'\',inputFile,'.dotimg'], '-mat');
dotimg.hbo = rmfield(dotimg.hbo,'gm');
dotimg.hbr = rmfield(dotimg.hbr,'gm');
dotimg = rmfield(dotimg,'logData');
dotimg = rmfield(dotimg,'mua');
dotimg = rmfield(dotimg,'tImg');
imgTypes = {'hbo','hbr'};
disp('Finished loading');
% volumes = dotimg.volumes;
% volumes = 1:size(dotimg.hbo.vol,1);
% valRange = 60;
if min(dotimg.(imgTypes{1}).vol(:)) < minVal
    warning(['Adjust minimum. Current minimum is ', num2str(minVal),' the file has: ', num2str(min(dotimg.(imgTypes{1}).vol(:)))]);
end
if max(dotimg.(imgTypes{1}).vol(:)) > maxVal
    warning(['Adjust maximum. Current maximum is ', num2str(maxVal),', the file has: ', num2str(max(dotimg.(imgTypes{1}).vol(:)))]);
end
if length(imgTypes) > 1
    if min(dotimg.(imgTypes{2}).vol(:)) < minVal
        warning(['Adjust minimum. Current minimum is ', num2str(minVal),', the file has: ', num2str(min(dotimg.(imgTypes{2}).vol(:)))]);
    end
    if max(dotimg.(imgTypes{2}).vol(:)) > maxVal
        warning(['Adjust maximum. Current maximum is ', num2str(maxVal),', the file has: ', num2str(max(dotimg.(imgTypes{2}).vol(:)))]);
    end
end


crange = [minVal,maxVal]; %this should be adjusted if the error was triggered
for nType = 1:numel(imgTypes)
    imgType = imgTypes{nType};
    for nVolume = 1:numel(volumes)
        volumeN = volumes(nVolume);
        if volumeN == 0
            disp(['Non-used volume, skipping...']);
            continue
        end
        folderOut = folder;
        outputFile = [folderOut,'\',inputFile,'_',sprintf('%05d',volumeN),imgType,'.nii'];
        if exist([outputFile,'.gz'],'file')
            disp([outputFile, 'exist, skipping'])
        else
            disp([outputFile, ' doesnt exist, creating empty file and filling it...'])
            fclose(fopen([outputFile,'.gz'],'w')); %creates an empty file
            imageM = dotimg.(imgType).vol(nVolume,:);
            s = getNiiDims(rmap,voxSize); 
            mesh2nifti(outputFile,rmap,imageM,voxSize,crange,s,specie,initialZ,finalZ);
        end
    end
end

