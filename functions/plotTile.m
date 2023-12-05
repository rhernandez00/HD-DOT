function plotTile(tile,colorToUse)
markerSize = 8;
% extra = 1;
fieldsInTile = {'color1','color2','color3','midpoint'};
if nargin < 2
    colors = getColors(28);
    colors{4} = [0,0,0];
else
    colors{1} = colorToUse;
    colors{2} = colorToUse;
    colors{3} = colorToUse;
    colors{4} = colorToUse;
end

hold on
dList = zeros(1,numel(fieldsInTile)); %list of distances between coords
prevCoord = [0,0,0]; %previous coord is saved here
for nField = 1:numel(fieldsInTile)
    fieldName = fieldsInTile{nField};
    coords = tile.(fieldName);
    
    plot3(coords(1),coords(2),coords(3),'o','MarkerFaceColor',colors{nField},'MarkerEdgeColor',colors{nField},'MarkerSize',markerSize);
    dList(nField) = pdist2(prevCoord,coords); %checks the distances between points
    prevCoord = coords; %replace the coord once used
end
extra = mean(dList(2:end))*0.2;
coords = tile.midpoint;

text(coords(1)+extra,coords(2)+extra,coords(3)+extra,num2str(tile.tileNumber))
hold off