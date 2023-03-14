function [nirs,SD3DFileName] = lufr2nirs(lufrFileName,nirsFileName,layoutFileName,posCSVFileName)
% Transforms a lufr file into a nirs file. Almost all of the code is a combination
% of the function lumoConversionFunction writen by Liam Collins-Jones, UCL.
% And the DOTHUB toolbox. It also uses functions from uses the Lumomat toolbox on Github

%Writes the nirs file with most of the data
[enum,data,events] = lumofile.read_lufr(lufrFileName,'layout',layoutFileName);
lumofile.write_NIRS(nirsFileName,enum,data,events);

%Loads the nirs file and adds the SD3D field using the positions from the
%positions csv file
nirs = load(nirsFileName,'-mat');
layoutData = jsondecode(fileread(layoutFileName));
[SD_POL, SD3DFileName] = DOTHUB_LUMOpolhemus2SD3D(posCSVFileName,0); %This line saves the .SD3D
nodes = enum.groups.nodes;
nNodes = length(nodes);
nDocks = size(layoutData.docks,1);
SD = nirs.SD;
SD_POL.MeasListAct = SD.MeasListAct;

if nNodes<nDocks %Crop SD file accordingly if the number of docks populated in the datafile differs from the number in the SD_3D data
    SD3D = SD; %Define based on SD which contains correct measlist
    for n = 1:nNodes
        nid = nodes(n);
        for det = 1:4
            SD3D.DetPos(det+(n-1)*4,:) = SD_POL.DetPos(det+(nid-1)*4,:);
        end
        for src = 1:3
            SD3D.SrcPos(src+(n-1)*3,:) = SD_POL.SrcPos(src+(nid-1)*3,:);
        end
    end
    SD3D.Landmarks = SD_POL.Landmarks;
else
    SD3D = SD_POL;
end

nirs.SD3D = SD3D;

save(nirsFileName,'-struct','nirs','-v7.3');