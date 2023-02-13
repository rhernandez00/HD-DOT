function e = calculateClusters(locationM,colorM,cutoff,minimalSize)
%given a point cloud with locationM and colorM matrices, a cutoff and a
%minimalSize for a cluster. Finds centers of the dots for all visible tiles 
%colorsInCloud = unique(colorM,'rows'); %checks each color separately
colorsInCloud = unique(colorM); %checks each color separately
for nColor = 1:size(colorsInCloud,1)
    disp(['Color: ',num2str(nColor), ' \ ',num2str(numel(colorsInCloud))]);
    color = colorsInCloud(nColor);
    %color = colorsInCloud(nColor,:);
    indx = colorM == color;
%     indx = false(size(colorM,1),1);
%     for ix = 1:size(colorM,1)
%         indx(ix) = isequal(color,colorM(ix,:));
%     end
    %locationOfColor = locationM(indx,:);
    locationOfColor = locationM(indx,:);
    Y = pdist(locationOfColor,'Euclidean');
    try
        Z = linkage(Y);
    catch
        size(locationOfColor)
        e = [];
        return
    end
    T = cluster(Z,'cutoff',cutoff, 'Criterion','distance');
    
    
    Tindx = false(size(T)); %clusters to keep
    clusPossible = unique(T);
    for nClus = 1:numel(clusPossible)
        indx = (T == nClus);
        if sum(indx) > minimalSize
            Tindx(indx) = true;
        else
            Tindx(indx) = false;
        end
        %Tindx(indx) = sum(indx) > minimalSize;
    end
    
    locationOfColor = locationOfColor(Tindx,:);
    
    Y = pdist(locationOfColor,'Euclidean');
    try
        Z = linkage(Y);
    catch
        colorsInCloud
        size(locationOfColor)
        %error('too few values')
        e = [];
        return
    end
    T = cluster(Z,'cutoff',cutoff, 'Criterion','distance');
    clusPossible = unique(T);
    
    %T = T(Tindx);
    [~,centers] = kmeans(locationOfColor,numel(clusPossible));
    
    e(nColor).clusters = T;
    e(nColor).locations = locationOfColor;
    e(nColor).centers = centers;
    e(nColor).color = color;
     
end