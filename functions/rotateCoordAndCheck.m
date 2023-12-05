function [errorOut] = rotateCoordAndCheck(coords,mr)
%applies rotation mr to the three coords. Then calculates the sum of all y
%and all z
m = [0,0,0,mr(1),mr(2),mr(3)];
coordOut = zeros(size(coords));
for nC = 1:size(coords,1)
    coordOut(nC,:) = moveCoord(coords(nC,:),m);
    
end


%errorOut = pdist2(mean(coordOut),[0,0,0],'Euclidean');%sum(mean(coordOut));
%disp(errorOut)
errorOut = pdist2(coordOut(:,3)',[0,0,0],'Euclidean');
% errorOut = sum(abs(coordOut(:,3)));% + abs(coordOut(2,2) - coords(3,2)); 
% errorOut = abs(coordOut(1,3)) + abs(coordOut(1,3)) + abs(coordOut(1,3));
%errorOut = abs(coordOut(1,2)) + abs(coordOut(2,2)) + abs(coordOut(3,2)) + abs(coordOut(1,3)) + abs(coordOut(2,3)) + abs(coordOut(3,3));

% errorOut = sum(abs(coordOut(:,3)));% + sum(abs(coordOut(:,2))); %so that y = 0, z = 0