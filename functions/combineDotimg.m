clear
getDriveFolder;
filesPath = [driveFolder,'\Results\Voice_sens2\tmp'];
file1 = [filesPath,'\Kunkun_run01_001.dotimg'];
file1 = [filesPath,'\Kunkun_run01.rmap'];
file2 = [filesPath,'\Kunkun_run06.rmap'];

% dotimg1 = load(file1,'-mat');
rmap1 = load(file1,'-mat');
rmap2 = load(file2,'-mat');
% nirsTmp = load([dataPath,'\',participant,'\run01\scan.nirs'], '-mat');
% nirsTmp2 = load('D:\Raul\data\Laugh\preprocessed\Odin_run01.nirs','-mat');
srcPos1 = rmap1.SD3Dmesh.SrcPos;
srcPos2 = rmap2.SD3Dmesh.SrcPos;

dList = zeros(1,size(srcPos1,1));
for nRow = 1:size(srcPos1,1)
    dList(nRow) = pdist2(srcPos1(nRow,:),srcPos2(nRow,:));
end
% srcPos = nirsTmp.SD3D.SrcPos;
% detPos = nirsTmp.SD3D.DetPos;