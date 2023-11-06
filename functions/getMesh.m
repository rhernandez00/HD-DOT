function [origMeshFileName,mesh] = getMesh(meshType,loadMesh)
if nargin < 2
    loadMesh = false;
end
%for a given meshType, gives back the filename of the corresponding mesh
%and the mesh file loaded in "mesh"
getDriveFolder
switch meshType
    case 'HAdult'
        origMeshFileName = [driveFolder,'\NIRS\DOT-HUB_toolbox-master\ExampleMeshes\AdultMNI152.mshs']; %this is the default mesh
    case 'DKunkun_orig'
        origMeshFileName = [driveFolder,'\NIRS\Shared\DKunkun.mshs']; %this is the default mesh
        %origMeshFileName = [driveFolder,'\NIRS\Shared\DKunkun2mm.mshs']; %this is the default mesh
    case 'DKunkun2mm'
        origMeshFileName = [driveFolder,'\NIRS\Shared\DKunkun2mm.mshs']; %this is the default mesh
    case 'DOdin'
        origMeshFileName = [driveFolder,'\NIRS\Shared\DOdin1mm.mshs']; %this is the default mesh
    case 'DOdinB'
        origMeshFileName = [driveFolder,'\NIRS\Shared\DOdinB1mm.mshs']; %
    case 'DRohan'
        origMeshFileName = [driveFolder,'\NIRS\Shared\DRohan1mm.mshs']; %this is the default mesh
    case 'DKunkun'
        origMeshFileName = [driveFolder,'\NIRS\Shared\DKunkun1mm.mshs']; %this is the default mesh
    case 'DKunkunB'
        origMeshFileName = [driveFolder,'\NIRS\Shared\DKunkun1mm.mshs']; %this is the default mesh
    case 'DKunkunWholeHead'
        origMeshFileName = [driveFolder,'\NIRS\Shared\DKunkunWholeHead1mm.mshs']; %this is the default mesh
    otherwise
        if ~exist(meshType,'file')            
            disp(['meshType = ', meshType]);
            error('File not found or wrong meshType');
        else
            origMeshFileName = meshType;
        end     
end
if loadMesh
    mesh = load(origMeshFileName,'-mat');
end