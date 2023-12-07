function [origMeshFileName,mesh] = getMesh(meshType,meshFolder,loadMesh)
if nargin < 3
    loadMesh = false;
end
%for a given meshType, gives back the filename of the corresponding mesh
%and the mesh file loaded in "mesh"
switch meshType
    case 'DBarney'
        origMeshFileName = [meshFolder,'\DBarney.mshs']; %Mesh for barney
    case 'HAdult'
        origMeshFileName = [meshFolder,'\AdultMNI152.mshs']; %this is the default mesh
    case 'DKunkun_orig'
        origMeshFileName = [meshFolder, '\DKunkun.mshs']; %this is the default mesh
    case 'DKunkun2mm'
        origMeshFileName = [meshFolder, '\DKunkun2mm.mshs']; 
    case 'DOdin'
        origMeshFileName = [meshFolder, '\DOdin1mm.mshs']; %
    case 'DOdin2mm'
        origMeshFileName = [meshFolder, '\DOdin2mm.mshs']; %
    case 'DOdinB'
        origMeshFileName = [meshFolder, '\DOdinB1mm.mshs']; %
    case 'DOdinC'
        origMeshFileName = [meshFolder, '\DOdinC1mm.mshs']; %
    case 'DRohan'
        origMeshFileName = [meshFolder, '\DRohan1mm.mshs']; %
    case 'DKunkun'
        origMeshFileName = [meshFolder, '\DKunkun1mm.mshs']; %
    case 'DKunkunB'
        origMeshFileName = [meshFolder, '\DKunkun1mm.mshs']; %
    case 'DKunkunWholeHead'
        origMeshFileName = [meshFolder, '\DKunkunWholeHead1mm.mshs'];
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