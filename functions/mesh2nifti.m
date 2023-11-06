function matrix3D = mesh2nifti(outputFile,rmap,imageM,voxSize,crange,s,specie,initialZ,finalZ,varargin)
%Takes an rmap, data image (imageM), voxel size (voxSize) and a value range
%(crange). Writes a nii file with the data from imageM in the rmap space
if nargin < 6
    %s = getArgumentValue('s',[],varargin{:}); 
    %s an structure that contains the dimensions the output nii should have
    s = getNiiDims(rmap,voxSize); 
end
verbose = getArgumentValue('verbose',false,varargin{:});
tmpPatch = false;

templateMesh = rmap.headVolumeMesh; %mesh used to place the activity
% disp(['minz: ', num2str(s.minz
% s.minz
% s.maxz
% voxSize
if isempty(initialZ)
    slicesPossible = s.minz:voxSize:s.maxz; %slices used for plotting
else
    slicesPossible = initialZ:finalZ;
end

slice_dim=3; %slice to use to cut 3 - horizontal

dim_label = {'x' 'y' 'z'}; 
view_def = [90 0;180 0;0 90]; %sets the view
colormap('gray') %defines the color map
i =1;

matrix3D = zeros(s.y,s.x,s.z);%matrix where the voxel data will be saved
sliceWidth = voxSize;

for nSlice = 1:length(slicesPossible)
    if verbose
        clf
        disp(['getting slice: ',num2str(nSlice), ' / ',num2str(length(slicesPossible))]);
    end
    slice_pos = slicesPossible(nSlice);
    if tmpPatch %Around 27 Jan 2023
        warning('Patch here, should correct')
        nIndx = size(templateMesh.node,1);
        nIndx2 = numel(imageM);
        if nIndx > nIndx2
            nIndx = nIndx2;
        end
        templateMesh.node(1:nIndx,4) = imageM(1:nIndx);%asigns the values received from the data image to the map to be plot
        %finished patch
    else
        templateMesh.node(:,4) = imageM;%asigns the values received from the data image to the map to be plot
    end
    
    h.ax2 = axes;
    plotmesh(templateMesh.node,templateMesh.elem(:,1:4),[dim_label{slice_dim(i)} ' <' num2str(slice_pos(i)) '&' dim_label{slice_dim(i)} ' >' num2str(slice_pos(i)-sliceWidth)],'EdgeAlpha',0);
    %plotmesh(templateMesh.node(:,1:3),templateMesh.elem(:,1:5),[dim_label{slice_dim(i)} ' <' num2str(slice_pos(i)) ' & ' dim_label{slice_dim(i)} ' >' num2str(slice_pos(i)-sliceWidth)],'EdgeAlpha',0);
        
    h.ax2.Visible = 'off';
    h.ax2.CLim = crange;
    view(view_def(slice_dim(i),:));
    drawnow
    
    set(gcf,'Color',[0,0,0]);
    set(gcf,'position',[488.2,-660.6,442.4,444.8]);
    %testing output
    axis([s.minx,s.maxx,s.miny,s.maxy]);
   if nSlice == 18
%        error('r')
   end
    mask=getframe(gca);
    matrix = mask.cdata;
    matrix2 = imresize(matrix,[s.y,s.x],'bicubic');
    matrix2 = mean(matrix2,3); %matrix has 3 dimensions. The last one is color. So the mean transforms it to grey
    %matrix2 = flip(matrix2,1);
    if specie == 'H'
        matrix2 = flip(matrix2,2);
    end
    matrix3D(:,:,nSlice) = matrix2;
%     pause()
end

matrix3DOut = zeros(s.x,s.y,s.z);
for x = 1:s.x
    for y = 1:s.y
        for z = 1:s.z
            matrix3DOut(x,y,z) = matrix3D(y,x,z);
        end
    end
end

niftiwrite(matrix3DOut,outputFile);
delete([outputFile,'.gz']); %deletes .nii.gz temporal file
gzip(outputFile); %compress nii file
delete(outputFile); %deletes .nii temporal file

%save_untouch_nii(cortexNii,outputFile);
disp([outputFile,' saved']);

