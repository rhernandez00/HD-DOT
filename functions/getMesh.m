function [origMeshFileName,mesh] = getMesh(meshType,loadMesh)
if nargin < 2
    loadMesh = false;
end
%for a given meshType, gives back the filename of the corresponding mesh
%and the mesh file loaded in "mesh"
getDriveFolder
switch meshType
    case 'DBarney'
        origMeshFileName = [driveFolder,'\NIRS\Shared\DBarney.mshs']; %Mesh for barney
    case 'DBarney1mm'
        origMeshFileName = [driveFolder,'\NIRS\Shared\DBarney1mm.mshs']; %Mesh for barney
    case 'HAdult'
        origMeshFileName = [driveFolder,'\NIRS\DOT-HUB_toolbox-master\ExampleMeshes\AdultMNI152.mshs']; %this is the default mesh
    case 'DKunkun_orig'
        origMeshFileName = [driveFolder,'\NIRS\Shared\DKunkun.mshs']; %this is the default mesh
        %origMeshFileName = [driveFolder,'\NIRS\Shared\DKunkun2mm.mshs']; 
    case 'DKunkun2mm'
        origMeshFileName = [driveFolder,'\NIRS\Shared\DKunkun2mm.mshs']; 
    case 'DOdin'
        origMeshFileName = [driveFolder,'\NIRS\Shared\DOdin1mm.mshs']; %
    case 'DOdin2mm'
        origMeshFileName = [driveFolder,'\NIRS\Shared\DOdin2mm.mshs']; %
    case 'DOdinB'
        origMeshFileName = [driveFolder,'\NIRS\Shared\DOdinB1mm.mshs']; %
    case 'DOdinC'
        origMeshFileName = [driveFolder,'\NIRS\Shared\DOdinC1mm.mshs']; %
    case 'DRohan'
        origMeshFileName = [driveFolder,'\NIRS\Shared\DRohan1mm.mshs']; %
    case 'DKunkun'
        origMeshFileName = [driveFolder,'\NIRS\Shared\DKunkun1mm.mshs']; %
    case 'DKunkunB'
        origMeshFileName = [driveFolder,'\NIRS\Shared\DKunkun1mm.mshs']; %
    case 'DKunkunWholeHead'
        origMeshFileName = [driveFolder,'\NIRS\Shared\DKunkunWholeHead1mm.mshs'];
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