function [initialZ,finalZ] = determineRange(rmapNiiPath)

rmapNii = load_nii(rmapNiiPath);
mask = rmapNii.img >= 3 & rmapNii.img < 6; %filter out all non-brain related tissue

% Find the cropbox
[~,~,iz] = ind2sub(size(mask),find(mask));
initialZ = min(iz);
finalZ = max(iz);