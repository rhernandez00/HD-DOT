function appProps = removeDuplicates(appProps)
%Removes tiles saved twice
possibleTiles = [appProps.tiles.tileNumber];
[~, w] = unique( possibleTiles, 'stable' );
duplicate_indices = setdiff( 1:numel(possibleTiles), w );
appProps.tiles(duplicate_indices) = [];