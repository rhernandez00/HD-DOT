function M = find_transformation(set1, set2)
    % Find centroid of set1
    set1_centroid = mean(set1);
    % Center set1 coordinates around the centroid
    centered_set1 = set1 - set1_centroid;
    % Find centroid of set2
    set2_centroid = mean(set2);
    % Center set2 coordinates around the centroid
    centered_set2 = set2 - set2_centroid;
    % Calculate the cross-covariance matrix
    W = centered_set1' * centered_set2;
    % Calculate the rotation matrix using SVD
    [U,~,V] = svd(W);
    R = V*U';
    % Translation vector
    T = set2_centroid - set1_centroid*R';
    % Create transformation matrix
    M = [R, T'; 0 0 0 1];
end