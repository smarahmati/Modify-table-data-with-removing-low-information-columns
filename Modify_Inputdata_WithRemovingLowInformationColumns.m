% Load the data
inputData = readtable('data_input_numeric.xlsx', 'VariableNamingRule', 'preserve');

% Get the number of rows in the data
numRows = size(inputData, 1);

% Initialize arrays to hold indices of columns to remove and their names
columnsToRemove = [];
removedColumns = table();  % Table to store removed columns

% Loop through each column
for i = 1:width(inputData)
    % Get the column name
    columnName = inputData.Properties.VariableNames{i};
    
    % Check if the column name contains 'Race'
    if contains(columnName, 'Race')
        continue;  % Skip this column
    end
    
    % Get the current column data
    columnData = inputData{:, i};
    
    % Find the most common value in the column
    [modeValue, frequency] = mode(columnData);
    
    % Calculate the percentage of the most common value
    percentage = (sum(columnData == modeValue) / numRows) * 100;
    
    % If 90% or more of the values are the same, mark the column for removal
    if percentage >= 90
        columnsToRemove = [columnsToRemove, i];
        removedColumns.(columnName) = columnData;  % Add the removed column to the removedColumns table
    end
end

% Remove the identified columns
inputData(:, columnsToRemove) = [];

% Save the modified data to a new Excel file
writetable(inputData, 'data_input_numeric_modified.xlsx');

% Save the removed columns to a new Excel file
if ~isempty(removedColumns)
    writetable(removedColumns, 'data_input_numeric_removed_columns.xlsx');
else
    fprintf('No columns were removed.\n');
end

% Display the final results
fprintf('Modified data saved to data_input_numeric_modified.xlsx.\n');
fprintf('Removed columns saved to data_input_numeric_removed_columns.xlsx.\n');
