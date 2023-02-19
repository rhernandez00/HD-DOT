function T = getSourcesAndDetectorsPos(fileToRead)
%Reads the positions of sources and detectors from a given file (fileToRead). 
%Returns a table with ID, x, y and z.
[~,~,ext] = fileparts(fileToRead);
switch ext
    case '.SD3D'
        SD3D = load(fileToRead,'-mat');
    otherwise
        error(['Extension not found: ',ext,' . write the case']);
end

variableNames = {'ID','x','y','z'};
variableTypes = {'string','double','double','double'};

TSrc = table('Size',[SD3D.nSrcs,numel(variableNames)],'VariableNames',...
    variableNames,'VariableTypes',variableTypes);
for nSrc = 1:SD3D.nSrcs
    TSrc.ID(nSrc) = ['Src',sprintf('%02d',nSrc)];
    TSrc.x(nSrc) = SD3D.SrcPos(nSrc,1);
    TSrc.y(nSrc) = SD3D.SrcPos(nSrc,2);
    TSrc.z(nSrc) = SD3D.SrcPos(nSrc,3);
end

TDet = table('Size',[SD3D.nDets,numel(variableNames)],'VariableNames',...
    variableNames,'VariableTypes',variableTypes);
for nDet = 1:SD3D.nDets
    TDet.ID(nDet) = ['Det',sprintf('%02d',nDet)];
    TDet.x(nDet) = SD3D.DetPos(nDet,1);
    TDet.y(nDet) = SD3D.DetPos(nDet,2);
    TDet.z(nDet) = SD3D.DetPos(nDet,3);
end

T = [TSrc;TDet];

