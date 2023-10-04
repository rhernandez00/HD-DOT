function remappedMatrix = remapValues(matrix)
%Function created by chatGTP
    % Determine the current minimum and maximum values in the matrix
    minValue = min(matrix(:));
    maxValue = max(matrix(:));

    % Calculate the range of values
    valueRange = maxValue - minValue;

    % Map the values to the new range of 1 to 5
    remappedMatrix = 1 + (matrix - minValue) * 4 / valueRange;

    % Round the values to the nearest integers
    remappedMatrix = round(remappedMatrix);
end