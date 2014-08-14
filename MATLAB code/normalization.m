% Normalizes the n features in an m x (n+1) matrix
function normalization(filename)

% instance variables
mu = 0;
sigma = 0;

% Load excel file into m x (n+1) matrix
A = load(filename);


% For each feature, calculate mean and st. dev. Use these to normalize the
% values in each column
for j = 1:(size(A,2)-1)
    mu = mean(A(:,j));
    sigma = std(A(:,j));
    A(:,j) = (A(:,j) - mu)./sigma;
end    

xlswrite('normalized_data', A)

end

