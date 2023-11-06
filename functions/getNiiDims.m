function s = getNiiDims(rmap,voxSize,minSize)
%Given an rmap, a size of output voxel (voxSize), gives back s an structure
%that contains the dimensions the output nii should have
if nargin < 3
    minSize = 0.1;
end
if mod(voxSize,minSize) > 0
    error(['voxSize (voxSize=',num2str(voxSize),')should be a multiple of minSize (minSize=',num2str(minSize), ')']);
end

coordType = {'x','y','z'};
for n = 1:numel(coordType)
%     v = floor(min(rmap.headVolumeMesh.node(:,n)));
    s.(['min',coordType{n}]) = floor(min(rmap.headVolumeMesh.node(:,n)));
    s.(['max',coordType{n}]) = ceil(max(rmap.headVolumeMesh.node(:,n)));
    while mod(s.(['max',coordType{n}])-s.(['min',coordType{n}]),voxSize) > minSize
        %disp(['loop: ',num2str(nLoop)])
%         disp(['voxSize: ',num2str(voxSize)])
        %disp(['Mod is: ', num2str(mod(s.(['max',coordType{n}])-s.(['min',coordType{n}]),voxSize))]);
%         disp(['min is ', num2str(s.(['min',coordType{n}]))]);
%         disp(['max is ', num2str(s.(['max',coordType{n}]))]);
        
        s.(['max',coordType{n}]) = s.(['max',coordType{n}]) + minSize;
        %nLoop = nLoop + 1;
        %s
        %pause()
    end
    s.(['max',coordType{n}]) = round(s.(['max',coordType{n}]));
    s.(coordType{n}) = round(s.(['max',coordType{n}]) - s.(['min',coordType{n}]));
    %disp('Coord found')
    %s.(coordType{n})
end
